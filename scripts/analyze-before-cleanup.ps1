# Script de Análisis Previo - Ver qué tenemos antes de limpiar
Write-Host "🔍 ANÁLISIS PREVIO A LA LIMPIEZA" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

$baseDir = "C:\inetpub\wwwroot"
$stagingDir = "$baseDir\page_ofseg_dirisln"

Write-Host "`n📊 INVENTARIO COMPLETO" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

# 1. Archivos en Staging
Write-Host "`n📁 STAGING - Todos los archivos:" -ForegroundColor White
Get-ChildItem $stagingDir -File -Recurse | 
    Select-Object @{Name="Ruta";Expression={$_.FullName.Replace($stagingDir, "")}}, 
                  @{Name="Tamaño(KB)";Expression={[math]::Round($_.Length/1KB,2)}}, 
                  LastWriteTime | 
    Sort-Object Ruta | 
    Format-Table -AutoSize

# 2. Archivos en Producción  
Write-Host "`n🚀 PRODUCCIÓN - Archivos principales:" -ForegroundColor White
Get-ChildItem $baseDir -File | 
    Select-Object Name, 
                  @{Name="Tamaño(KB)";Expression={[math]::Round($_.Length/1KB,2)}}, 
                  LastWriteTime | 
    Sort-Object Name | 
    Format-Table -AutoSize

# 3. Identificar archivos sospechosos
Write-Host "`n⚠️  ARCHIVOS SOSPECHOSOS A REVISAR:" -ForegroundColor Red

$suspiciousPatterns = @("*.tmp", "*.temp", "*.log", "*.old", "*.backup", "*-backup.*", "*-old.*", "*.bak")
$suspiciousFiles = @()

foreach ($pattern in $suspiciousPatterns) {
    $files = Get-ChildItem "$stagingDir\$pattern" -Recurse -ErrorAction SilentlyContinue
    $files += Get-ChildItem "$baseDir\$pattern" -ErrorAction SilentlyContinue
    $suspiciousFiles += $files
}

if ($suspiciousFiles.Count -gt 0) {
    $suspiciousFiles | Select-Object Name, @{Name="Ubicación";Expression={$_.DirectoryName}}, @{Name="Tamaño(KB)";Expression={[math]::Round($_.Length/1KB,2)}} | Format-Table -AutoSize
} else {
    Write-Host "   ✅ No se encontraron archivos sospechosos" -ForegroundColor Green
}

# 4. Archivos de configuración múltiples
Write-Host "`n⚙️  ARCHIVOS DE CONFIGURACIÓN:" -ForegroundColor Cyan
$configFiles = Get-ChildItem "$baseDir\web*.config*", "$baseDir\web*.xml", "$stagingDir\web*.config*", "$stagingDir\web*.xml" -ErrorAction SilentlyContinue
if ($configFiles) {
    $configFiles | Select-Object Name, @{Name="Ubicación";Expression={$_.DirectoryName}}, LastWriteTime | Format-Table -AutoSize
} else {
    Write-Host "   ✅ Solo archivos de configuración estándar" -ForegroundColor Green
}

# 5. Tamaños por carpeta
Write-Host "`n📊 TAMAÑOS POR CARPETA:" -ForegroundColor Cyan

$folders = @(
    @{Name="Staging Total"; Path=$stagingDir},
    @{Name="Staging/_next"; Path="$stagingDir\_next"},
    @{Name="Staging/images"; Path="$stagingDir\images"},
    @{Name="Staging/src"; Path="$stagingDir\src"},
    @{Name="Producción"; Path=$baseDir}
)

foreach ($folder in $folders) {
    if (Test-Path $folder.Path) {
        $size = (Get-ChildItem $folder.Path -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $fileCount = (Get-ChildItem $folder.Path -File -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
        Write-Host "   $($folder.Name): $([math]::Round($size/1MB,2)) MB ($fileCount archivos)" -ForegroundColor White
    } else {
        Write-Host "   $($folder.Name): No existe" -ForegroundColor Red
    }
}

Write-Host "`n💡 RECOMENDACIONES:" -ForegroundColor Yellow
Write-Host "==================" -ForegroundColor Yellow
Write-Host "1. Ejecutar cleanup-pre-deploy.ps1 para limpiar archivos innecesarios" -ForegroundColor White
Write-Host "2. Verificar que index.html sea la versión correcta en staging" -ForegroundColor White  
Write-Host "3. Confirmar que web.config existe en producción" -ForegroundColor White
Write-Host "4. Crear backup antes del despliegue" -ForegroundColor White
