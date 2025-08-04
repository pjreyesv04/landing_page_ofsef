# Script simplificado para sincronización rápida
# Archivo: quick-sync.ps1

Write-Host "🚀 Sincronización rápida desde GitHub..." -ForegroundColor Cyan

# Ir al directorio del proyecto
Set-Location "c:\inetpub\wwwroot\page_ofseg_dirisln"

# Pull de cambios desde GitHub
Write-Host "📥 Descargando cambios..."
git pull origin master

# Si hay cambios en el código fuente, regenerar build
if (Test-Path "package.json") {
    Write-Host "🔨 Regenerando build..."
    
    # Usar configuración local
    if (Test-Path "next.config.local.ts") {
        Copy-Item "next.config.ts" "next.config.github.ts" -Force
        Copy-Item "next.config.local.ts" "next.config.ts" -Force
    }
    
    npm run build
    
    # Copiar archivos del build
    if (Test-Path "out") {
        Copy-Item "out\*" "." -Recurse -Force
    }
    
    # Corregir rutas
    if (Test-Path "index.html") {
        $content = Get-Content "index.html" -Raw
        $content = $content -replace '/landing_page_ofsef/', '/page_ofseg_dirisln/'
        Set-Content "index.html" $content
    }
    
    # Restaurar configuración de GitHub
    if (Test-Path "next.config.github.ts") {
        Copy-Item "next.config.github.ts" "next.config.ts" -Force
    }
}

Write-Host "✅ Sincronización completada!" -ForegroundColor Green
