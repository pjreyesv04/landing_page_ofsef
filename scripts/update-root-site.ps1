# Script para actualizar el sitio en la raíz de IIS
# Uso: .\update-root-site.ps1

param(
    [string]$SourcePath = "c:\inetpub\wwwroot\page_ofseg_dirisln",
    [string]$RootPath = "c:\inetpub\wwwroot"
)

Write-Host "=== ACTUALIZANDO SITIO EN LA RAÍZ DE IIS ===" -ForegroundColor Green
Write-Host "Origen: $SourcePath" -ForegroundColor Yellow
Write-Host "Destino: $RootPath" -ForegroundColor Yellow

# Verificar que existen los directorios
if (-not (Test-Path $SourcePath)) {
    Write-Host "ERROR: No existe el directorio origen $SourcePath" -ForegroundColor Red
    exit 1
}

# 1. Hacer backup del index.html actual en la raíz
if (Test-Path "$RootPath\index.html") {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item "$RootPath\index.html" "$RootPath\index.html.backup_$timestamp" -Force
    Write-Host "✓ Backup creado: index.html.backup_$timestamp" -ForegroundColor Green
}

# 2. Convertir rutas del archivo fuente
Write-Host "Convirtiendo rutas para la raíz..." -ForegroundColor Yellow
$content = Get-Content "$SourcePath\index.html" -Raw

# Si el archivo tiene rutas de GitHub, convertir a subcarpeta primero
if ($content -match '/landing_page_ofsef/') {
    $content = $content -replace '/landing_page_ofsef/', '/page_ofseg_dirisln/'
    $content = $content -replace '"/landing_page_ofsef"', '"/page_ofseg_dirisln"'
    Write-Host "→ Rutas GitHub convertidas a subcarpeta" -ForegroundColor Cyan
}

# Convertir rutas de subcarpeta a raíz
$content = $content -replace '/page_ofseg_dirisln/', '/'
$content = $content -replace '"/page_ofseg_dirisln"', '"/"'

# Guardar el archivo convertido
Set-Content "$RootPath\index.html.new" $content -Encoding UTF8
Write-Host "✓ Archivo convertido guardado como index.html.new" -ForegroundColor Green

# 3. Copiar recursos necesarios
Write-Host "Copiando recursos..." -ForegroundColor Yellow

# Copiar _next si existe
if (Test-Path "$SourcePath\_next") {
    Copy-Item "$SourcePath\_next" "$RootPath\_next" -Recurse -Force
    Write-Host "✓ Carpeta _next copiada" -ForegroundColor Green
}

# Copiar images si existe
if (Test-Path "$SourcePath\images") {
    Copy-Item "$SourcePath\images" "$RootPath\images" -Recurse -Force
    Write-Host "✓ Carpeta images copiada" -ForegroundColor Green
}

# Copiar archivos estáticos (iconos, etc.)
$staticFiles = @("*.png", "*.ico", "*.svg", "*.webmanifest", "*.txt")
foreach ($pattern in $staticFiles) {
    $files = Get-ChildItem "$SourcePath\$pattern" -ErrorAction SilentlyContinue
    if ($files) {
        Copy-Item $files.FullName $RootPath -Force
        Write-Host "✓ Archivos $pattern copiados" -ForegroundColor Green
    }
}

# Copiar web.config si existe
if (Test-Path "$SourcePath\web.config") {
    Copy-Item "$SourcePath\web.config" "$RootPath\web.config" -Force
    Write-Host "✓ web.config copiado" -ForegroundColor Green
}

# 4. Activar el nuevo archivo
Copy-Item "$RootPath\index.html.new" "$RootPath\index.html" -Force
Remove-Item "$RootPath\index.html.new" -Force
Write-Host "✓ Sitio activado en la raíz" -ForegroundColor Green

Write-Host "`n=== ACTUALIZACIÓN COMPLETADA ===" -ForegroundColor Green
Write-Host "El sitio está ahora disponible en: http://localhost" -ForegroundColor Cyan
Write-Host "Ubicación: $RootPath\index.html" -ForegroundColor Cyan
