# Script para sincronizar los tres archivos
# PC Local -> GitHub -> Servidor IIS

param(
    [string]$GitHubRepo = "https://github.com/pjreyesv04/landing_page_ofsef.git",
    [string]$LocalPath = "c:\inetpub\wwwroot\page_ofseg_dirisln",
    [switch]$PushToGitHub,
    [switch]$PullFromGitHub
)

Write-Host "=== SINCRONIZACIÓN DE ARCHIVOS ===" -ForegroundColor Green
Write-Host "1. PC Local (original)"
Write-Host "2. GitHub Repository"
Write-Host "3. Servidor IIS (con modificaciones de rutas)"
Write-Host "=================================" -ForegroundColor Green

# Función para aplicar las modificaciones de rutas para IIS
function Apply-IISPaths {
    param([string]$FilePath)
    
    Write-Host "Aplicando rutas para IIS..." -ForegroundColor Yellow
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw
        
        # Reemplazar rutas de GitHub Pages con rutas locales
        $content = $content -replace '/landing_page_ofsef/', '/page_ofseg_dirisln/'
        $content = $content -replace '"/landing_page_ofsef"', '"/page_ofseg_dirisln"'
        $content = $content -replace "'\/landing_page_ofsef'", "'\/page_ofseg_dirisln'"
        
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "✓ Rutas actualizadas para IIS" -ForegroundColor Green
    }
}

# Función para revertir rutas a formato GitHub
function Revert-GitHubPaths {
    param([string]$FilePath)
    
    Write-Host "Revirtiendo rutas para GitHub..." -ForegroundColor Yellow
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw
        
        # Reemplazar rutas locales con rutas de GitHub Pages
        $content = $content -replace '/page_ofseg_dirisln/', '/landing_page_ofsef/'
        $content = $content -replace '"/page_ofseg_dirisln"', '"/landing_page_ofsef"'
        $content = $content -replace "'\/page_ofseg_dirisln'", "'\/landing_page_ofsef'"
        
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "✓ Rutas revertidas para GitHub" -ForegroundColor Green
    }
}

# Cambiar al directorio del proyecto
Set-Location $LocalPath

if ($PullFromGitHub) {
    Write-Host "`n--- SINCRONIZANDO DESDE GITHUB ---" -ForegroundColor Cyan
    
    # 1. Hacer backup del index.html actual (con rutas IIS)
    if (Test-Path "index.html") {
        Copy-Item "index.html" "index.html.iis.backup" -Force
        Write-Host "✓ Backup creado: index.html.iis.backup" -ForegroundColor Green
    }
    
    # 2. Obtener cambios desde GitHub
    Write-Host "Obteniendo cambios desde GitHub..." -ForegroundColor Yellow
    git pull origin master
    
    # 3. Aplicar rutas para IIS
    Apply-IISPaths -FilePath "index.html"
    
    Write-Host "✓ Sincronización desde GitHub completada" -ForegroundColor Green
}

if ($PushToGitHub) {
    Write-Host "`n--- SINCRONIZANDO HACIA GITHUB ---" -ForegroundColor Cyan
    
    # 1. Crear backup del archivo actual
    if (Test-Path "index.html") {
        Copy-Item "index.html" "index.html.iis.backup" -Force
    }
    
    # 2. Revertir rutas para GitHub
    Revert-GitHubPaths -FilePath "index.html"
    
    # 3. Agregar cambios a Git
    Write-Host "Agregando cambios a Git..." -ForegroundColor Yellow
    git add .
    git commit -m "Sync from IIS server - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    
    # 4. Subir a GitHub
    Write-Host "Subiendo cambios a GitHub..." -ForegroundColor Yellow
    git push origin master
    
    # 5. Restaurar rutas para IIS
    Apply-IISPaths -FilePath "index.html"
    
    Write-Host "✓ Sincronización hacia GitHub completada" -ForegroundColor Green
}

if (-not $PullFromGitHub -and -not $PushToGitHub) {
    Write-Host "`nUso del script:" -ForegroundColor Yellow
    Write-Host "Para sincronizar DESDE GitHub:  .\sync-all-locations.ps1 -PullFromGitHub" -ForegroundColor White
    Write-Host "Para sincronizar HACIA GitHub:  .\sync-all-locations.ps1 -PushToGitHub" -ForegroundColor White
    Write-Host "`nEjemplos de flujo de trabajo:" -ForegroundColor Yellow
    Write-Host "1. Hiciste cambios en tu PC local y los subiste a GitHub:" -ForegroundColor White
    Write-Host "   .\sync-all-locations.ps1 -PullFromGitHub" -ForegroundColor Cyan
    Write-Host "`n2. Hiciste cambios en el servidor IIS y quieres subirlos:" -ForegroundColor White
    Write-Host "   .\sync-all-locations.ps1 -PushToGitHub" -ForegroundColor Cyan
}

Write-Host "`n=== SINCRONIZACIÓN FINALIZADA ===" -ForegroundColor Green
