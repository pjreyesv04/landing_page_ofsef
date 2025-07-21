# Script para descargar las imágenes finales faltantes
# contact.tsx: agentes de call center
# about.tsx: equipo médico

function Download-Image-Simple {
    param (
        [string]$Url,
        [string]$OutputPath,
        [string]$Description
    )
    
    Write-Host "Descargando $Description..." -ForegroundColor Yellow
    
    try {
        # Crear directorio si no existe
        $directory = Split-Path $OutputPath -Parent
        if (!(Test-Path $directory)) {
            New-Item -ItemType Directory -Path $directory -Force | Out-Null
        }
        
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing
        
        if (Test-Path $OutputPath) {
            $fileSize = (Get-Item $OutputPath).Length
            Write-Host "Descargado: $Description ($fileSize bytes)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Error: No se pudo descargar $Description" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error descargando $Description`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "Descargando imágenes finales..." -ForegroundColor Cyan
Write-Host ""

# 1. Imagen para contact.tsx - agentes de call center
Write-Host "1. Imagen de agentes de call center para contact.tsx" -ForegroundColor White
$callCenterUrls = @(
    "https://cdn.pixabay.com/photo/2020/07/07/18/56/call-center-5383069_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/03/09/09/22/workplace-1245776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2015/07/17/22/43/student-849825_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/02/03/00/12/call-center-4816216_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/08/01/08/29/woman-2563491_960_720.jpg"
)

$contactOutputPath = "public\images\backgrounds\call-center.jpg"
$contactDownloaded = $false

foreach ($url in $callCenterUrls) {
    if (Download-Image-Simple -Url $url -OutputPath $contactOutputPath -Description "Agentes de call center") {
        $contactDownloaded = $true
        break
    }
    Start-Sleep -Seconds 2
}

Write-Host ""

# 2. Imagen para about.tsx - equipo médico
Write-Host "2. Imagen de equipo médico para about.tsx" -ForegroundColor White
$teamUrls = @(
    "https://cdn.pixabay.com/photo/2018/03/10/12/00/teamwork-3213924_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/03/14/03/29/doctors-2141978_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/04/18/08/33/doctor-5058235_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/08/05/26/woman-1807533_960_720.jpg",
    "https://cdn.pixabay.com/photo/2021/10/11/18/56/doctor-6701410_960_720.jpg"
)

$aboutOutputPath = "public\images\backgrounds\medical-team.jpg"
$aboutDownloaded = $false

foreach ($url in $teamUrls) {
    if (Download-Image-Simple -Url $url -OutputPath $aboutOutputPath -Description "Equipo médico") {
        $aboutDownloaded = $true
        break
    }
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Resumen de descargas:" -ForegroundColor Cyan
if ($contactDownloaded) {
    Write-Host "OK: call-center.jpg descargada" -ForegroundColor Green
} else {
    Write-Host "FALTA: call-center.jpg - descarga manual requerida" -ForegroundColor Red
}

if ($aboutDownloaded) {
    Write-Host "OK: medical-team.jpg descargada" -ForegroundColor Green
} else {
    Write-Host "FALTA: medical-team.jpg - descarga manual requerida" -ForegroundColor Red
}

if (-not $contactDownloaded -or -not $aboutDownloaded) {
    Write-Host ""
    Write-Host "Para descargas manuales:" -ForegroundColor Yellow
    if (-not $contactDownloaded) {
        Write-Host "- Busca 'call center agents' en Pixabay, guarda como call-center.jpg" -ForegroundColor White
    }
    if (-not $aboutDownloaded) {
        Write-Host "- Busca 'medical team discussion' en Pixabay, guarda como medical-team.jpg" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "Script completado." -ForegroundColor Cyan
