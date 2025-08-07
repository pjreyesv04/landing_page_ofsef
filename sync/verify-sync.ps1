# Script de Verificación de Sincronización - DIRIS Lima Norte
# Compara estados entre entornos y detecta diferencias

Write-Host "🔍 VERIFICACIÓN DE SINCRONIZACIÓN - DIRIS LIMA NORTE" -ForegroundColor Magenta
Write-Host "=====================================================" -ForegroundColor Magenta

function Get-GitInfo {
    try {
        $branch = git rev-parse --abbrev-ref HEAD
        $commit = git rev-parse --short HEAD
        $status = git status --porcelain
        
        return @{
            branch = $branch
            commit = $commit
            hasChanges = $status.Count -gt 0
            changedFiles = $status.Count
        }
    } catch {
        return @{
            branch = "No disponible"
            commit = "No disponible"
            hasChanges = $false
            changedFiles = 0
        }
    }
}

function Get-DirectoryInfo($path) {
    if (Test-Path $path) {
        $files = Get-ChildItem $path -Recurse
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
        
        return @{
            exists = $true
            fileCount = $files.Count
            totalSize = [math]::Round($totalSize / 1MB, 2)
            lastModified = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
        }
    } else {
        return @{
            exists = $false
            fileCount = 0
            totalSize = 0
            lastModified = $null
        }
    }
}

# Información de Git
Write-Host "`n🔗 INFORMACIÓN DE GIT:" -ForegroundColor Cyan
$gitInfo = Get-GitInfo
Write-Host "   📍 Branch: $($gitInfo.branch)" -ForegroundColor White
Write-Host "   🔖 Commit: $($gitInfo.commit)" -ForegroundColor White
if ($gitInfo.hasChanges) {
    Write-Host "   ⚠️  Cambios pendientes: $($gitInfo.changedFiles) archivos" -ForegroundColor Yellow
} else {
    Write-Host "   ✅ Sin cambios pendientes" -ForegroundColor Green
}

# Verificar directorios de deployment
Write-Host "`n📁 DIRECTORIOS DE DEPLOYMENT:" -ForegroundColor Cyan

$directories = @{
    "deployment-iis" = "Base IIS"
    "deployment-staging" = "Staging"
    "deployment-production" = "Producción"
}

$deploymentStatus = @{}

foreach ($dir in $directories.Keys) {
    $info = Get-DirectoryInfo $dir
    $deploymentStatus[$dir] = $info
    
    Write-Host "`n   📂 $dir ($($directories[$dir])):" -ForegroundColor Yellow
    if ($info.exists) {
        Write-Host "      ✅ Existe: $($info.fileCount) archivos, $($info.totalSize) MB" -ForegroundColor Green
        Write-Host "      📅 Última modificación: $($info.lastModified)" -ForegroundColor White
    } else {
        Write-Host "      ❌ No existe" -ForegroundColor Red
    }
}

# Comparar tamaños entre deployments
Write-Host "`n⚖️  COMPARACIÓN DE DEPLOYMENTS:" -ForegroundColor Cyan

if ($deploymentStatus["deployment-staging"].exists -and $deploymentStatus["deployment-production"].exists) {
    $stagingSize = $deploymentStatus["deployment-staging"].totalSize
    $productionSize = $deploymentStatus["deployment-production"].totalSize
    $difference = [math]::Abs($stagingSize - $productionSize)
    
    Write-Host "   📊 Staging: $stagingSize MB" -ForegroundColor White
    Write-Host "   📊 Producción: $productionSize MB" -ForegroundColor White
    
    if ($difference -lt 0.1) {
        Write-Host "   ✅ Tamaños similares (diferencia: $difference MB)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Diferencia significativa: $difference MB" -ForegroundColor Yellow
    }
}

# Verificar archivos de configuración
Write-Host "`n⚙️  ARCHIVOS DE CONFIGURACIÓN:" -ForegroundColor Cyan

$configFiles = @{
    "next.config.ts" = "Configuración Next.js"
    "package.json" = "Dependencias NPM"
    "web.config" = "Configuración IIS principal"
    "deployment-iis\web.config.utf8" = "Configuración UTF-8"
}

foreach ($file in $configFiles.Keys) {
    if (Test-Path $file) {
        $lastModified = (Get-Item $file).LastWriteTime
        Write-Host "   ✅ $file - $($configFiles[$file])" -ForegroundColor Green
        Write-Host "      📅 Modificado: $lastModified" -ForegroundColor White
    } else {
        Write-Host "   ❌ $file - FALTANTE" -ForegroundColor Red
    }
}

# Verificar logs de sincronización
Write-Host "`n📝 LOGS DE SINCRONIZACIÓN:" -ForegroundColor Cyan

$logFiles = @(
    "sync\github-sync.log",
    "sync\staging-sync.log", 
    "sync\production-sync.log"
)

foreach ($logFile in $logFiles) {
    if (Test-Path $logFile) {
        $lastEntry = Get-Content $logFile -Tail 1
        $logName = (Split-Path $logFile -Leaf).Replace("-sync.log", "").ToUpper()
        Write-Host "   📄 $logName`: $lastEntry" -ForegroundColor White
    } else {
        $logName = (Split-Path $logFile -Leaf).Replace("-sync.log", "").ToUpper()
        Write-Host "   ❌ $logName`: Sin historial" -ForegroundColor Red
    }
}

# Recomendaciones
Write-Host "`n💡 RECOMENDACIONES:" -ForegroundColor Cyan

$recommendations = @()

if ($gitInfo.hasChanges) {
    $recommendations += "Sincronizar cambios pendientes con GitHub"
}

if (-not $deploymentStatus["deployment-staging"].exists) {
    $recommendations += "Generar build de staging: .\sync\sync-to-staging.ps1"
}

if (-not $deploymentStatus["deployment-production"].exists) {
    $recommendations += "Generar build de producción: .\sync\sync-to-production.ps1"
}

if ($deploymentStatus["deployment-staging"].exists -and $deploymentStatus["deployment-production"].exists) {
    $stagingTime = $deploymentStatus["deployment-staging"].lastModified
    $productionTime = $deploymentStatus["deployment-production"].lastModified
    
    if ($stagingTime -gt $productionTime) {
        $recommendations += "Staging más reciente que producción - considerar actualizar producción"
    }
}

if ($recommendations.Count -eq 0) {
    Write-Host "   ✅ Todo parece estar sincronizado correctamente" -ForegroundColor Green
} else {
    foreach ($rec in $recommendations) {
        Write-Host "   🔧 $rec" -ForegroundColor Yellow
    }
}

# Comandos útiles
Write-Host "`n🚀 COMANDOS ÚTILES:" -ForegroundColor Cyan
Write-Host "   Estado completo:    .\sync\sync-master.ps1 -target status" -ForegroundColor White
Write-Host "   Sync GitHub:        .\sync\sync-master.ps1 -target github" -ForegroundColor White
Write-Host "   Preparar Staging:   .\sync\sync-master.ps1 -target staging" -ForegroundColor White
Write-Host "   Preparar Producción: .\sync\sync-master.ps1 -target production" -ForegroundColor White

Write-Host "`n✅ VERIFICACIÓN COMPLETADA" -ForegroundColor Green
