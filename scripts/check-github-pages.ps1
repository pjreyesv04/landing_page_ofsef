# Script para verificar el estado de GitHub Pages
Write-Host "=== DIAGNÓSTICO DE GITHUB PAGES ===" -ForegroundColor Cyan

# Verificar si los archivos están en el directorio out
Write-Host "`n1. Verificando archivos en directorio 'out':" -ForegroundColor Yellow
if (Test-Path "out") {
    Get-ChildItem "out" -Recurse | Select-Object Name, Length | Format-Table -AutoSize
} else {
    Write-Host "   ❌ Directorio 'out' no encontrado" -ForegroundColor Red
}

# Verificar la configuración de next.config.ts
Write-Host "`n2. Verificando configuración de Next.js:" -ForegroundColor Yellow
if (Test-Path "next.config.ts") {
    Write-Host "   📄 Contenido de next.config.ts:" -ForegroundColor Green
    Get-Content "next.config.ts"
} else {
    Write-Host "   ❌ next.config.ts no encontrado" -ForegroundColor Red
}

# Verificar package.json scripts
Write-Host "`n3. Verificando scripts en package.json:" -ForegroundColor Yellow
if (Test-Path "package.json") {
    $packageJson = Get-Content "package.json" | ConvertFrom-Json
    Write-Host "   📄 Scripts disponibles:" -ForegroundColor Green
    $packageJson.scripts | Format-List
} else {
    Write-Host "   ❌ package.json no encontrado" -ForegroundColor Red
}

# Verificar el workflow de GitHub Actions
Write-Host "`n4. Verificando workflow de GitHub Actions:" -ForegroundColor Yellow
if (Test-Path ".github/workflows/deploy.yml") {
    Write-Host "   📄 Contenido del workflow:" -ForegroundColor Green
    Get-Content ".github/workflows/deploy.yml"
} else {
    Write-Host "   ❌ Workflow de GitHub Actions no encontrado" -ForegroundColor Red
}

Write-Host "`n=== FIN DEL DIAGNÓSTICO ===" -ForegroundColor Cyan
