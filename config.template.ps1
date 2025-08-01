# 🔧 Configuración de Despliegue para IIS Remoto
# DIRIS Lima Norte - Landing Page
# 
# Instrucciones:
# 1. Copia este archivo a: config.ps1
# 2. Modifica los valores según tu servidor
# 3. Ejecuta: .\scripts\deploy-to-remote-iis.ps1 -ConfigFile "config.ps1"

# ===== CONFIGURACIÓN DEL SERVIDOR =====
$ServerConfig = @{
    # IP o nombre del servidor Windows Server remoto
    ServerIP = "192.168.1.100"
    
    # Credenciales de administrador del servidor
    Username = "Administrator"
    # Password = "TuPassword123"  # Descomenta y configura, o usa parámetro
    
    # Puerto para el sitio web (80 = HTTP, 443 = HTTPS)
    Port = 80
    
    # Configurar si tienes dominio personalizado
    HostName = ""  # Ejemplo: "diris.tudominio.com"
}

# ===== CONFIGURACIÓN DE IIS =====
$IISConfig = @{
    # Nombre del sitio en IIS Manager
    SiteName = "DIRIS Lima Norte"
    
    # Nombre del Application Pool
    AppPoolName = "DirisLimaNorte"
    
    # Ruta física en el servidor donde se alojará el sitio
    RemotePath = "C:\inetpub\wwwroot\diris-lima-norte"
    
    # Configuración del Application Pool
    ManagedRuntimeVersion = ""  # "" = No Managed Code (recomendado para Next.js)
    PipelineMode = "Integrated"
    ProcessIdentity = "ApplicationPoolIdentity"
    IdleTimeout = 20  # minutos
    RecycleInterval = 1740  # minutos (29 horas)
}

# ===== CONFIGURACIÓN DE BACKUP =====
$BackupConfig = @{
    # Habilitar backup automático antes de despliegue
    EnableBackup = $true
    
    # Ruta donde se guardarán los backups en el servidor
    BackupPath = "C:\backups\diris"
    
    # Retener backups por días
    RetainDays = 30
}

# ===== CONFIGURACIÓN DE MONITOREO =====
$MonitoringConfig = @{
    # Habilitar verificación post-despliegue
    EnableHealthCheck = $true
    
    # Timeout para verificación de salud del sitio (segundos)
    HealthCheckTimeout = 30
    
    # Rutas a verificar después del despliegue
    HealthCheckPaths = @("/", "/api/health")
}

# ===== CONFIGURACIÓN DE LOGS =====
$LogConfig = @{
    # Habilitar logging detallado
    EnableDetailedLogging = $true
    
    # Ruta para logs de despliegue en el servidor
    LogPath = "C:\logs\diris-deployment"
    
    # Retener logs por días
    LogRetainDays = 90
}

# ===== CONFIGURACIÓN AVANZADA =====
$AdvancedConfig = @{
    # Habilitar compresión GZIP en IIS
    EnableCompression = $true
    
    # Configurar cache headers para archivos estáticos
    EnableStaticFileCache = $true
    CacheMaxAge = 31536000  # 1 año en segundos
    
    # Habilitar URL Rewrite para SPA
    EnableUrlRewrite = $true
    
    # Configurar límites de request
    MaxRequestLength = 51200  # KB (50MB)
    MaxAllowedContentLength = 52428800  # bytes (50MB)
    
    # Timeout de request
    RequestTimeout = 300  # segundos
}

# ===== CONFIGURACIÓN DE FIREWALL =====
$FirewallConfig = @{
    # Habilitar configuración automática de firewall
    EnableFirewallConfig = $true
    
    # Puertos a abrir automáticamente
    PortsToOpen = @(80, 443)
    
    # Configurar reglas de Windows Defender
    ConfigureDefender = $true
    ExcludePaths = @("C:\inetpub\wwwroot\diris-lima-norte")
}

# ===== NOTIFICACIONES =====
$NotificationConfig = @{
    # Habilitar notificaciones por email (requiere configuración SMTP)
    EnableEmailNotifications = $false
    SMTPServer = "smtp.tudominio.com"
    SMTPPort = 587
    EmailFrom = "deploy@tudominio.com"
    EmailTo = @("admin@tudominio.com")
    
    # Habilitar notificaciones a Teams/Slack (requiere webhook)
    EnableWebhookNotifications = $false
    WebhookURL = "https://hooks.slack.com/services/..."
}

# ===== EXPORTAR CONFIGURACIÓN =====
# No modificar esta sección
$DeploymentConfig = @{
    Server = $ServerConfig
    IIS = $IISConfig
    Backup = $BackupConfig
    Monitoring = $MonitoringConfig
    Logging = $LogConfig
    Advanced = $AdvancedConfig
    Firewall = $FirewallConfig
    Notifications = $NotificationConfig
}

# Retornar configuración para uso en scripts
return $DeploymentConfig
