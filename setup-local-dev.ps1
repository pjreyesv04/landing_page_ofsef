# Script para configurar ambiente de desarrollo local
# Ejecutar desde PowerShell como administrador

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   CONFIGURACIÓN DESARROLLO LOCAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar prerrequisitos
Write-Host "🔍 Verificando prerrequisitos..." -ForegroundColor Yellow
Write-Host ""

# Verificar Node.js
$nodeVersion = & node --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js no está instalado" -ForegroundColor Red
    Write-Host "   Instalar desde: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Verificar Git
$gitVersion = & git --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Git: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Git no está instalado" -ForegroundColor Red
    Write-Host "   Instalar desde: https://git-scm.com/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📂 Configurando directorio de desarrollo..." -ForegroundColor Yellow

# Crear directorio de desarrollo
$devPath = "C:\Desarrollo\page_ofseg_dirisln"
if (!(Test-Path $devPath)) {
    New-Item -ItemType Directory -Force -Path $devPath | Out-Null
    Write-Host "✅ Directorio creado: $devPath" -ForegroundColor Green
} else {
    Write-Host "✅ Directorio existe: $devPath" -ForegroundColor Green
}

# Cambiar al directorio
Set-Location $devPath
Write-Host "📍 Ubicación actual: $devPath" -ForegroundColor Blue

Write-Host ""
Write-Host "📥 Clonando repositorio desde GitHub..." -ForegroundColor Yellow

# Clonar repositorio
if (Test-Path ".git") {
    Write-Host "✅ Repositorio ya existe - sincronizando con GitHub..." -ForegroundColor Green
    & git pull origin master
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Sincronización completada desde GitHub" -ForegroundColor Green
    } else {
        Write-Host "❌ Error sincronizando con GitHub" -ForegroundColor Red
        Write-Host "💡 Puede que necesites configurar credenciales de Git" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "📦 Clonando repositorio completo desde GitHub..." -ForegroundColor Yellow
    & git clone https://github.com/pjreyesv04/landing_page_ofsef.git .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Repositorio clonado exitosamente desde GitHub" -ForegroundColor Green
    } else {
        Write-Host "❌ Error clonando repositorio" -ForegroundColor Red
        Write-Host "💡 Verificar conexión a internet y acceso a GitHub" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "⚙️  Configurando ambiente LOCAL..." -ForegroundColor Yellow

# Copiar configuración local
if (Test-Path "next.config.local.ts") {
    Copy-Item "next.config.local.ts" "next.config.ts" -Force
    Write-Host "✅ Configuración LOCAL aplicada" -ForegroundColor Green
} else {
    Write-Host "❌ No se encuentra next.config.local.ts" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📦 Instalando dependencias..." -ForegroundColor Yellow

# Instalar dependencias
& npm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencias instaladas exitosamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error instalando dependencias" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🏗️  Construyendo proyecto..." -ForegroundColor Yellow

# Build del proyecto
& npm run build
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Proyecto construido exitosamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error construyendo proyecto" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   CONFIGURACIÓN LOCAL COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Para iniciar desarrollo:" -ForegroundColor Cyan
Write-Host "   cd $devPath" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "🌐 El sitio estará disponible en:" -ForegroundColor Cyan
Write-Host "   http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "📋 Comandos útiles:" -ForegroundColor Cyan
Write-Host "   npm run dev     - Servidor de desarrollo" -ForegroundColor White
Write-Host "   npm run build   - Construir para producción" -ForegroundColor White
Write-Host "   npm run start   - Servidor de producción local" -ForegroundColor White
Write-Host "   npm run lint    - Verificar código" -ForegroundColor White
Write-Host ""
Write-Host "🔄 Flujo de desarrollo:" -ForegroundColor Cyan
Write-Host "   1. SIEMPRE: git pull origin master (sincronizar)" -ForegroundColor White
Write-Host "   2. Desarrollar localmente con npm run dev" -ForegroundColor White
Write-Host "   3. git add . && git commit -m 'mensaje'" -ForegroundColor White
Write-Host "   4. git push origin master (subir cambios)" -ForegroundColor White
Write-Host "   5. En servidor: deploy-staging.bat" -ForegroundColor White
Write-Host "   6. Verificar staging" -ForegroundColor White
Write-Host "   7. En servidor: deploy-production.bat para producción" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  IMPORTANTE: Siempre hacer 'git pull' antes de trabajar" -ForegroundColor Red
Write-Host "   para sincronizar con los cambios más recientes" -ForegroundColor Red
Write-Host ""
