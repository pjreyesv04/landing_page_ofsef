# 🔄 SINCRONIZACIÓN INVERSA - DESDE SERVIDOR IIS

## ⚠️ **SITUACIÓN ACTUAL:**
La última actualización se realizó directamente en el **servidor IIS**, lo que significa:
- 🟢 **Servidor IIS**: Tiene la versión más actualizada
- 🔴 **Local**: Versión desactualizada
- 🔴 **GitHub**: Versión desactualizada  
- 🔴 **Staging**: Posiblemente desactualizada

## 🎯 **OBJETIVO:**
Sincronizar desde **IIS → Local → GitHub → Staging** para mantener todos los entornos actualizados.

---

## 🔄 **FLUJO DE SINCRONIZACIÓN INVERSA:**

```
[SERVIDOR IIS] → [LOCAL] → [GITHUB] → [STAGING]
       ↓            ↓         ↓          ↓
   (Actual)    Download   Git Push   Testing
```

---

## 📋 **PROCESO PASO A PASO:**

### **PASO 1: Descargar desde IIS a Local**
1. Conectar por **Remote Desktop** al servidor IIS
2. Localizar archivos en: `C:\inetpub\wwwroot\page_ofseg_dirisln`
3. Comprimir carpeta completa
4. Transferir a máquina local
5. Extraer en directorio temporal

### **PASO 2: Actualizar Código Fuente Local**
1. Comparar archivos descargados con `src/`
2. Actualizar componentes modificados
3. Verificar configuraciones
4. Probar localmente: `npm run dev`

### **PASO 3: Sincronizar con GitHub**
1. Commit de cambios locales
2. Push a repositorio GitHub
3. Verificar GitHub Pages se actualiza

### **PASO 4: Regenerar Staging**
1. Generar nuevo build para staging
2. Incluir cambios actualizados
3. Preparar para pruebas

---

## 🛠️ **SCRIPTS DE SINCRONIZACIÓN INVERSA:**

Voy a crear scripts específicos para este escenario:

1. **`sync-from-iis.ps1`** - Descarga y compara archivos desde IIS
2. **`update-local-from-iis.ps1`** - Actualiza código fuente local
3. **`resync-all-environments.ps1`** - Sincroniza todos los entornos

---

## 📁 **ESTRUCTURA TEMPORAL PROPUESTA:**

```
d:\proyecto\
├── temp-iis-download/       # Archivos descargados del servidor
├── backup-local/            # Backup del estado local actual
├── src/                     # Código fuente (a actualizar)
├── deployment-iis/          # Build base (a regenerar)
├── sync/                    # Scripts de sincronización
│   ├── sync-from-iis.ps1    # NUEVO: Descarga desde IIS
│   ├── update-local.ps1     # NUEVO: Actualiza local
│   ├── resync-all.ps1       # NUEVO: Resincroniza todo
│   └── verify-sync.ps1      # Verificación
└── RESYNC-PLAN.md          # Plan de resincronización
```

---

## ⚡ **ACCIONES INMEDIATAS:**

1. **Crear backup** del estado local actual
2. **Descargar archivos** desde servidor IIS
3. **Comparar cambios** entre IIS y local
4. **Actualizar código fuente** con cambios del servidor
5. **Resincronizar** todos los entornos

---

¿Quieres que proceda a crear los scripts de sincronización inversa para resolver esta situación?
