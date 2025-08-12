# 🧹 SCRIPT DE LIMPIEZA COMPLETA
# Archivo: cleanup-project.ps1
# Propósito: Eliminar archivos y carpetas innecesarios

param(
    [switch]$WhatIf = $false,
    [switch]$Force = $false
)

Write-Host "🧹 INICIANDO LIMPIEZA DEL PROYECTO" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Función para logging
function Write-CleanupLog {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch($Type) {
        "DELETE" { "Red" }
        "KEEP" { "Green" }
        "SKIP" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

# Arrays de archivos y carpetas a eliminar
$FilesToDelete = @(
    # Configuraciones duplicadas/obsoletas
    "next.config.github.ts",
    "next.config.iis.ts", 
    "next.config.local.ts",
    "web.config.backup",
    "web.config.new",
    
    # Archivos de prueba/diagnóstico
    "firefox-test.html",
    "browser-test.html",
    
    # Archivos generados que se pueden regenerar
    "index.txt",
    
    # Archivos de documentación redundantes (mantenemos solo la guía principal)
    "FIREFOX-COMPATIBILITY-GUIDE.md",
    "METODOLOGIA-CORRECTA.md"
)

$FoldersToDelete = @(
    # Carpetas de build que se regeneran
    ".next",
    "out",
    "node_modules",
    
    # Carpeta pública duplicada (ya tenemos archivos en raíz)
    "public",
    
    # Carpeta 404 (se maneja automáticamente por Next.js)
    "404"
)

$FilesToKeep = @(
    # Configuraciones esenciales
    "next.config.ts",
    "web.config",
    "package.json",
    "package-lock.json",
    "tsconfig.json",
    "tailwind.config.ts",
    "postcss.config.mjs",
    "components.json",
    
    # Archivos de aplicación
    "index.html",
    "404.html",
    
    # Assets
    "favicon.ico",
    "favicon-16x16.png",
    "favicon-32x32.png", 
    "favicon-48x48.png",
    "apple-touch-icon.png",
    "icon-192.png",
    "icon-512.png",
    "site.webmanifest",
    
    # Código fuente
    "src",
    "images",
    
    # Git y configuraciones
    ".git",
    ".gitignore",
    ".eslintrc.json",
    ".nojekyll",
    "next-env.d.ts",
    
    # Scripts de automatización
    "update-from-github.ps1",
    "update-quick.bat",
    "DEPLOYMENT-GUIDE.md",
    
    # Carpeta de assets generados (se preserva si existe y es necesaria)
    "_next"
)

Write-CleanupLog "📋 Iniciando análisis de archivos..." "INFO"

# Si es modo WhatIf, solo mostrar qué se haría
if ($WhatIf) {
    Write-Host ""
    Write-Host "🔍 MODO PREVIEW - No se eliminarán archivos" -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Yellow
}

# Eliminar archivos
Write-Host ""
Write-Host "📁 ARCHIVOS A PROCESAR:" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan

foreach ($file in $FilesToDelete) {
    if (Test-Path $file) {
        if ($WhatIf) {
            Write-CleanupLog "🗑️  ELIMINARÍA: $file" "DELETE"
        } else {
            try {
                Remove-Item $file -Force
                Write-CleanupLog "🗑️  ELIMINADO: $file" "DELETE"
            } catch {
                Write-CleanupLog "❌ ERROR eliminando $file`: $($_.Exception.Message)" "DELETE"
            }
        }
    } else {
        Write-CleanupLog "⚠️  NO EXISTE: $file" "SKIP"
    }
}

# Eliminar carpetas
Write-Host ""
Write-Host "📂 CARPETAS A PROCESAR:" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan

foreach ($folder in $FoldersToDelete) {
    if (Test-Path $folder) {
        if ($WhatIf) {
            Write-CleanupLog "🗑️  ELIMINARÍA CARPETA: $folder" "DELETE"
        } else {
            try {
                Remove-Item $folder -Recurse -Force
                Write-CleanupLog "🗑️  ELIMINADA CARPETA: $folder" "DELETE"
            } catch {
                Write-CleanupLog "❌ ERROR eliminando carpeta $folder`: $($_.Exception.Message)" "DELETE"
            }
        }
    } else {
        Write-CleanupLog "⚠️  CARPETA NO EXISTE: $folder" "SKIP"
    }
}

# Mostrar archivos que se mantienen
Write-Host ""
Write-Host "✅ ARCHIVOS/CARPETAS PRESERVADOS:" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

foreach ($item in $FilesToKeep) {
    if (Test-Path $item) {
        $type = if (Test-Path $item -PathType Container) { "📂 CARPETA" } else { "📄 ARCHIVO" }
        Write-CleanupLog "$type PRESERVADO: $item" "KEEP"
    }
}

# Verificar estructura final
if (-not $WhatIf) {
    Write-Host ""
    Write-Host "🔍 VERIFICACIÓN FINAL:" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    
    # Verificar archivos críticos
    $CriticalFiles = @("next.config.ts", "web.config", "package.json", "src", "images")
    $allGood = $true
    
    foreach ($critical in $CriticalFiles) {
        if (Test-Path $critical) {
            Write-CleanupLog "✅ CRÍTICO OK: $critical" "KEEP"
        } else {
            Write-CleanupLog "❌ CRÍTICO FALTA: $critical" "DELETE"
            $allGood = $false
        }
    }
    
    if ($allGood) {
        Write-Host ""
        Write-Host "🎉 LIMPIEZA COMPLETADA EXITOSAMENTE" -ForegroundColor Green
        Write-Host "====================================" -ForegroundColor Green
        Write-CleanupLog "✅ Todos los archivos críticos están presentes" "KEEP"
        Write-CleanupLog "📋 Proyecto listo para próximo deployment" "INFO"
    } else {
        Write-Host ""
        Write-Host "⚠️  ADVERTENCIA: Faltan archivos críticos" -ForegroundColor Red
        Write-Host "=========================================" -ForegroundColor Red
    }
}

# Crear reporte de limpieza
if (-not $WhatIf) {
    $ReportContent = @"
=== REPORTE DE LIMPIEZA ===
Fecha: $(Get-Date)
Archivos eliminados: $($FilesToDelete.Count)
Carpetas eliminadas: $($FoldersToDelete.Count)

ARCHIVOS ELIMINADOS:
$($FilesToDelete -join "`n")

CARPETAS ELIMINADAS:
$($FoldersToDelete -join "`n")

PRÓXIMOS PASOS:
1. Ejecutar 'npm install' para regenerar node_modules
2. Ejecutar 'npm run build' para regenerar archivos de build
3. Verificar que el sitio funciona correctamente
4. Usar 'update-quick.bat' para futuras actualizaciones
"@
    
    $ReportContent | Out-File -FilePath "cleanup-report.txt" -Encoding UTF8 -Force
    Write-CleanupLog "📋 Reporte guardado en: cleanup-report.txt" "INFO"
}

Write-Host ""
if ($WhatIf) {
    Write-Host "💡 Para ejecutar la limpieza real, usa:" -ForegroundColor Yellow
    Write-Host "   .\cleanup-project.ps1 -Force" -ForegroundColor Yellow
} else {
    Write-Host "✅ Limpieza completada. Ejecutar 'npm install' y 'npm run build'" -ForegroundColor Green
}
Write-Host ""
