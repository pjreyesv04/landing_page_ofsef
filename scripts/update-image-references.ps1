# Script para actualizar las referencias de imágenes externas a locales
# Ejecutar después de descargar todas las imágenes

Write-Host "Actualizando referencias de imágenes a versiones locales..." -ForegroundColor Green

# Función para hacer backup de archivos antes de modificarlos
function Backup-File {
    param($FilePath)
    $BackupPath = $FilePath + ".backup"
    if (-not (Test-Path $BackupPath)) {
        Copy-Item $FilePath $BackupPath
        Write-Host "Backup creado: $BackupPath" -ForegroundColor Yellow
    }
}

# 1. Actualizar hero.tsx
$heroFile = "src/components/landing/hero.tsx"
if (Test-Path $heroFile) {
    Backup-File $heroFile
    
    $content = Get-Content $heroFile -Raw
    $newContent = $content -replace 'https://cdn\.pixabay\.com/photo/2022/08/17/15/46/family-7392843_960_720\.jpg', '/images/backgrounds/family-hero.jpg'
    
    Set-Content $heroFile $newContent
    Write-Host "OK: $heroFile" -ForegroundColor Green
} else {
    Write-Host "No encontrado: $heroFile" -ForegroundColor Red
}

# 2. Actualizar announcements.tsx
$announcementsFile = "src/components/landing/announcements.tsx"
if (Test-Path $announcementsFile) {
    Backup-File $announcementsFile
    
    $content = Get-Content $announcementsFile -Raw
    
    # Reemplazar URLs de Unsplash con imágenes locales
    $content = $content -replace 'https://images\.unsplash\.com/photo-1606359599882-936c3403a55c\?q=80&w=400&h=224&fit=crop', '/images/announcements/vaccination-campaign.jpg'
    $content = $content -replace 'https://images\.unsplash\.com/photo-1586773860418-d37222d8fce3\?q=80&w=400&h=224&fit=crop', '/images/announcements/health-facility.jpg'
    $content = $content -replace 'https://images\.unsplash\.com/photo-1543269865-cbf427effbad\?q=80&w=400&h=224&fit=crop', '/images/announcements/health-talk.jpg'
    
    Set-Content $announcementsFile $content
    Write-Host "OK: $announcementsFile" -ForegroundColor Green
} else {
    Write-Host "No encontrado: $announcementsFile" -ForegroundColor Red
}

# 3. Actualizar services.tsx
$servicesFile = "src/components/landing/services.tsx"
if (Test-Path $servicesFile) {
    Backup-File $servicesFile
    
    $content = Get-Content $servicesFile -Raw
    
    # Reemplazar URL de la doctora sonriendo
    $content = $content -replace 'https://images\.unsplash\.com/photo-1559839734-2b71ea197ec2\?q=80&w=600&h=700&fit=crop', '/images/backgrounds/smiling-doctor.jpg'
    
    Set-Content $servicesFile $content
    Write-Host "OK: $servicesFile" -ForegroundColor Green
} else {
    Write-Host "No encontrado: $servicesFile" -ForegroundColor Red
}

# 4. Actualizar contact.tsx
$contactFile = "src/components/landing/contact.tsx"
if (Test-Path $contactFile) {
    Backup-File $contactFile
    
    $content = Get-Content $contactFile -Raw
    
    # Reemplazar URL de agentes de call center
    $content = $content -replace 'https://images\.unsplash\.com/photo-1587560699334-cc4ff634909a\?q=80&w=1920&h=1080&fit=crop', '/images/backgrounds/call-center.jpg'
    
    Set-Content $contactFile $content
    Write-Host "OK: $contactFile" -ForegroundColor Green
} else {
    Write-Host "No encontrado: $contactFile" -ForegroundColor Red
}

# 5. Actualizar about.tsx
$aboutFile = "src/components/landing/about.tsx"
if (Test-Path $aboutFile) {
    Backup-File $aboutFile
    
    $content = Get-Content $aboutFile -Raw
    
    # Reemplazar URL de equipo médico
    $content = $content -replace 'https://cdn\.pixabay\.com/photo/2018/03/10/12/00/teamwork-3213924_960_720\.jpg', '/images/backgrounds/medical-team.jpg'
    
    Set-Content $aboutFile $content
    Write-Host "OK: $aboutFile" -ForegroundColor Green
} else {
    Write-Host "No encontrado: $aboutFile" -ForegroundColor Red
}

# 6. Verificar que las imágenes existen
$imagesToCheck = @(
    "public/images/backgrounds/family-hero.jpg",
    "public/images/announcements/vaccination-campaign.jpg",
    "public/images/announcements/health-facility.jpg",
    "public/images/announcements/health-talk.jpg",
    "public/images/backgrounds/smiling-doctor.jpg",
    "public/images/backgrounds/call-center.jpg",
    "public/images/backgrounds/medical-team.jpg"
)

Write-Host "Verificando imágenes locales:" -ForegroundColor Cyan
foreach ($image in $imagesToCheck) {
    if (Test-Path $image) {
        Write-Host "OK: $image" -ForegroundColor Green
    } else {
        Write-Host "FALTA: $image" -ForegroundColor Red
    }
}

Write-Host "Proceso completado. Verifique que todas las imágenes estén disponibles antes de hacer build." -ForegroundColor Cyan
