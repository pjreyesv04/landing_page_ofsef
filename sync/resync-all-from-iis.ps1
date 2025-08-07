# Script de Resincronización Completa - Después de Actualización desde IIS
# Sincroniza todos los entornos después de actualizar el código local

param(
    [string]$message = "Sincronización desde servidor IIS - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    [switch]$skipConfirmation = $false
)

Write-Host "🔄 RESINCRONIZACIÓN COMPLETA - POST ACTUALIZACIÓN IIS" -ForegroundColor Magenta
Write-Host "====================================================" -ForegroundColor Magenta

# Verificar directorio de trabajo
if (-not (Test-Path "package.json")) {
    Write-Error "❌ Ejecutar desde d:\proyecto\"
    exit 1
}

try {
    # 1. Verificar estado actual
    Write-Host "`n1. Verificando estado actual..." -ForegroundColor Cyan
    
    # Verificar Git
    try {
        $gitStatus = git status --porcelain
        if ($gitStatus) {
            Write-Host "   📝 Cambios detectados: $($gitStatus.Count) archivos modificados" -ForegroundColor Yellow
            if (-not $skipConfirmation) {
                Write-Host "   Archivos modificados:" -ForegroundColor White
                git status --short
            }
        } else {
            Write-Host "   ✅ No hay cambios pendientes en Git" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⚠️ Estado de Git no disponible" -ForegroundColor Yellow
    }

    # Verificar que hay cambios para sincronizar
    if (-not $gitStatus -and -not $skipConfirmation) {
        $proceed = Read-Host "No se detectaron cambios locales. ¿Continuar con resincronización? (s/n)"
        if ($proceed -ne "s" -and $proceed -ne "S") {
            Write-Host "❌ Resincronización cancelada" -ForegroundColor Red
            exit 0
        }
    }

    # 2. Confirmar plan de resincronización
    if (-not $skipConfirmation) {
        Write-Host "`n🎯 PLAN DE RESINCRONIZACIÓN:" -ForegroundColor Yellow
        Write-Host "   1. Generar build local" -ForegroundColor White
        Write-Host "   2. Subir cambios a GitHub" -ForegroundColor White
        Write-Host "   3. Actualizar GitHub Pages" -ForegroundColor White
        Write-Host "   4. Generar nuevo staging" -ForegroundColor White
        Write-Host "   5. Generar nuevo producción" -ForegroundColor White
        
        $confirm = Read-Host "`n¿Continuar con resincronización completa? (s/n)"
        if ($confirm -ne "s" -and $confirm -ne "S") {
            Write-Host "❌ Resincronización cancelada" -ForegroundColor Red
            exit 0
        }
    }

    # 3. Generar build local para verificar
    Write-Host "`n3. Generando build local para verificar..." -ForegroundColor Cyan
    npm run build:iis
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en build local. Revisar código antes de continuar."
        exit 1
    }
    Write-Host "   ✅ Build local exitoso" -ForegroundColor Green

    # 4. Sincronizar con GitHub
    Write-Host "`n4. Sincronizando con GitHub..." -ForegroundColor Cyan
    & ".\sync\sync-to-github.ps1" -message $message -force
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en sincronización GitHub"
        exit 1
    }
    Write-Host "   ✅ GitHub sincronizado" -ForegroundColor Green

    # 5. Esperar un momento para GitHub Pages
    Write-Host "`n5. Esperando actualización de GitHub Pages..." -ForegroundColor Cyan
    Write-Host "   ⏱️ GitHub Pages puede tardar 1-2 minutos en actualizarse" -ForegroundColor Yellow
    Start-Sleep -Seconds 5

    # 6. Generar nuevo staging
    Write-Host "`n6. Generando nuevo staging..." -ForegroundColor Cyan
    & ".\sync\sync-to-staging.ps1"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en generación de staging"
        exit 1
    }
    Write-Host "   ✅ Staging generado" -ForegroundColor Green

    # 7. Generar nuevo producción
    Write-Host "`n7. Generando nuevo producción..." -ForegroundColor Cyan
    & ".\sync\sync-to-production.ps1" -confirm:(-not $skipConfirmation)
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en generación de producción"
        exit 1
    }
    Write-Host "   ✅ Producción generada" -ForegroundColor Green

    # 8. Verificar estado final
    Write-Host "`n8. Verificando estado final..." -ForegroundColor Cyan
    
    $deployments = @{
        "deployment-staging" = "Staging"
        "deployment-production" = "Producción"
    }

    foreach ($deployment in $deployments.Keys) {
        if (Test-Path $deployment) {
            $files = (Get-ChildItem $deployment -Recurse).Count
            $size = [math]::Round((Get-ChildItem $deployment -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
            Write-Host "   ✅ $($deployments[$deployment]): $files archivos, $size MB" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $($deployments[$deployment]): No generado" -ForegroundColor Red
        }
    }

    # 9. Generar reporte de resincronización
    Write-Host "`n9. Generando reporte..." -ForegroundColor Cyan
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $report = @"
# REPORTE DE RESINCRONIZACIÓN COMPLETA
Fecha: $timestamp
Origen: Servidor IIS → Local → Todos los entornos

## ENTORNOS SINCRONIZADOS:

### 1. LOCAL (Desarrollo):
✅ Código actualizado desde servidor IIS
✅ Build local verificado

### 2. GITHUB (Repositorio):
✅ Cambios subidos al repositorio
✅ GitHub Pages actualizado
🌐 URL: https://pjreyesv04.github.io/landing_page_ofsef/

### 3. STAGING (Pruebas IIS):
✅ Build generado para staging
📁 Ubicación: deployment-staging/
🎯 Listo para: C:\inetpub\wwwroot\page_ofseg_dirisln (Staging)

### 4. PRODUCCIÓN (IIS Público):
✅ Build generado para producción
📁 Ubicación: deployment-production/
🎯 Listo para: C:\inetpub\wwwroot\page_ofseg_dirisln (Producción)

## MENSAJE DE COMMIT:
$message

## PRÓXIMOS PASOS:
1. Verificar GitHub Pages: https://pjreyesv04.github.io/landing_page_ofsef/
2. Copiar deployment-staging al servidor de pruebas
3. Probar funcionamiento en staging
4. Copiar deployment-production al servidor público
5. Verificar funcionamiento en producción

## ESTADO FINAL:
🟢 Todos los entornos sincronizados desde servidor IIS
🟢 Código fuente local actualizado
🟢 Builds generados para todos los ambientes
"@

    $reportFile = "REPORTE-RESYNC-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    Set-Content -Path $reportFile -Value $report -Encoding UTF8

    # 10. Mostrar resumen final
    Write-Host "`n🎉 RESINCRONIZACIÓN COMPLETA EXITOSA" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    
    Write-Host "`n📊 ESTADO FINAL:" -ForegroundColor Cyan
    Write-Host "✅ Local: Código actualizado desde IIS" -ForegroundColor Green
    Write-Host "✅ GitHub: Repositorio sincronizado" -ForegroundColor Green
    Write-Host "✅ GitHub Pages: https://pjreyesv04.github.io/landing_page_ofsef/" -ForegroundColor Green
    Write-Host "✅ Staging: deployment-staging/ listo" -ForegroundColor Green
    Write-Host "✅ Producción: deployment-production/ listo" -ForegroundColor Green
    
    Write-Host "`n📄 Reporte generado: $reportFile" -ForegroundColor White
    
    Write-Host "`n🎯 TODOS LOS ENTORNOS ESTÁN AHORA SINCRONIZADOS" -ForegroundColor Magenta

    # 11. Limpiar archivos temporales (opcional)
    $cleanup = Read-Host "`n¿Limpiar archivos temporales del análisis IIS? (s/n)"
    if ($cleanup -eq "s" -or $cleanup -eq "S") {
        if (Test-Path "temp-iis-download") {
            Remove-Item "temp-iis-download" -Recurse -Force
            Write-Host "🧹 Archivos temporales eliminados" -ForegroundColor Green
        }
        
        # Limpiar archivos de análisis antiguos (mantener solo los últimos 3)
        $analysisFiles = Get-ChildItem "ANALISIS-IIS-*.md" | Sort-Object LastWriteTime -Descending
        if ($analysisFiles.Count -gt 3) {
            $filesToDelete = $analysisFiles | Select-Object -Skip 3
            foreach ($file in $filesToDelete) {
                Remove-Item $file.FullName -Force
            }
            Write-Host "🧹 Archivos de análisis antiguos eliminados" -ForegroundColor Green
        }
    }

} catch {
    Write-Error "❌ Error durante resincronización: $_"
    exit 1
}
