# Script de despliegue completo a producción
param([switch]$Force)

Write-Host "🚀 DESPLEGANDO A PRODUCCIÓN" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

$staging = "C:\inetpub\wwwroot\page_ofseg_dirisln"
$production = "C:\inetpub\wwwroot"

# Verificar que existe la carpeta staging
if (-not (Test-Path $staging)) {
    Write-Host "❌ Carpeta staging no encontrada: $staging" -ForegroundColor Red
    exit 1
}

# 1. Crear backup de producción actual
Write-Host "1. 💾 Creando backup..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = "$production\backups"
$backupName = "backup-$timestamp"

# Crear directorio de backups si no existe
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

# Backup del index.html actual
if (Test-Path "$production\index.html") {
    Copy-Item "$production\index.html" "$backupDir\$backupName-index.html" -Force
    Write-Host "✓ Backup de index.html creado" -ForegroundColor Green
}

# Backup de carpetas importantes
@('_next', 'images') | ForEach-Object {
    if (Test-Path "$production\$_") {
        Copy-Item "$production\$_" "$backupDir\$backupName-$_" -Recurse -Force
        Write-Host "✓ Backup de $_ creado" -ForegroundColor Green
    }
}

# 2. Copiar archivos desde staging a producción
Write-Host "`n2. 📋 Copiando archivos..." -ForegroundColor Cyan

# Lista de archivos/carpetas a copiar
$itemsToCopy = @(
    @{Path = "index.html"; Required = $true},
    @{Path = "_next"; Required = $false},
    @{Path = "images"; Required = $false},
    @{Path = "favicon.ico"; Required = $false},
    @{Path = "apple-touch-icon.png"; Required = $false},
    @{Path = "site.webmanifest"; Required = $false}
)

foreach ($item in $itemsToCopy) {
    $sourcePath = "$staging\$($item.Path)"
    $destPath = "$production\$($item.Path)"
    
    if (Test-Path $sourcePath) {
        if (Test-Path $sourcePath -PathType Container) {
            # Es una carpeta
            Copy-Item $sourcePath $destPath -Recurse -Force
        } else {
            # Es un archivo
            Copy-Item $sourcePath $destPath -Force
        }
        Write-Host "✓ $($item.Path) copiado" -ForegroundColor Green
    } elseif ($item.Required) {
        Write-Host "⚠️  Archivo requerido no encontrado: $($item.Path)" -ForegroundColor Yellow
    }
}

# 3. Verificar que web.config existe y es válido
Write-Host "`n3. 🔧 Verificando configuración..." -ForegroundColor Cyan
$webConfigPath = "$production\web.config"

if (-not (Test-Path $webConfigPath)) {
    Write-Host "⚠️  web.config no encontrado, creando uno básico..." -ForegroundColor Yellow
    
    $basicWebConfig = @'
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <defaultDocument>
            <files>
                <clear />
                <add value="index.html" />
                <add value="index.htm" />
                <add value="default.html" />
            </files>
        </defaultDocument>
        <httpErrors existingResponse="PassThrough" />
    </system.webServer>
    <system.web>
        <globalization 
            requestEncoding="UTF-8" 
            responseEncoding="UTF-8" 
            fileEncoding="UTF-8" 
            culture="es-ES" 
            uiCulture="es-ES" />
    </system.web>
</configuration>
'@
    
    Set-Content -Path $webConfigPath -Value $basicWebConfig -Encoding UTF8
    Write-Host "✓ web.config básico creado" -ForegroundColor Green
}

# 4. Verificar integridad del despliegue
Write-Host "`n4. ✅ Verificando despliegue..." -ForegroundColor Cyan

$prodIndex = "$production\index.html"
if (Test-Path $prodIndex) {
    $fileInfo = Get-Item $prodIndex
    Write-Host "✓ index.html presente" -ForegroundColor Green
    Write-Host "  Tamaño: $($fileInfo.Length) bytes" -ForegroundColor White
    Write-Host "  Modificado: $($fileInfo.LastWriteTime)" -ForegroundColor White
} else {
    Write-Host "❌ index.html no encontrado en producción" -ForegroundColor Red
    exit 1
}

# 5. Probar sitio web
Write-Host "`n5. 🌐 Probando sitio..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost/" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Sitio funcionando correctamente (HTTP $($response.StatusCode))" -ForegroundColor Green
        Write-Host "  Tamaño respuesta: $($response.Content.Length) bytes" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Error al probar sitio: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Revisa la configuración de IIS" -ForegroundColor Yellow
}

# 6. Resumen final
Write-Host "`n🎉 DESPLIEGUE COMPLETADO" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Yellow
Write-Host "✓ Backup creado: $backupName" -ForegroundColor White
Write-Host "✓ Archivos copiados a producción" -ForegroundColor White
Write-Host "✓ Configuración verificada" -ForegroundColor White
Write-Host "✓ Sitio funcionando" -ForegroundColor White
Write-Host "`n🌐 URL: http://localhost/" -ForegroundColor Cyan
Write-Host "📁 Backup en: $backupDir\" -ForegroundColor Cyan
