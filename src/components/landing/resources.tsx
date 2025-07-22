import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Download, FileText } from 'lucide-react';
import React from 'react';

const documents = [
  {
    title: 'RJ de Afiliación',
    description: 'Documento oficial para el proceso de afiliación al SIS.',
    link: 'https://www.gob.pe/institucion/sis/normas-legales/6881519-000078-2025-sis-j',
  },
  {
    title: 'RJ de Sepelios',
    description: 'Documento oficial para el proceso desolicitud de cobertura por sepelio.',
    link: 'https://www.gob.pe/institucion/sis/normas-legales/6626326-000046-2025-sis-j',
  },
  {
    title: 'Guía de Cobertura FISSAL',
    description: 'Información detallada sobre las enfermedades de alto costo cubiertas.',
    link: 'https://www.gob.pe/9491-que-enfermedades-tienen-cobertura-por-fissal',
  },
  {
    title: 'Modelos FUA',
    description: 'Descargue  formatos y guías relevantes para el registro de las Atenciones.',
    link: 'https://drive.google.com/drive/folders/1bNdVmYkfXIxSRZAQN6cIoYyEwQ9MY0L_',
  }
];

const Resources = () => {
  return (
    <section id="recursos" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">CENTRO DE RECURSOS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Documentos y Formatos a tu Disposición</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Descargue los documentos, formatos y guías necesarios para gestionar sus trámites de manera rápida y sencilla.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {documents.map((doc) => (
            <Card key={doc.title} className="flex flex-col text-center items-center p-6 shadow-lg hover:shadow-xl transition-shadow duration-300">
              <div className="bg-primary/10 p-4 rounded-full mb-4">
                <FileText className="h-8 w-8 text-primary" />
              </div>
              <CardHeader className="p-0">
                <CardTitle className="text-lg font-semibold">{doc.title}</CardTitle>
              </CardHeader>
              <CardContent className="p-4 flex-grow">
                <CardDescription>{doc.description}</CardDescription>
              </CardContent>
              <Button asChild className="w-full mt-auto bg-accent hover:bg-accent/90">
                <a href={doc.link} download>
                  <Download className="mr-2 h-4 w-4" />
                  Descargar
                </a>
              </Button>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Resources;


