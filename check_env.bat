@echo off
REM Script de verificación de configuración de entorno para Windows
REM Ejecuta: check_env.bat

echo Verificando configuracion de variables de entorno...
echo.

REM Verificar si existe .env
if exist .env (
    echo [OK] Archivo .env encontrado
) else (
    echo [ERROR] Archivo .env NO encontrado
    echo    Ejecuta: copy .env.example .env
    echo    Luego edita .env con tus credenciales
    exit /b 1
)

REM Verificar si .env está en .gitignore
findstr /C:".env" .gitignore >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] .env esta en .gitignore
) else (
    echo [ADVERTENCIA] .env NO esta en .gitignore
    echo    Agrega '.env' al archivo .gitignore
)

REM Verificar si .env tiene contenido
for %%A in (.env) do set size=%%~zA
if %size% GTR 0 (
    echo [OK] Archivo .env tiene contenido
    
    REM Verificar variables específicas
    findstr /C:"SUPABASE_URL=" .env >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Variable SUPABASE_URL configurada
    ) else (
        echo [ERROR] Variable SUPABASE_URL NO configurada
    )
    
    findstr /C:"SUPABASE_ANON_KEY=" .env >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Variable SUPABASE_ANON_KEY configurada
    ) else (
        echo [ERROR] Variable SUPABASE_ANON_KEY NO configurada
    )
) else (
    echo [ERROR] Archivo .env esta vacio
)

REM Verificar si .env está en git staging
git ls-files --error-unmatch .env >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [PELIGRO] .env esta rastreado por Git!
    echo    Ejecuta: git rm --cached .env
) else (
    echo [OK] .env NO esta rastreado por Git (correcto)
)

echo.
echo Verificacion completada
pause
