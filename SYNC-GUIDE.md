# GUÍA DE SINCRONIZACIÓN - TRES UBICACIONES

## Ubicaciones de archivos:
1. **PC Local (original)** - Tu entorno de desarrollo principal
2. **GitHub Repository** - landing_page_ofsef (sincronizado con PC local)
3. **Servidor IIS** - c:\inetpub\wwwroot\page_ofseg_dirisln (con rutas modificadas)

## Diferencias principales:
- **GitHub/PC Local**: Rutas con `/landing_page_ofsef/`
- **Servidor IIS**: Rutas con `/page_ofseg_dirisln/`

## FLUJO DE TRABAJO:

### Cambios desde PC Local → GitHub → Servidor IIS
```powershell
# 1. En tu PC local, haz tus cambios y súbelos a GitHub
git add .
git commit -m "Nuevos cambios"
git push origin master

# 2. En el servidor IIS, ejecuta:
.\scripts\sync-all-locations.ps1 -PullFromGitHub
```

### Cambios desde Servidor IIS → GitHub → PC Local
```powershell
# 1. En el servidor IIS, después de hacer cambios:
.\scripts\sync-all-locations.ps1 -PushToGitHub

# 2. En tu PC local:
git pull origin master
```

## ARCHIVOS IMPORTANTES:
- `sync-all-locations.ps1` - Script principal de sincronización
- `index.html.iis.backup` - Backup automático
- `next.config.ts` - Configuración para GitHub Pages
- `next.config.local.js` - Configuración para servidor local

## COMANDOS ÚTILES:
```powershell
# Ver estado del repositorio
git status

# Ver diferencias
git diff

# Ver historial
git log --oneline -10

# Crear backup manual
Copy-Item index.html index.html.manual.backup
```

## TROUBLESHOOTING:
- Si hay conflictos, revisa los archivos .backup
- Usa `git stash` si necesitas guardar cambios temporalmente
- El script automáticamente maneja las conversiones de rutas
