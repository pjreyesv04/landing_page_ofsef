# Script maestro - Flujo completo de despliegue
param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage,
    [switch]$SkipGitPush,
    [switch]$SkipDeploy
)

Write-Host "🚀 FLUJO COMPLETO DE DESPLIEGUE" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow
Write-Host "Mensaje: $CommitMessage" -ForegroundColor White
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$startTime = Get-Date

try {
    # PASO 1: Subir cambios a GitHub (si no se salta)
    if (-not $SkipGitPush) {
        Write-Host "1. 📤 Subiendo cambios a GitHub..." -ForegroundColor Cyan
        Write-Host "   Mensaje: $CommitMessage" -ForegroundColor White
        
        & "$scriptPath\commit-changes.ps1" -message $CommitMessage
        
        if ($LASTEXITCODE -ne 0) {
            throw "Error al subir cambios a GitHub"
        }
        Write-Host "   ✅ Subida a GitHub exitosa" -ForegroundColor Green
    } else {
        Write-Host "1. ⏭️  Saltando subida a GitHub..." -ForegroundColor Yellow
    }

    # PASO 2: Descargar desde GitHub al servidor
    Write-Host "`n2. 📥 Descargando desde GitHub al servidor..." -ForegroundColor Cyan
    
    & "$scriptPath\update-from-github.ps1"
    
    if ($LASTEXITCODE -ne 0) {
        throw "Error al descargar desde GitHub"
    }
    Write-Host "   ✅ Descarga desde GitHub exitosa" -ForegroundColor Green

    # PASO 3: Desplegar a producción (si no se salta)
    if (-not $SkipDeploy) {
        Write-Host "`n3. 🚀 Desplegando a producción..." -ForegroundColor Cyan
        
        & "$scriptPath\deploy-to-production.ps1"
        
        if ($LASTEXITCODE -ne 0) {
            throw "Error en despliegue a producción"
        }
        Write-Host "   ✅ Despliegue a producción exitoso" -ForegroundColor Green
    } else {
        Write-Host "`n3. ⏭️  Saltando despliegue a producción..." -ForegroundColor Yellow
    }

    # PASO 4: Verificación final
    Write-Host "`n4. ✅ Verificación final..." -ForegroundColor Cyan
    
    # Verificar que los archivos están en su lugar
    $checks = @(
        @{Path = "C:\inetpub\wwwroot\page_ofseg_dirisln\index.html"; Name = "Staging"},
        @{Path = "C:\inetpub\wwwroot\index.html"; Name = "Producción"}
    )
    
    foreach ($check in $checks) {
        if (Test-Path $check.Path) {
            $file = Get-Item $check.Path
            Write-Host "   ✓ $($check.Name): $($file.LastWriteTime)" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $($check.Name): Archivo no encontrado" -ForegroundColor Red
        }
    }

    # Calcular tiempo total
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    Write-Host "`n🎯 FLUJO COMPLETADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Yellow
    Write-Host "⏱️  Tiempo total: $($duration.TotalSeconds) segundos" -ForegroundColor White
    Write-Host "🔄 Flujo: Local → GitHub → Servidor → Producción" -ForegroundColor White
    Write-Host "🌐 Sitio disponible en: http://localhost/" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host "`n❌ ERROR EN EL FLUJO" -ForegroundColor Red
    Write-Host "===================" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 Soluciones sugeridas:" -ForegroundColor Yellow
    Write-Host "  - Verificar conexión a internet" -ForegroundColor White
    Write-Host "  - Revisar permisos de archivos" -ForegroundColor White
    Write-Host "  - Comprobar configuración de Git" -ForegroundColor White
    Write-Host "  - Verificar que IIS esté funcionando" -ForegroundColor White
    
    exit 1
}

Write-Host "📋 Opciones disponibles:" -ForegroundColor Cyan
Write-Host "  -SkipGitPush    : Saltar subida a GitHub" -ForegroundColor White
Write-Host "  -SkipDeploy     : Saltar despliegue a producción" -ForegroundColor White
Write-Host ""
Write-Host "📞 Ejemplos de uso:" -ForegroundColor Cyan
Write-Host "  .\full-deployment.ps1 -CommitMessage 'Actualizar contacto'" -ForegroundColor White
Write-Host "  .\full-deployment.ps1 -CommitMessage 'Fix bug' -SkipGitPush" -ForegroundColor White
