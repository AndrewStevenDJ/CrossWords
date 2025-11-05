#!/bin/bash

# Script de verificación de configuración de entorno
# Ejecuta: bash check_env.sh

echo "🔍 Verificando configuración de variables de entorno..."
echo ""

# Verificar si existe .env
if [ -f ".env" ]; then
    echo "✅ Archivo .env encontrado"
else
    echo "❌ Archivo .env NO encontrado"
    echo "   Ejecuta: cp .env.example .env"
    echo "   Luego edita .env con tus credenciales"
    exit 1
fi

# Verificar si .env está en .gitignore
if grep -q "^\.env$" .gitignore; then
    echo "✅ .env está en .gitignore"
else
    echo "⚠️  .env NO está en .gitignore"
    echo "   Agrega '.env' al archivo .gitignore"
fi

# Verificar si .env tiene contenido
if [ -s ".env" ]; then
    echo "✅ Archivo .env tiene contenido"
    
    # Verificar variables específicas (sin mostrar valores)
    if grep -q "SUPABASE_URL=" .env; then
        echo "✅ Variable SUPABASE_URL configurada"
    else
        echo "❌ Variable SUPABASE_URL NO configurada"
    fi
    
    if grep -q "SUPABASE_ANON_KEY=" .env; then
        echo "✅ Variable SUPABASE_ANON_KEY configurada"
    else
        echo "❌ Variable SUPABASE_ANON_KEY NO configurada"
    fi
else
    echo "❌ Archivo .env está vacío"
fi

# Verificar si .env está en git staging
if git ls-files --error-unmatch .env 2>/dev/null; then
    echo "⚠️  PELIGRO: .env está rastreado por Git!"
    echo "   Ejecuta: git rm --cached .env"
else
    echo "✅ .env NO está rastreado por Git (correcto)"
fi

echo ""
echo "🎉 Verificación completada"
