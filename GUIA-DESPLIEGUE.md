# Guía para Subir la Página al Servidor Oficial

## 1. PREPARAR ARCHIVOS PARA SUBIR

### Archivos necesarios:
- index.html (archivo principal)
- _next/ (carpeta con recursos)
- images/ (carpeta con imágenes)
- web.config (configuración IIS)
- Todos los assets de la página

### Ubicación actual exitosa:
C:\inetpub\wwwroot\

## 2. OPCIONES DE DESPLIEGUE

### Opción A: Servidor Propio de DIRIS
- Contactar al administrador de sistemas de DIRIS Lima Norte
- Solicitar espacio en el servidor oficial
- Subir archivos vía FTP/SFTP o panel de control

### Opción B: Subdirectorio en Servidor Actual
- Crear subdirectorio: dirislimanorte.gob.pe/seguros/
- Reemplazar el contenido de /indicadores/ con tu nueva página

### Opción C: Dominio Personalizado
- seguros.dirislimanorte.gob.pe
- Apuntar DNS al servidor donde está tu página

## 3. CONFIGURACIÓN NECESARIA

### Para el servidor de destino:
1. Copiar todos los archivos de C:\inetpub\wwwroot\
2. Configurar IIS con web.config incluido
3. Verificar permisos de carpeta
4. Probar codificación UTF-8

### Contactos necesarios:
- Administrador de sistemas DIRIS Lima Norte
- Responsable del sitio web institucional
- Área de TI para configuración DNS

## 4. PASOS RECOMENDADOS

1. **Preparar paquete de archivos**
   - Comprimir toda la carpeta C:\inetpub\wwwroot\
   - Incluir documentación de configuración

2. **Contactar administrador**
   - Solicitar reunión técnica
   - Explicar necesidad de actualización

3. **Coordinar migración**
   - Programar ventana de mantenimiento
   - Hacer backup del sitio actual
   - Realizar pruebas en ambiente de desarrollo

4. **Actualizar enlaces**
   - Modificar enlace en gob.pe
   - Actualizar referencias internas
   - Notificar cambio a usuarios

## 5. INFORMACIÓN TÉCNICA PARA EL ADMINISTRADOR

### Servidor Local Exitoso:
- Sistema: Windows + IIS
- Archivos: UTF-8 con soporte para tildes y ñ
- Configuración: web.config optimizado
- Tamaño: ~209KB archivo principal

### Requisitos del servidor destino:
- IIS con soporte ASP.NET
- Configuración UTF-8
- Permisos de lectura para archivos estáticos
