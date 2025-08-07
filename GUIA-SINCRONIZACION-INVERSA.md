# 🔄 GUÍA DE SINCRONIZACIÓN INVERSA - IIS A LOCAL

## ⚠️ **SITUACIÓN ACTUAL:**
La última actualización se hizo directamente en el **servidor IIS**, creando una desincronización entre entornos.

## 🎯 **OBJETIVO:**
Resincronizar todos los entornos partiendo desde el servidor IIS que tiene la versión más actual.

---

## 📋 **PROCESO PASO A PASO:**

### **PASO 1: Descargar archivos del servidor IIS**
```powershell
.\sync\sync-from-iis.ps1
```
**¿Qué hace?**
- Crea backup del código local actual
- Te guía para descargar archivos del servidor IIS
- Analiza diferencias entre IIS y local
- Genera reporte de análisis

**Instrucciones manuales:**
1. Conectar por Remote Desktop al servidor
2. Ir a `C:\inetpub\wwwroot\page_ofseg_dirisln`
3. Comprimir todos los archivos en ZIP
4. Transferir ZIP a máquina local
5. Extraer en carpeta `temp-iis-download`

### **PASO 2: Analizar cambios y planificar actualización**
```powershell
.\sync\update-local-from-analysis.ps1
```
**¿Qué hace?**
- Analiza archivos descargados del IIS
- Identifica posibles cambios de contenido
- Genera plan de actualización
- Te ayuda a identificar qué componentes actualizar

**Análisis incluye:**
- Contenido de texto en páginas
- Imágenes nuevas o modificadas
- Configuraciones del servidor
- Diferencias de tamaño

### **PASO 3: Actualizar código fuente local**
**Manual - Basado en el análisis:**
- Comparar visualmente sitio IIS vs local
- Identificar cambios en textos, imágenes, servicios
- Actualizar componentes React correspondientes:
  - `src/components/landing/contact.tsx` (contacto)
  - `src/components/landing/about.tsx` (información)
  - `src/components/landing/services.tsx` (servicios)
  - `src/components/landing/hero.tsx` (texto principal)
  - `public/images/` (imágenes)

### **PASO 4: Resincronizar todos los entornos**
```powershell
.\sync\resync-all-from-iis.ps1
```
**¿Qué hace?**
- Verifica que el código local esté actualizado
- Sube cambios a GitHub
- Actualiza GitHub Pages
- Genera nuevos builds para staging y producción
- Crea reporte completo de resincronización

---

## 🗂️ **ARCHIVOS GENERADOS DURANTE EL PROCESO:**

```
d:\proyecto\
├── temp-iis-download/           # Archivos descargados del IIS
├── backup-local-[timestamp]/    # Backup del código local original
├── ANALISIS-IIS-[timestamp].md  # Reporte de análisis
├── PLAN-ACTUALIZACION-[].md     # Plan de actualización
├── ejemplo-actualizacion.ps1    # Script de ejemplo
├── REPORTE-RESYNC-[].md         # Reporte final de resincronización
├── deployment-staging/          # Nuevo build para staging
└── deployment-production/       # Nuevo build para producción
```

---

## ✅ **VERIFICACIONES POST-PROCESO:**

### **1. Local actualizado:**
```bash
npm run dev  # Verificar que funciona localmente
```

### **2. GitHub sincronizado:**
- Verificar: https://pjreyesv04.github.io/landing_page_ofsef/

### **3. Builds generados:**
- `deployment-staging/` - Listo para servidor de pruebas
- `deployment-production/` - Listo para servidor público

### **4. Servidor IIS:**
- Copiar `deployment-production/` al servidor
- Verificar que funciona igual que antes

---

## 🎯 **COMANDOS RÁPIDOS:**

```powershell
# Proceso completo de resincronización desde IIS
.\sync\sync-from-iis.ps1
.\sync\update-local-from-analysis.ps1
# [Actualizar código manualmente según análisis]
.\sync\resync-all-from-iis.ps1

# Verificar estado final
.\sync\sync-master.ps1 -target status
```

---

## 💡 **CONSEJOS IMPORTANTES:**

1. **No te saltes el análisis:** Es crucial identificar QUÉ cambió en el servidor para actualizarlo correctamente en el código fuente.

2. **Comparación visual:** La mejor forma de identificar cambios es abrir ambos sitios (IIS y local) lado a lado.

3. **Backup automático:** El proceso crea backup automático de tu código local actual.

4. **Archivos compilados:** Los archivos del IIS están compilados (HTML/CSS/JS), por eso necesitas identificar qué cambios hacer en el código fuente React.

5. **Verificación completa:** Después del proceso, todos los entornos estarán sincronizados nuevamente.

---

**🎉 Al final de este proceso, tendrás todos los 4 entornos sincronizados con las últimas actualizaciones del servidor IIS.**
