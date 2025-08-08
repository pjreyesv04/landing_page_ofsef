# 🔄 FLUJO DE DESARROLLO Y SINCRONIZACIÓN
## DIRIS Lima Norte - Landing Page

### 📍 AMBIENTES CONFIGURADOS:

1. **LOCAL (Matriz)**: `d:\proyecto\` - Tu máquina de desarrollo
2. **GITHUB**: `https://github.com/pjreyesv04/landing_page_ofsef` - Repositorio central
3. **SERVIDOR REMOTO IIS**: Equipo remoto (acceso por escritorio remoto)
   - **STAGING**: `C:\inetpub\wwwroot\page_ofseg_dirisln\` - IIS Testing
   - **PRODUCCIÓN**: `C:\inetpub\wwwroot\` - IIS Público

---

## 🔧 PROCEDIMIENTO PARA HACER CAMBIOS:

### PASO 1: Preparar entorno local
```powershell
# Asegurar que local está al día con GitHub
git pull origin master

# Verificar estado
git status
```

### PASO 2: Realizar cambios
- Editar archivos en `src/components/`
- Modificar contenido, estilos, etc.
- Probar localmente: `npm run dev`

### PASO 3: Build y preparación
```powershell
# Build para GitHub Pages
npm run build:github

# Build para IIS
npm run build:iis
```

### PASO 4: Sincronización completa
```powershell
# 1. Subir a GitHub
.\sync\sync-to-github.ps1

# 2. EN EL SERVIDOR REMOTO (escritorio remoto):
#    - Conectar al servidor IIS
#    - Ejecutar: git pull origin master
#    - Sincronizar archivos con scripts remotos

# 3. Verificar despliegues
#    - Staging: http://[IP-SERVIDOR]/page_ofseg_dirisln/
#    - Producción: http://[IP-SERVIDOR]/
```

---

## ⚙️ SCRIPTS DISPONIBLES:

- `sync-master.ps1` - Controlador principal de sincronización
- `sync-to-github.ps1` - Local → GitHub
- `sync-to-staging.ps1` - GitHub → Staging IIS
- `sync-to-production.ps1` - Staging → Producción IIS
- `verify-sync.ps1` - Verificar estado de todos los ambientes

---

## 🎯 CONFIGURACIONES ESPECÍFICAS:

### Local Development:
- `next.config.ts` - Configuración para GitHub Pages
- `basePath: '/landing_page_ofsef'`

### IIS Deployment:
- `next.config.iis.ts` - Configuración para IIS
- `basePath: '/page_ofseg_dirisln'` (staging)
- `basePath: ''` (producción)

---

## 🚨 REGLAS IMPORTANTES:

1. **NUNCA editar directamente en el servidor IIS**
2. **SIEMPRE hacer cambios en LOCAL primero**
3. **PROBAR en staging antes de producción**
4. **Verificar sincronización con scripts**

---

## 📋 CHECKLIST ANTES DE CADA CAMBIO:

- [ ] Local sincronizado con GitHub (`git pull`)
- [ ] Cambios realizados y probados localmente
- [ ] Build exitoso para ambos targets
- [ ] Subido a GitHub
- [ ] Desplegado en staging
- [ ] Probado en staging
- [ ] Desplegado en producción
- [ ] Verificación final
