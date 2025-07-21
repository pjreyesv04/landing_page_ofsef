# Script para descargar imágenes localmente
# Ejecutar desde la carpeta raíz del proyecto

# Crear directorios si no existen
New-Item -ItemType Directory -Path "public/images/backgrounds" -Force
New-Item -ItemType Directory -Path "public/images/announcements" -Force

Write-Host "Descargando imágenes..." -ForegroundColor Green

# Función para descargar con reintentos y alternativas
function Download-ImageWithRetry {
    param($Urls, $OutputPath, $Description)
    
    foreach ($url in $Urls) {
        $maxRetries = 2
        $retryCount = 0
        
        while ($retryCount -lt $maxRetries) {
            try {
                Write-Host "Descargando $Description desde: $url" -ForegroundColor Yellow
                
                # Método simplificado sin headers problemáticos
                Invoke-WebRequest -Uri $url -OutFile $OutputPath -UseBasicParsing -UserAgent "Mozilla/5.0"
                Write-Host "Descargada exitosamente: $Description" -ForegroundColor Green
                return $true
            } catch {
                $retryCount++
                Write-Host "Error descargando desde $url (intento $retryCount/$maxRetries): $($_.Exception.Message)" -ForegroundColor Red
                if ($retryCount -lt $maxRetries) {
                    Start-Sleep -Seconds 1
                }
            }
        }
        Write-Host "Probando siguiente alternativa para $Description..." -ForegroundColor Cyan
    }
    return $false
}

# Lista de imágenes a descargar con alternativas
$images = @(
    @{
        Urls = @(
            "https://cdn.pixabay.com/photo/2022/08/17/15/46/family-7392843_960_720.jpg"
        )
        Output = "public/images/backgrounds/family-hero.jpg"
        Description = "Imagen principal del hero"
    },
    @{
        Urls = @(
            "https://cdn.pixabay.com/photo/2020/04/18/08/33/coronavirus-5058247_640.jpg",
            "https://cdn.pixabay.com/photo/2021/01/04/06/21/syringe-5887395_640.jpg",
            "https://cdn.pixabay.com/photo/2020/04/29/07/54/coronavirus-5107715_640.jpg",
            "https://cdn.pixabay.com/photo/2016/03/26/22/13/syringe-1281256_640.jpg",
            "https://cdn.pixabay.com/photo/2020/11/24/11/36/vaccine-5772671_640.jpg",
            "https://cdn.pixabay.com/photo/2015/07/10/17/24/syringe-435809_640.jpg",
            "https://cdn.pixabay.com/photo/2018/01/17/07/06/vaccine-3087518_640.jpg",
            "https://cdn.pixabay.com/photo/2016/03/05/19/02/healthcare-1238332_640.jpg",
            "https://cdn.pixabay.com/photo/2017/12/11/15/34/doctor-3012152_640.jpg"
        )
        Output = "public/images/announcements/vaccination-campaign.jpg"
        Description = "Imagen de campaña de vacunación"
    },
    @{
        Urls = @(
            "https://cdn.pixabay.com/photo/2021/08/12/20/23/medical-6541969_640.jpg",
            "https://cdn.pixabay.com/photo/2016/11/08/05/26/hospital-1807543_640.jpg",
            "https://cdn.pixabay.com/photo/2017/10/04/09/56/laboratory-2815641_640.jpg",
            "https://cdn.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_640.jpg",
            "https://cdn.pixabay.com/photo/2015/03/10/17/23/stethoscope-668214_640.jpg"
        )
        Output = "public/images/announcements/health-facility.jpg"
        Description = "Imagen de centro de salud"
    },
    @{
        Urls = @(
            "https://cdn.pixabay.com/photo/2017/03/14/03/16/doctor-2143216_640.jpg",
            "https://cdn.pixabay.com/photo/2017/03/27/13/54/doctor-2178850_640.jpg",
            "https://cdn.pixabay.com/photo/2015/01/08/18/25/desk-593327_640.jpg",
            "https://cdn.pixabay.com/photo/2016/11/08/05/29/operation-1807543_640.jpg",
            "https://cdn.pixabay.com/photo/2017/08/25/15/10/stethoscope-2680420_640.jpg"
        )
        Output = "public/images/announcements/health-talk.jpg"
        Description = "Imagen de charla informativa"
    }
)

# Descargar cada imagen
foreach ($image in $images) {
    if (Test-Path $image.Output) {
        Write-Host "Ya existe: $($image.Description), omitiendo..." -ForegroundColor Cyan
    } else {
        $success = Download-ImageWithRetry -Urls $image.Urls -OutputPath $image.Output -Description $image.Description
        if (-not $success) {
            Write-Host "No se pudo descargar ninguna alternativa para: $($image.Description)" -ForegroundColor Red
        }
    }
}

Write-Host "Verificando descargas..." -ForegroundColor Cyan
$downloadedCount = 0
$totalCount = $images.Count

foreach ($image in $images) {
    if (Test-Path $image.Output) {
        $fileSize = (Get-Item $image.Output).Length
        Write-Host "Descargado: $($image.Output) ($([math]::Round($fileSize/1KB, 1)) KB)" -ForegroundColor Green
        $downloadedCount++
    } else {
        Write-Host "FALTA: $($image.Output)" -ForegroundColor Red
    }
}

Write-Host "Resumen: $downloadedCount/$totalCount imágenes descargadas" -ForegroundColor Cyan

if ($downloadedCount -eq $totalCount) {
    Write-Host "Todas las imágenes se descargaron exitosamente!" -ForegroundColor Green
    Write-Host "Próximo paso: Ejecutar .\scripts\update-image-references.ps1" -ForegroundColor Yellow
} else {
    Write-Host "Algunas imágenes no se pudieron descargar. Verifique su conexión a internet." -ForegroundColor Yellow
    Write-Host "Para las imágenes faltantes, puede:" -ForegroundColor White
    Write-Host "  1. Descargarlas manualmente desde las URLs" -ForegroundColor White
    Write-Host "  2. Buscar alternativas en Pixabay o Pexels" -ForegroundColor White
    Write-Host "  3. Usar imágenes placeholder temporales" -ForegroundColor White
}
