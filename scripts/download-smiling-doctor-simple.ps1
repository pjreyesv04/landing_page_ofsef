# Script simplificado para descargar la imagen del doctor sonriendo
# Fecha: $(Get-Date)

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

Write-Host "Descargando imagen del doctor sonriendo..." -ForegroundColor Cyan

# URLs alternativas (principalmente de Pixabay que suele funcionar mejor)
$doctorUrls = @(
    "https://cdn.pixabay.com/photo/2017/05/25/15/08/doctor-2343728_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/04/21/16/23/doctor-5073024_960_720.jpg",
    "https://cdn.pixabay.com/photo/2021/10/11/17/37/doctor-6701410_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/08/05/26/woman-1807533_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/07/01/12/58/doctor-5359992_960_720.jpg"
)

$outputPath = "public\images\backgrounds\smiling-doctor.jpg"
$downloaded = $false

foreach ($url in $doctorUrls) {
    if (Download-Image-Simple -Url $url -OutputPath $outputPath -Description "Doctor sonriendo") {
        $downloaded = $true
        break
    }
    Start-Sleep -Seconds 2
}

if (-not $downloaded) {
    Write-Host ""
    Write-Host "No se pudo descargar automáticamente. Descarga manual:" -ForegroundColor Yellow
    Write-Host "1. Visita: https://pixabay.com/photos/doctor-woman-smiling-6701410/" -ForegroundColor White
    Write-Host "2. O busca 'doctor woman smiling' en Pixabay/Unsplash" -ForegroundColor White
    Write-Host "3. Descarga una imagen de ~600x700 píxeles" -ForegroundColor White
    Write-Host "4. Guárdala como: public\images\backgrounds\smiling-doctor.jpg" -ForegroundColor White
}

Write-Host ""
Write-Host "Script completado." -ForegroundColor Cyan
