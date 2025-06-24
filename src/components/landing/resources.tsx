import { Button } from '@/components/ui/button';
import { Download, FileText, HelpCircle } from 'lucide-react';
import Link from 'next/link';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

const resources = [
  {
    icon: <FileText className="h-8 w-8 text-primary" />,
    title: 'Formulario de Reclamo',
    description: 'Descargue el formulario para solicitar reembolsos o cobertura.',
    link: '#'
  },
  {
    icon: <Download className="h-8 w-8 text-primary" />,
    title: 'Documentos de Póliza',
    description: 'Acceda a los términos y condiciones completos de nuestros planes.',
    link: '#'
  },
  {
    icon: <HelpCircle className="h-8 w-8 text-primary" />,
    title: 'Preguntas Frecuentes',
    description: 'Encuentre respuestas a las dudas más comunes sobre nuestros seguros.',
    link: '#'
  }
];

const Resources = () => {
  return (
    <section id="recursos" className="py-20">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary">Recursos y Descargas</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Todo lo que necesita para gestionar su seguro de manera fácil y rápida.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {resources.map((resource) => (
            <Card key={resource.title} className="flex flex-col items-center text-center shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardHeader className="items-center">
                 <div className="bg-accent/20 p-4 rounded-full">
                  {resource.icon}
                </div>
              </CardHeader>
              <CardContent className="flex flex-col flex-grow items-center">
                <CardTitle className="text-xl font-headline mb-2">{resource.title}</CardTitle>
                <p className="text-muted-foreground mb-4 flex-grow">{resource.description}</p>
                 <Button asChild variant="outline" className="mt-auto">
                  <Link href={resource.link}>Acceder Ahora</Link>
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Resources;
