const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

async function generateFavicons() {
  const sourceImage = './favicon-source.png';
  
  if (!fs.existsSync(sourceImage)) {
    console.error('❌ No se encontró la imagen fuente:', sourceImage);
    return;
  }

  console.log('🎨 Generando favicons desde:', sourceImage);

  try {
    // Verificar que la imagen sea válida
    const metadata = await sharp(sourceImage).metadata();
    console.log(`📐 Imagen original: ${metadata.width}x${metadata.height} - ${metadata.format}`);

    // Crear directorio para favicons si no existe
    const publicDir = './public';
    if (!fs.existsSync(publicDir)) {
      fs.mkdirSync(publicDir, { recursive: true });
    }

    // Generar favicon.ico (combinando múltiples tamaños)
    console.log('🔄 Generando favicon.ico...');
    
    // Primero crear las versiones PNG necesarias
    const sizes = [16, 32, 48];
    const pngBuffers = [];
    
    for (const size of sizes) {
      console.log(`📏 Creando versión ${size}x${size} con transparencia...`);
      const buffer = await sharp(sourceImage)
        .resize(size, size, {
          fit: 'contain',
          background: { r: 0, g: 0, b: 0, alpha: 0 }  // Fondo transparente
        })
        .png()
        .toBuffer();
      pngBuffers.push(buffer);
      
      // Guardar también versiones PNG individuales
      await sharp(buffer)
        .toFile(`./public/favicon-${size}x${size}.png`);
    }

    // Crear favicon.ico usando la versión de 32x32 SIN fondo blanco
    console.log('🖼️ Generando favicon.ico con transparencia...');
    await sharp(sourceImage)
      .resize(32, 32, {
        fit: 'contain',
        background: { r: 0, g: 0, b: 0, alpha: 0 }  // Fondo transparente
      })
      .png()
      .toFile('./src/app/favicon.ico');

    // Generar apple-touch-icon (180x180)
    console.log('🍎 Generando apple-touch-icon...');
    await sharp(sourceImage)
      .resize(180, 180, {
        fit: 'contain',
        background: { r: 255, g: 255, b: 255, alpha: 1 }
      })
      .png()
      .toFile('./public/apple-touch-icon.png');

    // Generar icon-192.png para PWA con transparencia
    console.log('📱 Generando icon-192.png con transparencia...');
    await sharp(sourceImage)
      .resize(192, 192, {
        fit: 'contain',
        background: { r: 0, g: 0, b: 0, alpha: 0 }  // Fondo transparente
      })
      .png()
      .toFile('./public/icon-192.png');

    // Generar icon-512.png para PWA con transparencia
    console.log('📱 Generando icon-512.png con transparencia...');
    await sharp(sourceImage)
      .resize(512, 512, {
        fit: 'contain',
        background: { r: 0, g: 0, b: 0, alpha: 0 }  // Fondo transparente
      })
      .png()
      .toFile('./public/icon-512.png');

    console.log('✅ ¡Favicons generados exitosamente!');
    console.log('📁 Archivos creados:');
    console.log('   - src/app/favicon.ico');
    console.log('   - public/favicon-16x16.png');
    console.log('   - public/favicon-32x32.png');
    console.log('   - public/favicon-48x48.png');
    console.log('   - public/apple-touch-icon.png');
    console.log('   - public/icon-192.png');
    console.log('   - public/icon-512.png');
    
  } catch (error) {
    console.error('❌ Error al generar favicons:', error);
  }
}

generateFavicons();
