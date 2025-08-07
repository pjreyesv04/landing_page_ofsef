# 🌐 DIRIS Lima Norte - Landing Page

Sistema web oficial de la Dirección Regional de Salud Lima Norte (DIRIS Lima Norte).

## 🎯 **ENTORNOS DE DEPLOYMENT:**

### 1️⃣ **Local** (Desarrollo)
- **Puerto**: 3000
- **Comando**: `npm run dev`
- **Propósito**: Desarrollo y modificaciones

### 2️⃣ **GitHub Pages** (Público)
- **URL**: https://pjreyesv04.github.io/landing_page_ofsef/
- **Deploy**: Automático con GitHub Actions
- **Propósito**: Sitio web público en GitHub

### 3️⃣ **IIS Staging** (Pruebas)
- **Ruta**: `C:\inetpub\wwwroot\page_ofseg_dirisln` (Staging)
- **Propósito**: Ambiente de pruebas en servidor IIS
- **Incluye**: Archivos de testing y debug

### 4️⃣ **IIS Producción** (Oficial)
- **Ruta**: `C:\inetpub\wwwroot\page_ofseg_dirisln` (Producción)
- **Propósito**: Sitio web oficial en servidor IIS
- **Optimizado**: Sin archivos de testing

---

## 🔄 **SINCRONIZACIÓN ENTRE ENTORNOS:**

### **Comando Principal:**
```powershell
.\sync\sync-master.ps1 -target [github|staging|production|all|status]
```

### **Ejemplos Rápidos:**
```powershell
# Ver estado de todos los entornos
.\sync\sync-master.ps1 -target status

# Subir cambios a GitHub Pages
.\sync\sync-master.ps1 -target github -message "Actualización de contenido"

# Preparar staging para pruebas
.\sync\sync-master.ps1 -target staging

# Preparar producción
.\sync\sync-master.ps1 -target production

# Sincronizar todo
.\sync\sync-master.ps1 -target all
```

### **Verificación de Sincronización:**
```powershell
.\sync\verify-sync.ps1
```

---

## 🛠️ **COMANDOS DE DESARROLLO:**

```bash
# Desarrollo local
npm run dev

# Build para IIS
npm run build:iis

# Build para GitHub Pages  
npm run build:github

# Verificar tipos TypeScript
npm run type-check
```

---

## 📁 **ESTRUCTURA DEL PROYECTO:**

```
d:\proyecto\
├── src/                     # Código fuente
├── deployment-iis/          # Build base para IIS
├── deployment-staging/      # Build para staging
├── deployment-production/   # Build para producción  
├── sync/                    # Scripts de sincronización
├── config/                  # Configuraciones por entorno
└── docs/                    # Documentación
```

---

## 🔧 **CONFIGURACIÓN UTF-8:**

El proyecto incluye configuración completa para caracteres especiales (tildes, Ñ):

- ✅ **web.config** con configuración UTF-8
- ✅ **Script automático** de configuración IIS
- ✅ **Página de prueba** para verificar caracteres

---

## 📋 **GUÍAS DISPONIBLES:**

- `SYNC-STRATEGY.md` - Estrategia completa de sincronización
- `sync/README-SYNC.md` - Guía de comandos de sincronización
- `GUIA-DEPLOYMENT-IIS.md` - Guía completa de deployment IIS
- `DEPLOYMENT-READY.md` - Información del paquete listo

---

## 🚀 **INICIO RÁPIDO:**

1. **Desarrollo**: `npm run dev`
2. **Estado**: `.\sync\sync-master.ps1 -target status`
3. **Deploy GitHub**: `.\sync\sync-master.ps1 -target github`
4. **Deploy IIS**: `.\sync\sync-master.ps1 -target staging`

**🎯 Mantén siempre los 4 entornos sincronizados para un flujo de trabajo eficiente.**
