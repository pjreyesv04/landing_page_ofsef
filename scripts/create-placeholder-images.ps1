# Script para crear imágenes placeholder temporales
# Esto creará imágenes simples con texto hasta que puedas descargar las reales

param(
    [switch]$CreateSolidColors
)

Add-Type -AssemblyName System.Drawing

function Create-PlaceholderImage {
    param(
        [string]$OutputPath,
        [string]$Text,
        [string]$BackgroundColor = "LightBlue",
        [int]$Width = 400,
        [int]$Height = 224
    )
    
    try {
        # Crear bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Configurar colores
        $bgBrush = [System.Drawing.Brushes]::$BackgroundColor
        $textBrush = [System.Drawing.Brushes]::Black
        $font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
        
        # Llenar fondo
        $graphics.FillRectangle($bgBrush, 0, 0, $Width, $Height)
        
        # Calcular posición del texto
        $textSize = $graphics.MeasureString($Text, $font)
        $x = ($Width - $textSize.Width) / 2
        $y = ($Height - $textSize.Height) / 2
        
        # Dibujar texto
        $graphics.DrawString($Text, $font, $textBrush, $x, $y)
        
        # Guardar imagen
        $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        
        # Limpiar recursos
        $graphics.Dispose()
        $bitmap.Dispose()
        $font.Dispose()
        
        Write-Host "Placeholder creado: $OutputPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error creando placeholder: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "Creando imágenes placeholder temporales..." -ForegroundColor Cyan

# Crear directorio si no existe
New-Item -ItemType Directory -Path "public/images/announcements" -Force | Out-Null

# Crear placeholders
$placeholders = @(
    @{
        Path = "public/images/announcements/vaccination-campaign.jpg"
        Text = "Campaña de Vacunación"
        Color = "LightBlue"
    },
    @{
        Path = "public/images/announcements/health-facility.jpg"
        Text = "Centro de Salud"
        Color = "LightGreen"
    },
    @{
        Path = "public/images/announcements/health-talk.jpg"
        Text = "Charla Informativa"
        Color = "LightCoral"
    }
)

$created = 0
foreach ($placeholder in $placeholders) {
    if (-not (Test-Path $placeholder.Path)) {
        if (Create-PlaceholderImage -OutputPath $placeholder.Path -Text $placeholder.Text -BackgroundColor $placeholder.Color) {
            $created++
        }
    } else {
        Write-Host "Ya existe: $($placeholder.Path)" -ForegroundColor Yellow
    }
}

Write-Host "`nPlaceholders creados: $created" -ForegroundColor Cyan
Write-Host "`n¡IMPORTANTE! Estas son imágenes temporales." -ForegroundColor Yellow
Write-Host "Para obtener imágenes reales:" -ForegroundColor White
Write-Host "1. Visite https://pixabay.com/ o https://pexels.com/" -ForegroundColor White
Write-Host "2. Busque: 'vaccination', 'hospital', 'health education'" -ForegroundColor White
Write-Host "3. Descargue imágenes de 400x224 píxeles aproximadamente" -ForegroundColor White
Write-Host "4. Reemplace los archivos en public/images/announcements/" -ForegroundColor White
