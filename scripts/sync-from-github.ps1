# Script para sincronizar con GitHub y generar build local
# Archivo: sync-from-github.ps1

param(
    [string]$GitHubUrl = "https://github.com/pjreyesv04/landing_page_ofsef.git",
    [string]$LocalPath = "c:\inetpub\wwwroot\page_ofseg_dirisln",
    [string]$TempPath = "c:\temp\landing_page_ofsef_temp"
)

Write-Host "🔄 Iniciando sincronización desde GitHub..." -ForegroundColor Green

# 1. Crear backup del index.html actual (si está modificado)
if (Test-Path "$LocalPath\index.html") {
    Write-Host "📁 Creando backup del index.html actual..."
    Copy-Item "$LocalPath\index.html" "$LocalPath\index.html.local.backup" -Force
}

# 2. Limpiar directorio temporal
if (Test-Path $TempPath) {
    Remove-Item $TempPath -Recurse -Force
}

# 3. Clonar repositorio desde GitHub
Write-Host "📥 Descargando desde GitHub..."
git clone $GitHubUrl $TempPath

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al clonar repositorio" -ForegroundColor Red
    exit 1
}

# 4. Ir al directorio temporal
Set-Location $TempPath

# 5. Instalar dependencias
Write-Host "📦 Instalando dependencias..."
npm install

# 6. Usar configuración local para el build
Write-Host "⚙️ Configurando para build local..."
Copy-Item "next.config.ts" "next.config.github.ts" -Force
Copy-Item "$LocalPath\next.config.local.ts" "next.config.ts" -Force

# 7. Generar build para local
Write-Host "🔨 Generando build para servidor local..."
npm run build

# 8. Copiar archivos generados al servidor local
Write-Host "📋 Copiando archivos al servidor local..."

# Backup de archivos importantes del servidor local
$backupItems = @("web.config", "diagnostico.html", "test.html", "*.backup")
foreach ($item in $backupItems) {
    if (Test-Path "$LocalPath\$item") {
        Copy-Item "$LocalPath\$item" "$TempPath\out\" -Force
        Write-Host "💾 Backup: $item"
    }
}

# Limpiar directorio local (excepto backups)
Get-ChildItem $LocalPath -Exclude "*.backup", "diagnostico.html", "test.html" | Remove-Item -Recurse -Force

# Copiar nuevos archivos
Copy-Item "$TempPath\out\*" $LocalPath -Recurse -Force

# 9. Aplicar configuraciones específicas del servidor local
Write-Host "🔧 Aplicando configuraciones locales..."

# Corregir rutas en index.html
$indexContent = Get-Content "$LocalPath\index.html" -Raw
$indexContent = $indexContent -replace '/landing_page_ofsef/', '/page_ofseg_dirisln/'
Set-Content "$LocalPath\index.html" $indexContent

# 10. Limpiar directorio temporal
Set-Location $LocalPath
Remove-Item $TempPath -Recurse -Force

Write-Host "✅ Sincronización completada!" -ForegroundColor Green
Write-Host "🌐 Tu sitio local está actualizado con la versión de GitHub" -ForegroundColor Cyan
Write-Host "📍 URL local: http://localhost/page_ofseg_dirisln/" -ForegroundColor Yellow

# 11. Reiniciar IIS para aplicar cambios
Write-Host "🔄 Reiniciando IIS..."
iisreset

Write-Host "🎉 ¡Todo listo! La página está sincronizada y funcionando." -ForegroundColor Green
