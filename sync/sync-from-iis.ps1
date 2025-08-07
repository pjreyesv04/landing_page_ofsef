# Script de Sincronización Inversa - Desde IIS a Local
# Descarga y compara archivos del servidor IIS con el código local

param(
    [string]$iisSourcePath = "C:\inetpub\wwwroot\page_ofseg_dirisln",
    [string]$remoteServer = "",
    [switch]$createBackup = $true,
    [switch]$autoUpdate = $false
)

Write-Host "🔄 SINCRONIZACIÓN INVERSA - DESDE IIS A LOCAL" -ForegroundColor Magenta
Write-Host "===============================================" -ForegroundColor Magenta

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "package.json")) {
    Write-Error "❌ Ejecutar desde d:\proyecto\"
    exit 1
}

try {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

    # 1. Crear backup del estado local actual
    if ($createBackup) {
        Write-Host "`n1. Creando backup del estado local..." -ForegroundColor Cyan
        $backupDir = "backup-local-$timestamp"
        
        if (Test-Path $backupDir) {
            Remove-Item $backupDir -Recurse -Force
        }
        
        New-Item -ItemType Directory -Path $backupDir | Out-Null
        
        # Backup de src y archivos principales
        Copy-Item "src" -Destination "$backupDir\src" -Recurse -Force
        Copy-Item "next.config.ts" -Destination "$backupDir\" -Force -ErrorAction SilentlyContinue
        Copy-Item "package.json" -Destination "$backupDir\" -Force -ErrorAction SilentlyContinue
        
        Write-Host "   ✅ Backup creado en: $backupDir" -ForegroundColor Green
    }

    # 2. Crear directorio temporal para archivos de IIS
    Write-Host "`n2. Preparando directorio temporal..." -ForegroundColor Cyan
    $tempDir = "temp-iis-download"
    
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    # 3. Instrucciones para descarga manual (ya que es servidor remoto)
    Write-Host "`n3. 📥 INSTRUCCIONES PARA DESCARGA DESDE IIS:" -ForegroundColor Yellow
    Write-Host "   ===========================================" -ForegroundColor Yellow
    Write-Host "   1. Conectar por Remote Desktop al servidor IIS" -ForegroundColor White
    Write-Host "   2. Navegar a: $iisSourcePath" -ForegroundColor White
    Write-Host "   3. Seleccionar TODOS los archivos del sitio web" -ForegroundColor White
    Write-Host "   4. Comprimir en archivo ZIP" -ForegroundColor White
    Write-Host "   5. Transferir el ZIP a esta máquina local" -ForegroundColor White
    Write-Host "   6. Extraer el ZIP en: $(Get-Location)\$tempDir" -ForegroundColor White
    Write-Host ""
    Write-Host "   📁 Extraer archivos IIS en: $(Get-Location)\$tempDir" -ForegroundColor Green
    Write-Host ""

    # Esperar confirmación de que los archivos fueron copiados
    $copied = Read-Host "¿Ya copiaste los archivos del servidor IIS a '$tempDir'? (s/n)"
    
    if ($copied -ne "s" -and $copied -ne "S") {
        Write-Host "❌ Proceso cancelado. Copia los archivos del IIS primero." -ForegroundColor Red
        exit 0
    }

    # 4. Verificar que los archivos fueron copiados
    Write-Host "`n4. Verificando archivos descargados..." -ForegroundColor Cyan
    
    if (-not (Test-Path $tempDir)) {
        Write-Error "❌ No se encontró el directorio $tempDir"
        exit 1
    }

    $downloadedFiles = Get-ChildItem $tempDir -Recurse
    if ($downloadedFiles.Count -eq 0) {
        Write-Error "❌ No se encontraron archivos en $tempDir"
        exit 1
    }

    Write-Host "   ✅ Encontrados $($downloadedFiles.Count) archivos descargados" -ForegroundColor Green

    # 5. Analizar diferencias entre IIS y local
    Write-Host "`n5. Analizando diferencias..." -ForegroundColor Cyan
    
    $differences = @()
    
    # Verificar archivos principales que podrían haber cambiado
    $filesToCheck = @(
        "index.html",
        "_next/static/css/*.css",
        "_next/static/chunks/*.js", 
        "images/*",
        "web.config"
    )

    # Buscar archivos HTML, CSS, JS en IIS download
    $iisHtmlFiles = Get-ChildItem "$tempDir\*.html" -ErrorAction SilentlyContinue
    $iisCssFiles = Get-ChildItem "$tempDir\_next\static\css\*" -ErrorAction SilentlyContinue
    $iisJsFiles = Get-ChildItem "$tempDir\_next\static\chunks\*" -ErrorAction SilentlyContinue

    Write-Host "   📄 Archivos HTML en IIS: $($iisHtmlFiles.Count)" -ForegroundColor White
    Write-Host "   🎨 Archivos CSS en IIS: $($iisCssFiles.Count)" -ForegroundColor White
    Write-Host "   ⚙️ Archivos JS en IIS: $($iisJsFiles.Count)" -ForegroundColor White

    # 6. Comparar con build local actual
    Write-Host "`n6. Comparando con build local..." -ForegroundColor Cyan
    
    if (Test-Path "out") {
        $localFiles = Get-ChildItem "out" -Recurse
        Write-Host "   📊 Archivos en build local: $($localFiles.Count)" -ForegroundColor White
        
        $sizeDiff = ($downloadedFiles | Measure-Object -Property Length -Sum).Sum - ($localFiles | Measure-Object -Property Length -Sum).Sum
        $sizeDiffMB = [math]::Round($sizeDiff / 1MB, 2)
        
        if ([math]::Abs($sizeDiffMB) -gt 0.1) {
            Write-Host "   ⚠️ Diferencia de tamaño: $sizeDiffMB MB" -ForegroundColor Yellow
        } else {
            Write-Host "   ✅ Tamaños similares" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️ No existe build local para comparar" -ForegroundColor Yellow
    }

    # 7. Buscar cambios en código fuente
    Write-Host "`n7. Identificando cambios en código fuente..." -ForegroundColor Cyan
    
    # Esto requiere análisis manual ya que los archivos de IIS están compilados
    Write-Host "   ⚠️ Los archivos de IIS están compilados (HTML/CSS/JS estático)" -ForegroundColor Yellow
    Write-Host "   📝 Se requiere análisis manual para identificar cambios en src/" -ForegroundColor Yellow

    # 8. Crear reporte de análisis
    Write-Host "`n8. Generando reporte de análisis..." -ForegroundColor Cyan
    
    $report = @"
# REPORTE DE SINCRONIZACION INVERSA - IIS A LOCAL
Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## ARCHIVOS DESCARGADOS DEL IIS:
Total de archivos: $($downloadedFiles.Count)
Tamaño total: $([math]::Round(($downloadedFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
Ubicacion: $tempDir

## ANALISIS:
Archivos HTML: $($iisHtmlFiles.Count)
Archivos CSS: $($iisCssFiles.Count)  
Archivos JS: $($iisJsFiles.Count)

## PROXIMOS PASOS:
1. Analizar manualmente cambios en contenido
2. Actualizar archivos fuente en src/ segun sea necesario
3. Ejecutar: .\sync\update-local-from-analysis.ps1
4. Resincronizar con GitHub: .\sync\sync-to-github.ps1
5. Regenerar staging: .\sync\sync-to-staging.ps1

## BACKUP CREADO:
$(if($createBackup){"Backup local en: $backupDir"}else{"No se creo backup"})

## ARCHIVOS IIS PARA ANALISIS:
$($downloadedFiles | Select-Object -First 10 | ForEach-Object { "- $($_.FullName.Replace((Get-Location).Path + '\$tempDir\', ''))" } | Out-String)
$(if($downloadedFiles.Count -gt 10){"... y $($downloadedFiles.Count - 10) archivos mas"})
"@

    Set-Content -Path "ANALISIS-IIS-$timestamp.md" -Value $report -Encoding UTF8

    # 9. Mostrar resumen y próximos pasos
    Write-Host "`n✅ ANÁLISIS COMPLETADO" -ForegroundColor Green
    Write-Host "📁 Archivos IIS descargados en: $tempDir" -ForegroundColor White
    Write-Host "📄 Reporte generado: ANALISIS-IIS-$timestamp.md" -ForegroundColor White
    
    if ($createBackup) {
        Write-Host "💾 Backup local creado: $backupDir" -ForegroundColor White
    }

    Write-Host "`n🔍 PRÓXIMOS PASOS:" -ForegroundColor Cyan
    Write-Host "1. Revisar contenido en $tempDir para identificar cambios" -ForegroundColor White
    Write-Host "2. Actualizar archivos fuente en src/ manualmente" -ForegroundColor White
    Write-Host "3. Ejecutar: .\sync\sync-to-github.ps1" -ForegroundColor White
    Write-Host "4. Ejecutar: .\sync\sync-to-staging.ps1" -ForegroundColor White

    Write-Host "`n⚠️ NOTA: Los archivos de IIS están compilados. Necesitas identificar" -ForegroundColor Yellow
    Write-Host "qué cambios se hicieron en el contenido para actualizarlos en src/" -ForegroundColor Yellow

} catch {
    Write-Error "❌ Error durante sincronización inversa: $_"
    exit 1
}
