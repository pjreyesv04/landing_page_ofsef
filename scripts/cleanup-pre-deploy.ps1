# Script de Limpieza Pre-Despliegue
# Limpiar archivos innecesarios antes del despliegue

Write-Host "🧹 LIMPIEZA PRE-DESPLIEGUE" -ForegroundColor Yellow
Write-Host "=========================" -ForegroundColor Yellow

$baseDir = "C:\inetpub\wwwroot"
$stagingDir = "$baseDir\page_ofseg_dirisln"
$productionDir = $baseDir

# 1. ANÁLISIS DE ARCHIVOS ACTUALES
Write-Host "`n1. 📊 Analizando archivos actuales..." -ForegroundColor Cyan

Write-Host "`n📁 STAGING ($stagingDir):" -ForegroundColor White
Get-ChildItem $stagingDir -File | Sort-Object Length -Descending | Select-Object Name, @{Name="Tamaño(KB)";Expression={[math]::Round($_.Length/1KB,2)}}, LastWriteTime | Format-Table -AutoSize

Write-Host "`n📁 PRODUCCIÓN ($productionDir):" -ForegroundColor White
Get-ChildItem $productionDir -File | Sort-Object Length -Descending | Select-Object Name, @{Name="Tamaño(KB)";Expression={[math]::Round($_.Length/1KB,2)}}, LastWriteTime | Format-Table -AutoSize

# 2. IDENTIFICAR ARCHIVOS A LIMPIAR
Write-Host "`n2. 🔍 Identificando archivos a limpiar..." -ForegroundColor Cyan

$filesToClean = @{
    "Staging" = @{
        "Path" = $stagingDir
        "FilesToRemove" = @(
            "*.tmp", "*.temp", "*.log", "*.old", "*.backup", 
            "*-backup.*", "*-old.*", "*-copy.*", "*.bak",
            "web.config.temp", "index.html.new", "*.orig"
        )
        "FoldersToRemove" = @(
            "temp", "tmp", "logs", "backup", "old", ".vs", "node_modules"
        )
    }
    "Production" = @{
        "Path" = $productionDir
        "FilesToRemove" = @(
            "*.tmp", "*.temp", "*.log", "*.old", "*.backup",
            "*-backup.*", "*-old.*", "*-copy.*", "*.bak",
            "web.config.temp", "index.html.new", "test*.html",
            "Fix-IISConfiguration.ps1", "web-config-utf8.xml"
        )
        "FoldersToRemove" = @(
            "temp", "tmp", "logs", "backup", "old"
        )
    }
}

# 3. EJECUTAR LIMPIEZA
foreach ($location in $filesToClean.Keys) {
    Write-Host "`n3.$($location.Substring(0,1)). 🗑️  Limpiando $location..." -ForegroundColor Cyan
    $config = $filesToClean[$location]
    $path = $config.Path
    
    # Limpiar archivos
    Write-Host "   📄 Limpiando archivos innecesarios..." -ForegroundColor Yellow
    foreach ($pattern in $config.FilesToRemove) {
        $files = Get-ChildItem "$path\$pattern" -ErrorAction SilentlyContinue
        if ($files) {
            foreach ($file in $files) {
                Write-Host "     🗑️  Eliminando: $($file.Name)" -ForegroundColor Red
                Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    # Limpiar carpetas
    Write-Host "   📁 Limpiando carpetas innecesarias..." -ForegroundColor Yellow
    foreach ($folderName in $config.FoldersToRemove) {
        $folder = "$path\$folderName"
        if (Test-Path $folder) {
            Write-Host "     🗑️  Eliminando carpeta: $folderName" -ForegroundColor Red
            Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 4. LIMPIAR ARCHIVOS DE CONFIGURACIÓN DUPLICADOS
Write-Host "`n4. ⚙️  Limpiando configuraciones duplicadas..." -ForegroundColor Cyan

$configFiles = @(
    "$productionDir\web.config.backup",
    "$productionDir\web-config-utf8.xml",
    "$productionDir\web-config-simple.xml",
    "$stagingDir\web-config-utf8.xml",
    "$stagingDir\web-config-simple.xml"
)

foreach ($configFile in $configFiles) {
    if (Test-Path $configFile) {
        Write-Host "   🗑️  Eliminando config duplicado: $(Split-Path $configFile -Leaf)" -ForegroundColor Red
        Remove-Item $configFile -Force -ErrorAction SilentlyContinue
    }
}

# 5. CONSERVAR SOLO ARCHIVOS ESENCIALES
Write-Host "`n5. ✅ Verificando archivos esenciales..." -ForegroundColor Cyan

$essentialFiles = @{
    "Staging" = @(
        "index.html", "package.json", "next.config.ts", "README.md",
        "tailwind.config.ts", "tsconfig.json", "components.json"
    )
    "Production" = @(
        "index.html", "web.config", "favicon.ico", "apple-touch-icon.png",
        "site.webmanifest"
    )
}

foreach ($location in $essentialFiles.Keys) {
    Write-Host "`n   📍 $location - Archivos esenciales:" -ForegroundColor White
    $path = if ($location -eq "Staging") { $stagingDir } else { $productionDir }
    
    foreach ($file in $essentialFiles[$location]) {
        $filePath = "$path\$file"
        if (Test-Path $filePath) {
            $fileInfo = Get-Item $filePath
            Write-Host "     ✅ $file ($([math]::Round($fileInfo.Length/1KB,1))KB)" -ForegroundColor Green
        } else {
            Write-Host "     ⚠️  $file (no encontrado)" -ForegroundColor Yellow
        }
    }
}

# 6. VERIFICAR CARPETAS ESENCIALES
Write-Host "`n6. 📂 Verificando carpetas esenciales..." -ForegroundColor Cyan

$essentialFolders = @{
    "Staging" = @("src", "public", "images", "_next", "scripts")
    "Production" = @("_next", "images", "backups")
}

foreach ($location in $essentialFolders.Keys) {
    Write-Host "`n   📍 $location - Carpetas esenciales:" -ForegroundColor White
    $path = if ($location -eq "Staging") { $stagingDir } else { $productionDir }
    
    foreach ($folder in $essentialFolders[$location]) {
        $folderPath = "$path\$folder"
        if (Test-Path $folderPath) {
            $folderSize = (Get-ChildItem $folderPath -Recurse -File | Measure-Object -Property Length -Sum).Sum
            Write-Host "     ✅ $folder ($([math]::Round($folderSize/1KB,1))KB)" -ForegroundColor Green
        } else {
            if ($folder -eq "backups") {
                # Crear carpeta backups si no existe
                New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
                Write-Host "     ➕ $folder (creada)" -ForegroundColor Blue
            } else {
                Write-Host "     ⚠️  $folder (no encontrada)" -ForegroundColor Yellow
            }
        }
    }
}

# 7. RESUMEN FINAL
Write-Host "`n🎯 LIMPIEZA COMPLETADA" -ForegroundColor Green
Write-Host "=====================" -ForegroundColor Green

Write-Host "`n📊 Estado final:" -ForegroundColor Cyan

# Tamaño total por ubicación
$stagingSize = (Get-ChildItem $stagingDir -Recurse -File | Measure-Object -Property Length -Sum).Sum
$productionSize = (Get-ChildItem $productionDir -File | Measure-Object -Property Length -Sum).Sum

Write-Host "   📁 Staging: $([math]::Round($stagingSize/1MB,2)) MB" -ForegroundColor White
Write-Host "   🚀 Producción: $([math]::Round($productionSize/1MB,2)) MB" -ForegroundColor White

Write-Host "`n✅ Entorno listo para despliegue" -ForegroundColor Green
Write-Host "💡 Siguiente paso: Ejecutar scripts de despliegue" -ForegroundColor Cyan
