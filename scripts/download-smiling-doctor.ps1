# Script para descargar la imagen del doctor sonriendo
# Fecha: $(Get-Date)

function Download-Image {
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
        
        # Headers para simular navegador
        $headers = @{
            'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            'Accept' = 'image/webp,image/apng,image/*,*/*;q=0.8'
            'Accept-Language' = 'en-US,en;q=0.9'
            'Accept-Encoding' = 'gzip, deflate, br'
            'Connection' = 'keep-alive'
            'Upgrade-Insecure-Requests' = '1'
        }
        
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -Headers $headers -UseBasicParsing
        
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

# URLs alternativas para la imagen del doctor sonriendo
$doctorUrls = @(
    "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=600&h=700&fit=crop",
    "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=600&h=700&fit=crop",
    "https://images.unsplash.com/photo-1582750433449-648ed127bb54?q=80&w=600&h=700&fit=crop",
    "https://images.unsplash.com/photo-1594824475213-4e1c0c7b7a04?q=80&w=600&h=700&fit=crop",
    "https://cdn.pixabay.com/photo/2017/05/25/15/08/doctor-2343728_960_720.jpg",
    "https://cdn.pixabay.com/photo/2020/04/21/16/23/doctor-5073024_960_720.jpg",
    "https://cdn.pixabay.com/photo/2021/10/11/17/37/doctor-6701410_960_720.jpg"
)

$outputPath = "public\images\backgrounds\smiling-doctor.jpg"
$downloaded = $false

foreach ($url in $doctorUrls) {
    if (Download-Image -Url $url -OutputPath $outputPath -Description "Doctor sonriendo") {
        $downloaded = $true
        break
    }
    Start-Sleep -Seconds 2
}

if (-not $downloaded) {
    Write-Host ""
    Write-Host "No se pudo descargar automáticamente. Descarga manual:" -ForegroundColor Yellow
    Write-Host "1. Visita: https://unsplash.com/photos/smiling-woman-wearing-black-sweater-2b71ea197ec2" -ForegroundColor White
    Write-Host "2. Descarga la imagen como 'smiling-doctor.jpg'" -ForegroundColor White
    Write-Host "3. Guárdala en: public\images\backgrounds\smiling-doctor.jpg" -ForegroundColor White
    Write-Host ""
    Write-Host "Alternativamente, busca en Pixabay 'doctor woman smiling' y descarga una imagen similar." -ForegroundColor White
}

Write-Host ""
Write-Host "Script completado." -ForegroundColor Cyan
