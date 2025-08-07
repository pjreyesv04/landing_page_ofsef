# Script para descargar cambios desde GitHub
Write-Host "🔄 Actualizando desde GitHub..." -ForegroundColor Yellow

# Navegar a carpeta de GitHub en el servidor
$githubPath = "C:\inetpub\wwwroot\page_ofseg_dirisln"

if (-not (Test-Path $githubPath)) {
    Write-Host "❌ Carpeta de GitHub no encontrada: $githubPath" -ForegroundColor Red
    Write-Host "💡 Primero clona el repositorio:" -ForegroundColor Yellow
    Write-Host "   git clone https://github.com/pjreyesv04/landing_page_ofsef.git page_ofseg_dirisln" -ForegroundColor White
    exit 1
}

Set-Location $githubPath

# Verificar que es un repositorio Git
if (-not (Test-Path ".git")) {
    Write-Host "❌ No es un repositorio Git válido" -ForegroundColor Red
    exit 1
}

# Descargar últimos cambios
Write-Host "📥 Descargando desde GitHub..." -ForegroundColor Cyan
git fetch origin

# Mostrar cambios disponibles
$behind = git rev-list --count HEAD..origin/master
if ($behind -gt 0) {
    Write-Host "📋 Hay $behind commits nuevos disponibles" -ForegroundColor Yellow
    git log --oneline HEAD..origin/master
} else {
    Write-Host "✅ Ya estás actualizado" -ForegroundColor Green
}

# Aplicar cambios
Write-Host "🔄 Aplicando cambios..." -ForegroundColor Cyan
git pull origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Descarga exitosa desde GitHub" -ForegroundColor Green
    
    # Mostrar archivos modificados
    Write-Host "`n📁 Archivos en staging:" -ForegroundColor Cyan
    Get-ChildItem -Name | Where-Object { $_ -match '\.(html|css|js|json)$' } | ForEach-Object {
        $file = Get-Item $_
        Write-Host "  $_ - $($file.LastWriteTime)" -ForegroundColor White
    }
} else {
    Write-Host "❌ Error al descargar desde GitHub" -ForegroundColor Red
    exit 1
}
