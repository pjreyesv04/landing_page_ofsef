# 📋 GUÍA DE USO - SISTEMA DE SINCRONIZACIÓN

## 🎯 **COMANDOS PRINCIPALES:**

### **Estado General:**
```powershell
.\sync\sync-master.ps1 -target status
```
Muestra el estado actual de todos los entornos.

### **Sincronización Individual:**

#### 1️⃣ **GitHub Pages:**
```powershell
.\sync\sync-master.ps1 -target github -message "Descripción del cambio"
```

#### 2️⃣ **Staging (Pruebas):**
```powershell
.\sync\sync-master.ps1 -target staging
```

#### 3️⃣ **Producción:**
```powershell
.\sync\sync-master.ps1 -target production
```

### **Sincronización Completa:**
```powershell
.\sync\sync-master.ps1 -target all -message "Actualización completa"
```

---

## 🔄 **FLUJO DE TRABAJO RECOMENDADO:**

### **Para Cambios Normales (Local → GitHub → IIS):**
1. Hacer cambios en código local
2. `.\sync\sync-master.ps1 -target github`
3. Verificar en GitHub Pages
4. `.\sync\sync-master.ps1 -target staging`
5. Probar en servidor staging
6. `.\sync\sync-master.ps1 -target production`

### **🔄 Para Cambios Hechos en IIS (IIS → Local → GitHub):**
1. `.\sync\sync-from-iis.ps1` - Descargar archivos del servidor IIS
2. `.\sync\update-local-from-analysis.ps1` - Analizar y actualizar código local
3. Actualizar manualmente componentes en src/ según cambios identificados
4. `.\sync\resync-all-from-iis.ps1` - Resincronizar todos los entornos

### **Para Cambios Importantes:**
1. Hacer cambios en código local
2. Probar localmente: `npm run dev`
3. `.\sync\sync-master.ps1 -target staging`
4. Subir a staging y probar exhaustivamente
5. `.\sync\sync-master.ps1 -target github`
6. `.\sync\sync-master.ps1 -target production`
7. Copiar a producción con backup previo

---

## 📁 **DIRECTORIOS GENERADOS:**

- `deployment-iis\` - Build base para IIS
- `deployment-staging\` - Listo para ambiente de pruebas
- `deployment-production\` - Listo para ambiente público
- `sync\*.log` - Logs de sincronización

---

## 🚨 **COMANDOS DE EMERGENCIA:**

### **Forzar GitHub sin confirmación:**
```powershell
.\sync\sync-to-github.ps1 -force
```

### **Producción sin confirmación (¡CUIDADO!):**
```powershell
.\sync\sync-to-production.ps1 -noConfirm
```

### **🔄 SINCRONIZACIÓN INVERSA (desde IIS):**
```powershell
# Paso 1: Descargar desde IIS
.\sync\sync-from-iis.ps1

# Paso 2: Analizar cambios
.\sync\update-local-from-analysis.ps1

# Paso 3: Resincronizar todo
.\sync\resync-all-from-iis.ps1
```

### **Estado rápido:**
```powershell
.\sync\sync-master.ps1 -target status
```

---

## ✅ **VERIFICACIONES POST-DEPLOYMENT:**

### **GitHub Pages:**
- https://pjreyesv04.github.io/landing_page_ofsef/

### **Staging:**
- http://[IP-SERVIDOR]/page_ofseg_dirisln/staging-info.html
- http://[IP-SERVIDOR]/page_ofseg_dirisln/test-utf8.html

### **Producción:**
- http://[IP-SERVIDOR]/page_ofseg_dirisln/
- Verificar tildes y Ñ funcionan
- Confirmar imágenes cargan
- Eliminar production-info.html

---

**🎯 MANTÉN SIEMPRE LOS 4 ENTORNOS SINCRONIZADOS**
