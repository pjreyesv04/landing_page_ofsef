# Script de Sincronización GitHub - DIRIS Lima Norte
# Sincroniza cambios locales con GitHub y activa GitHub Pages

param(
    [string]$message = "Actualización automática $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    [switch]$force = $false
)

Write-Host "=== SINCRONIZACIÓN GITHUB - DIRIS LIMA NORTE ===" -ForegroundColor Green
Write-Host "Mensaje: $message" -ForegroundColor Yellow

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "package.json")) {
    Write-Error "❌ No se encontró package.json. Ejecutar desde d:\proyecto\"
    exit 1
}

try {
    # 1. Verificar estado de Git
    Write-Host "1. Verificando estado de Git..." -ForegroundColor Cyan
    $gitStatus = git status --porcelain
    
    if ($gitStatus -and -not $force) {
        Write-Host "📝 Archivos modificados encontrados:" -ForegroundColor Yellow
        git status --short
        
        $confirm = Read-Host "¿Continuar con la sincronización? (s/n)"
        if ($confirm -ne "s" -and $confirm -ne "S") {
            Write-Host "❌ Sincronización cancelada" -ForegroundColor Red
            exit 0
        }
    }

    # 2. Build para GitHub Pages
    Write-Host "2. Generando build para GitHub Pages..." -ForegroundColor Cyan
    npm run build:github
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en build de GitHub"
        exit 1
    }

    # 3. Agregar cambios a Git
    Write-Host "3. Agregando cambios a Git..." -ForegroundColor Cyan
    git add .

    # 4. Commit
    Write-Host "4. Realizando commit..." -ForegroundColor Cyan
    git commit -m "$message"

    # 5. Push a GitHub
    Write-Host "5. Subiendo a GitHub..." -ForegroundColor Cyan
    git push origin master

    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error al subir a GitHub"
        exit 1
    }

    # 6. Verificar GitHub Pages
    Write-Host "6. Verificando GitHub Pages..." -ForegroundColor Cyan
    Write-Host "🌐 GitHub Pages: https://pjreyesv04.github.io/landing_page_ofsef/" -ForegroundColor Green
    Write-Host "⏱️  Nota: GitHub Pages puede tardar 1-2 minutos en actualizarse" -ForegroundColor Yellow

    # 7. Generar reporte
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $report = @"
=== SINCRONIZACIÓN GITHUB COMPLETADA ===
Fecha: $timestamp
Mensaje: $message
Estado: EXITOSO
URL: https://pjreyesv04.github.io/landing_page_ofsef/
"@

    Write-Host "`n✅ SINCRONIZACIÓN GITHUB COMPLETADA" -ForegroundColor Green
    Write-Host $report -ForegroundColor White

    # Guardar log
    Add-Content -Path "sync\github-sync.log" -Value $report

} catch {
    Write-Error "❌ Error durante sincronización: $_"
    exit 1
}
