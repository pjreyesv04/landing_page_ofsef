# 🚀 GUÍA RÁPIDA: IIS Default Web Site (Puerto 80)

## ⚡ RESUMEN EJECUTIVO - 5 PASOS

### 🔹 PASO 1: Preparar Archivos
```bash
# Ejecutar en la carpeta del proyecto:
preparar-archivos-iis.bat
```
**Resultado:** Carpeta `out/` con todos los archivos listos

### 🔹 PASO 2: Copiar a IIS
```
Origen:  [tu-proyecto]\out\*
Destino: C:\inetpub\wwwroot\diris-lima-norte\
```
**⚠️ IMPORTANTE:** Copiar TODO el contenido de `out\`

### 🔹 PASO 3: Crear Application Pool
```
IIS Manager → Application Pools → Add Application Pool
- Name: DirisLimaNorte
- .NET CLR: No Managed Code ⚠️
- Pipeline: Integrated
```

### 🔹 PASO 4: Crear Aplicación Virtual
```
IIS Manager → Default Web Site → Add Application
- Alias: diris-lima-norte
- App Pool: DirisLimaNorte
- Path: C:\inetpub\wwwroot\diris-lima-norte
```

### 🔹 PASO 5: Verificar
```
URL: http://localhost/diris-lima-norte
```

---

## 📁 ARCHIVOS OBLIGATORIOS EN CARPETA FINAL

```
C:\inetpub\wwwroot\diris-lima-norte\
├── index.html          ← OBLIGATORIO
├── web.config          ← OBLIGATORIO
├── favicon.ico         ← Recomendado
├── _next/              ← Carpeta Next.js
│   ├── static/css/
│   ├── static/js/
│   └── static/media/
└── images/             ← Tus imágenes
```

---

## ⚙️ CONFIGURACIÓN IIS FINAL

### Application Pools:
- **DirisLimaNorte**: Started, No Managed Code ✅

### Sites:
- **Default Web Site**: Started, Port 80 ✅
  - **diris-lima-norte**: (Application) ✅

---

## 🌐 URLS RESULTANTES

**Local:** `http://localhost/diris-lima-norte`
**Red:** `http://[IP-SERVIDOR]/diris-lima-norte`

---

## 🚨 PROBLEMAS COMUNES

| Error | Causa | Solución |
|-------|-------|----------|
| 403 Forbidden | Permisos | Dar permisos a `IIS_IUSRS` |
| 404 Not Found | URL incorrecta | Usar `/diris-lima-norte` |
| 500 Internal | web.config | Verificar que esté en carpeta raíz |
| Sin CSS/JS | Archivos faltantes | Verificar carpeta `_next/` |

---

## ✅ CHECKLIST RÁPIDO

- [ ] Ejecutar `preparar-archivos-iis.bat`
- [ ] Copiar `out\*` a `C:\inetpub\wwwroot\diris-lima-norte\`
- [ ] Crear Application Pool "DirisLimaNorte" (No Managed Code)
- [ ] Crear aplicación virtual en Default Web Site
- [ ] Configurar permisos (IIS_IUSRS)
- [ ] Probar: `http://localhost/diris-lima-norte`

**🎯 ¡5 pasos y estás listo!**
