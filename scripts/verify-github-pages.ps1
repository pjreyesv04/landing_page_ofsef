# Script de Verificación Completa de GitHub Pages
Write-Host "=== VERIFICACIÓN DE GITHUB PAGES ===" -ForegroundColor Cyan

# URLs a verificar
$urls = @(
    "https://pjreyesv04.github.io/landing_page_ofsef",
    "https://pjreyesv04.github.io/landing_page_ofsef/images/backgrounds/family-hero.jpg",
    "https://pjreyesv04.github.io/landing_page_ofsef/_next/static/css/d9d7dfb855a1bc38.css"
)

Write-Host "`n📋 Verificando URLs de GitHub Pages:" -ForegroundColor Yellow

foreach ($url in $urls) {
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "  ✅ $url - Status: $($response.StatusCode)" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  $url - Status: $($response.StatusCode)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "  ❌ $url - Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Verificar archivos locales
Write-Host "`n📁 Verificando archivos locales generados:" -ForegroundColor Yellow

$localFiles = @(
    "out/index.html",
    "out/_next/static/css/d9d7dfb855a1bc38.css",
    "out/images/backgrounds/family-hero.jpg"
)

foreach ($file in $localFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "  ✅ $file - Tamaño: $size bytes" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file - No encontrado" -ForegroundColor Red
    }
}

# Verificar configuración
Write-Host "`n🔧 Verificando configuración:" -ForegroundColor Yellow

if (Test-Path "next.config.ts") {
    $config = Get-Content "next.config.ts" -Raw
    if ($config -match "basePath.*landing_page_ofsef") {
        Write-Host "  ✅ basePath configurado correctamente" -ForegroundColor Green
    } else {
        Write-Host "  ❌ basePath no configurado" -ForegroundColor Red
    }
    
    if ($config -match "assetPrefix.*landing_page_ofsef") {
        Write-Host "  ✅ assetPrefix configurado correctamente" -ForegroundColor Green
    } else {
        Write-Host "  ❌ assetPrefix no configurado" -ForegroundColor Red
    }
}

# Verificar GitHub Actions
Write-Host "`n🚀 Estado del proyecto:" -ForegroundColor Yellow
Write-Host "  📊 URL principal: https://pjreyesv04.github.io/landing_page_ofsef" -ForegroundColor Cyan
Write-Host "  🔗 GitHub Actions: https://github.com/pjreyesv04/landing_page_ofsef/actions" -ForegroundColor Cyan
Write-Host "  📱 Repositorio: https://github.com/pjreyesv04/landing_page_ofsef" -ForegroundColor Cyan

Write-Host "`n=== VERIFICACIÓN COMPLETADA ===" -ForegroundColor Cyan
