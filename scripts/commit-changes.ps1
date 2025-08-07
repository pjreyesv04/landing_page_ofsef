# Script para subir cambios a GitHub
param([string]$message = "Actualización de contenido")

Write-Host "🔄 Subiendo cambios a GitHub..." -ForegroundColor Cyan

# Verificar si estamos en un repositorio Git
if (-not (Test-Path ".git")) {
    Write-Host "❌ No estás en un repositorio Git" -ForegroundColor Red
    Write-Host "Navega a tu carpeta de proyecto local primero" -ForegroundColor Yellow
    exit 1
}

# Verificar estado del repositorio
Write-Host "📋 Verificando estado..." -ForegroundColor Yellow
git status --porcelain

# Agregar todos los cambios
Write-Host "📦 Agregando archivos..." -ForegroundColor Yellow
git add .

# Hacer commit
Write-Host "💾 Creando commit: $message" -ForegroundColor Yellow
git commit -m $message

# Subir a GitHub
Write-Host "📤 Subiendo a GitHub..." -ForegroundColor Yellow
git push origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Cambios subidos exitosamente a GitHub" -ForegroundColor Green
} else {
    Write-Host "❌ Error al subir a GitHub" -ForegroundColor Red
    exit 1
}
