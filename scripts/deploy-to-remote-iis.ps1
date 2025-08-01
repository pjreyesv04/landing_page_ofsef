# 🚀 Script de Despliegue Automático para Servidor IIS Remoto
# DIRIS Lima Norte - Landing Page

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,
    
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Password,
    
    [string]$RemotePath = "C:\inetpub\wwwroot\diris-lima-norte",
    [string]$SiteName = "DIRIS Lima Norte",
    [string]$AppPoolName = "DirisLimaNorte",
    [int]$Port = 80
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    DESPLIEGUE AUTOMÁTICO A IIS REMOTO" -ForegroundColor Cyan
Write-Host "    DIRIS Lima Norte - Landing Page" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Función para escribir logs con timestamp
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}

# Función para verificar si un comando existe
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

try {
    # Paso 1: Verificar requisitos locales
    Write-Log "Verificando requisitos locales..." "Yellow"
    
    if (!(Test-Command "node")) {
        throw "Node.js no está instalado. Por favor instalar Node.js 18+ antes de continuar."
    }
    
    if (!(Test-Command "npm")) {
        throw "npm no está disponible. Verificar instalación de Node.js."
    }
    
    if (!(Test-Path "package.json")) {
        throw "package.json no encontrado. Ejecutar desde la carpeta raíz del proyecto."
    }
    
    Write-Log "✓ Requisitos locales verificados" "Green"
    
    # Paso 2: Limpiar builds anteriores
    Write-Log "Limpiando builds anteriores..." "Yellow"
    if (Test-Path "out") {
        Remove-Item -Path "out" -Recurse -Force
        Write-Log "✓ Carpeta 'out' anterior eliminada" "Green"
    }
    
    if (Test-Path "deploy.zip") {
        Remove-Item -Path "deploy.zip" -Force
        Write-Log "✓ Archivo deploy.zip anterior eliminado" "Green"
    }
    
    # Paso 3: Instalar dependencias
    Write-Log "Instalando dependencias..." "Yellow"
    npm install
    if ($LASTEXITCODE -ne 0) {
        throw "Error al instalar dependencias npm"
    }
    Write-Log "✓ Dependencias instaladas" "Green"
    
    # Paso 4: Generar build de producción
    Write-Log "Generando build de producción..." "Yellow"
    npm run build
    if ($LASTEXITCODE -ne 0) {
        throw "Error al generar build de producción"
    }
    
    if (!(Test-Path "out")) {
        throw "Carpeta 'out' no fue generada. Verificar configuración de Next.js"
    }
    Write-Log "✓ Build de producción generado" "Green"
    
    # Paso 5: Verificar archivos importantes
    Write-Log "Verificando archivos de configuración..." "Yellow"
    
    $requiredFiles = @("web.config", "out/index.html")
    foreach ($file in $requiredFiles) {
        if (!(Test-Path $file)) {
            throw "Archivo requerido no encontrado: $file"
        }
    }
    Write-Log "✓ Archivos de configuración verificados" "Green"
    
    # Paso 6: Copiar web.config a la carpeta out
    Write-Log "Copiando configuración IIS..." "Yellow"
    Copy-Item -Path "web.config" -Destination "out/web.config" -Force
    Write-Log "✓ web.config copiado a carpeta out" "Green"
    
    # Paso 7: Crear archivo comprimido para transferencia
    Write-Log "Comprimiendo archivos para transferencia..." "Yellow"
    Compress-Archive -Path "out/*" -DestinationPath "deploy.zip" -Force
    Write-Log "✓ Archivos comprimidos en deploy.zip" "Green"
    
    # Paso 8: Verificar conectividad al servidor
    Write-Log "Verificando conectividad al servidor $ServerIP..." "Yellow"
    $ping = Test-Connection -ComputerName $ServerIP -Count 2 -Quiet
    if (!$ping) {
        throw "No se puede conectar al servidor $ServerIP. Verificar IP y conectividad de red."
    }
    Write-Log "✓ Servidor accesible" "Green"
    
    # Paso 9: Crear credenciales para conexión remota
    Write-Log "Preparando conexión remota..." "Yellow"
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)
    
    # Paso 10: Crear sesión remota
    Write-Log "Estableciendo sesión remota con el servidor..." "Yellow"
    try {
        $session = New-PSSession -ComputerName $ServerIP -Credential $credential -ErrorAction Stop
        Write-Log "✓ Sesión remota establecida" "Green"
    }
    catch {
        throw "Error al conectar al servidor remoto: $($_.Exception.Message)"
    }
    
    # Paso 11: Transferir archivos al servidor
    Write-Log "Transfiriendo archivos al servidor..." "Yellow"
    $remoteTempPath = "C:\temp\diris-deploy-$(Get-Date -Format 'yyyyMMddHHmmss')"
    
    try {
        # Crear carpeta temporal en el servidor
        Invoke-Command -Session $session -ScriptBlock {
            param($tempPath)
            New-Item -Path $tempPath -ItemType Directory -Force | Out-Null
        } -ArgumentList $remoteTempPath
        
        # Copiar archivo comprimido
        Copy-Item -Path "deploy.zip" -Destination "$remoteTempPath\deploy.zip" -ToSession $session
        Write-Log "✓ Archivos transferidos al servidor" "Green"
        
        # Paso 12: Configurar IIS en el servidor remoto
        Write-Log "Configurando IIS en el servidor remoto..." "Yellow"
        
        $configScript = {
            param($RemotePath, $SiteName, $AppPoolName, $Port, $TempPath)
            
            # Importar módulo WebAdministration
            Import-Module WebAdministration -ErrorAction SilentlyContinue
            
            # Función para log remoto
            function Write-RemoteLog {
                param([string]$Message)
                Write-Output "[$(Get-Date -Format 'HH:mm:ss')] $Message"
            }
            
            try {
                Write-RemoteLog "Iniciando configuración IIS..."
                
                # Detener sitio y app pool si existen
                if (Get-Website -Name $SiteName -ErrorAction SilentlyContinue) {
                    Stop-Website -Name $SiteName
                    Write-RemoteLog "Sitio web detenido"
                }
                
                if (Get-IISAppPool -Name $AppPoolName -ErrorAction SilentlyContinue) {
                    Stop-WebAppPool -Name $AppPoolName
                    Write-RemoteLog "Application Pool detenido"
                }
                
                # Crear backup si existe contenido previo
                if (Test-Path $RemotePath) {
                    $backupPath = "C:\backups\diris-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                    New-Item -Path "C:\backups" -ItemType Directory -Force | Out-Null
                    Copy-Item -Path $RemotePath -Destination $backupPath -Recurse -Force
                    Write-RemoteLog "Backup creado en: $backupPath"
                }
                
                # Crear carpeta destino
                New-Item -Path $RemotePath -ItemType Directory -Force | Out-Null
                Write-RemoteLog "Carpeta destino creada: $RemotePath"
                
                # Extraer archivos
                Expand-Archive -Path "$TempPath\deploy.zip" -DestinationPath $RemotePath -Force
                Write-RemoteLog "Archivos extraídos en carpeta destino"
                
                # Crear Application Pool si no existe
                if (!(Get-IISAppPool -Name $AppPoolName -ErrorAction SilentlyContinue)) {
                    New-WebAppPool -Name $AppPoolName -Force
                    Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name managedRuntimeVersion -Value ""
                    Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.identityType -Value ApplicationPoolIdentity
                    Write-RemoteLog "Application Pool creado: $AppPoolName"
                }
                
                # Crear sitio web si no existe
                if (!(Get-Website -Name $SiteName -ErrorAction SilentlyContinue)) {
                    New-Website -Name $SiteName -Port $Port -PhysicalPath $RemotePath -ApplicationPool $AppPoolName
                    Write-RemoteLog "Sitio web creado: $SiteName"
                } else {
                    Set-ItemProperty -Path "IIS:\Sites\$SiteName" -Name physicalPath -Value $RemotePath
                    Set-ItemProperty -Path "IIS:\Sites\$SiteName" -Name applicationPool -Value $AppPoolName
                    Write-RemoteLog "Sitio web actualizado: $SiteName"
                }
                
                # Configurar permisos
                $acl = Get-Acl $RemotePath
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS AppPool\$AppPoolName", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
                $acl.SetAccessRule($accessRule)
                $accessRule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
                $acl.SetAccessRule($accessRule2)
                Set-Acl $RemotePath $acl
                Write-RemoteLog "Permisos configurados"
                
                # Iniciar servicios
                Start-WebAppPool -Name $AppPoolName
                Start-Website -Name $SiteName
                Write-RemoteLog "Servicios iniciados"
                
                # Limpiar archivos temporales
                Remove-Item -Path $TempPath -Recurse -Force
                Write-RemoteLog "Archivos temporales eliminados"
                
                # Verificar estado
                $appPoolState = (Get-WebAppPool -Name $AppPoolName).State
                $siteState = (Get-Website -Name $SiteName).State
                
                Write-RemoteLog "Estado final:"
                Write-RemoteLog "- Application Pool ($AppPoolName): $appPoolState"
                Write-RemoteLog "- Sitio Web ($SiteName): $siteState"
                
                return @{
                    Success = $true
                    AppPoolState = $appPoolState
                    SiteState = $siteState
                    Message = "Configuración completada exitosamente"
                }
            }
            catch {
                Write-RemoteLog "ERROR: $($_.Exception.Message)"
                return @{
                    Success = $false
                    Error = $_.Exception.Message
                }
            }
        }
        
        $result = Invoke-Command -Session $session -ScriptBlock $configScript -ArgumentList $RemotePath, $SiteName, $AppPoolName, $Port, $remoteTempPath
        
        if ($result.Success) {
            Write-Log "✓ IIS configurado exitosamente" "Green"
            Write-Log "  - Application Pool: $($result.AppPoolState)" "Gray"
            Write-Log "  - Sitio Web: $($result.SiteState)" "Gray"
        } else {
            throw "Error en configuración IIS: $($result.Error)"
        }
        
    }
    finally {
        # Cerrar sesión remota
        if ($session) {
            Remove-PSSession -Session $session
            Write-Log "✓ Sesión remota cerrada" "Green"
        }
    }
    
    # Paso 13: Verificar despliegue
    Write-Log "Verificando despliegue..." "Yellow"
    
    Start-Sleep -Seconds 5  # Esperar a que los servicios se estabilicen
    
    try {
        $response = Invoke-WebRequest -Uri "http://$ServerIP`:$Port" -TimeoutSec 10 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Log "✓ Sitio web responde correctamente (HTTP $($response.StatusCode))" "Green"
        } else {
            Write-Log "⚠ Sitio web responde con código: $($response.StatusCode)" "Yellow"
        }
    }
    catch {
        Write-Log "⚠ No se pudo verificar el sitio web automáticamente. Verificar manualmente: http://$ServerIP`:$Port" "Yellow"
    }
    
    # Limpiar archivos locales
    Write-Log "Limpiando archivos temporales locales..." "Yellow"
    Remove-Item -Path "deploy.zip" -Force -ErrorAction SilentlyContinue
    Write-Log "✓ Limpieza completada" "Green"
    
    # Resumen final
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "    ¡DESPLIEGUE COMPLETADO!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 URL del sitio: http://$ServerIP`:$Port" -ForegroundColor Cyan
    Write-Host "📁 Ruta en servidor: $RemotePath" -ForegroundColor Gray
    Write-Host "🏊 Application Pool: $AppPoolName" -ForegroundColor Gray
    Write-Host "🖥️ Sitio IIS: $SiteName" -ForegroundColor Gray
    Write-Host ""
    Write-Host "✅ La aplicación DIRIS Lima Norte está lista para usar!" -ForegroundColor Green
    Write-Host ""
    
}
catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "    ERROR EN DESPLIEGUE" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Log "ERROR: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-Host "🔍 Pasos para solucionar:" -ForegroundColor Yellow
    Write-Host "1. Verificar conectividad al servidor" -ForegroundColor Gray
    Write-Host "2. Verificar credenciales de acceso" -ForegroundColor Gray
    Write-Host "3. Verificar que IIS esté instalado en el servidor" -ForegroundColor Gray
    Write-Host "4. Verificar permisos de administrador" -ForegroundColor Gray
    Write-Host "5. Revisar logs de IIS en el servidor" -ForegroundColor Gray
    Write-Host ""
    exit 1
}
