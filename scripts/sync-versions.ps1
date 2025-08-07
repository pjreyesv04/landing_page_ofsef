# Script de Sincronización - Mantener las 4 versiones actualizadas
# Ejecutar como Administrador

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("LocalToAll", "ProdToAll", "GithubToAll")]
    [string]$Direction
)

$paths = @{
    "Local" = "C:\ruta\tu\proyecto\local"  # CAMBIAR POR TU RUTA LOCAL
    "Github" = "C:\inetpub\wwwroot\page_ofseg_dirisln"  # Carpeta clonada de GitHub
    "Staging" = "C:\inetpub\wwwroot\page_ofseg_dirisln"
    "Production" = "C:\inetpub\wwwroot"
}

Write-Host "=== SINCRONIZACIÓN DE ARCHIVOS ===" -ForegroundColor Yellow

switch ($Direction) {
    "LocalToAll" {
        Write-Host "Copiando desde LOCAL a todos los destinos..." -ForegroundColor Cyan
        $source = $paths.Local
        
        # A Staging
        Copy-Item "$source\*" $paths.Staging -Recurse -Force
        Write-Host "✓ Local → Staging" -ForegroundColor Green
        
        # A Production (solo archivos principales)
        Copy-Item "$source\index.html" $paths.Production -Force
        Copy-Item "$source\_next" "$($paths.Production)\_next" -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item "$source\images" "$($paths.Production)\images" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Local → Production" -ForegroundColor Green
    }
    
    "ProdToAll" {
        Write-Host "Copiando desde PRODUCTION a otros destinos..." -ForegroundColor Cyan
        $source = $paths.Production
        
        # A Staging
        Copy-Item "$source\index.html" "$($paths.Staging)\index.html" -Force
        Write-Host "✓ Production → Staging" -ForegroundColor Green
        
        Write-Host "💡 Recuerda subir cambios a GitHub manualmente" -ForegroundColor Yellow
    }
    
    "GithubToAll" {
        Write-Host "Actualizando desde GITHUB..." -ForegroundColor Cyan
        
        # Pull desde GitHub (requiere configuración previa)
        Set-Location $paths.Github
        git pull origin master
        
        # Copiar a Production
        Copy-Item "$($paths.Github)\index.html" $paths.Production -Force
        Copy-Item "$($paths.Github)\_next" "$($paths.Production)\_next" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✓ GitHub → Production" -ForegroundColor Green
    }
}

Write-Host "`n=== VERIFICACIÓN ===" -ForegroundColor Yellow
Write-Host "Producción: http://localhost/" -ForegroundColor White
Write-Host "Staging: Revisar archivos en página subcarpeta" -ForegroundColor White

Write-Host "`n✅ Sincronización completada" -ForegroundColor Green
