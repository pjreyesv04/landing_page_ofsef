import { Card, CardContent } from '@/components/ui/card';
import { Stethoscope, Bed, Smile, Baby, FlaskConical, Ambulance, CheckCircle2, ShieldQuestion } from 'lucide-react';
import Image from 'next/image';
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '@/components/ui/accordion';

const services = [
  {
    icon: <Stethoscope className="h-8 w-8 text-primary" />,
    title: 'Consultas Médicas',
    description: 'Acceso a una amplia red de médicos generales y especialistas.'
  },
  {
    icon: <Bed className="h-8 w-8 text-primary" />,
    title: 'Hospitalización',
    description: 'Cobertura completa para internamientos médicos y quirúrgicos.'
  },
  {
    icon: <Smile className="h-8 w-8 text-primary" />,
    title: 'Salud Dental',
    description: 'Planes con cobertura para procedimientos dentales básicos.'
  },
  {
    icon: <Baby className="h-8 w-8 text-primary" />,
    title: 'Programa de Maternidad',
    description: 'Acompañamiento integral durante el embarazo y postparto.'
  },
  {
    icon: <FlaskConical className="h-8 w-8 text-primary" />,
    title: 'Exámenes de Laboratorio',
    description: 'Cobertura para análisis clínicos para un diagnóstico preciso.'
  },
  {
    icon: <Ambulance className="h-8 w-8 text-primary" />,
    title: 'Emergencias Médicas',
    description: 'Atención de emergencias 24/7 en toda nuestra red afiliada.'
  }
];

const whyChooseUsFeatures = [
    "Respaldo y Experiencia del Ministerio de Salud",
    "Acceso a la Red de Salud de la DIRIS Lima Norte",
    "Coberturas de Salud Gratuitas y Solidarias",
    "Atención Centrada en el Afiliado",
];


const Services = () => {
  return (
    <>
    <section id="servicios" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">NUESTROS SERVICIOS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Cobertura de Salud Integral</h2>
          <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
            Ofrecemos una gama completa de servicios diseñados para proteger lo que más importa: su salud y la de su familia.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {services.map((service) => (
            <Card key={service.title} className="shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardContent className="p-6 flex items-start gap-6">
                <div className="bg-primary/10 p-4 rounded-lg mt-1">
                  {service.icon}
                </div>
                <div>
                  <h3 className="font-headline text-xl font-bold mb-2">{service.title}</h3>
                  <p className="text-muted-foreground text-sm">{service.description}</p>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>

    <section id="porque-elegirnos" className="py-20 bg-card">
        <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="grid md:grid-cols-2 gap-12 items-center">
                <div className="space-y-6">
                    <p className="font-semibold text-primary">POR QUÉ ELEGIRNOS</p>
                    <h2 className="text-3xl md:text-4xl font-bold font-headline">
                        Comprometidos con la Calidad y su Confianza
                    </h2>
                    <p className="text-muted-foreground text-lg">
                        Entendemos la importancia de un seguro de salud confiable. Por eso, combinamos nuestra experiencia como parte del Ministerio de Salud con un profundo compromiso con el bienestar de la comunidad de Lima Norte.
                    </p>
                    <ul className="space-y-3">
                        {whyChooseUsFeatures.map((feature, i) => (
                            <li key={i} className="flex items-center gap-3">
                            <CheckCircle2 className="h-5 w-5 text-accent" />
                            <span className="text-foreground/80 font-medium">{feature}</span>
                            </li>
                        ))}
                    </ul>
                    <Accordion type="single" collapsible className="w-full">
                        <AccordionItem value="item-1">
                            <AccordionTrigger className="font-semibold text-lg">¿Cómo me afilio al SIS?</AccordionTrigger>
                            <AccordionContent>
                            El proceso es sencillo. Puede acercarse a nuestras oficinas, contactarnos por teléfono o iniciar el proceso a través de nuestro formulario de contacto. Nuestro equipo lo guiará en cada paso.
                            </AccordionContent>
                        </AccordionItem>
                        <AccordionItem value="item-2">
                            <AccordionTrigger className="font-semibold text-lg">¿Qué Establecimientos de salud están en la red?</AccordionTrigger>
                            <AccordionContent>
                            Contamos con una amplia red de establecimientos de salud del MINSA en toda la jurisdicción de Lima Norte, incluyendo hospitales, centros de salud y puestos de salud estratégicamente ubicados.
                            </AccordionContent>
                        </AccordionItem>
                        <AccordionItem value="item-3">
                            <AccordionTrigger className="font-semibold text-lg">¿Cómo uso mi cobertura FISSAL?</AccordionTrigger>
                            <AccordionContent>
                            Para activar su cobertura de alto costo a través de FISSAL, su médico tratante en un establecimiento de salud público debe emitir el diagnóstico. Nosotros le orientamos en todo el proceso administrativo.
                            </AccordionContent>
                        </AccordionItem>
                    </Accordion>
                </div>
                 <div className="relative aspect-[6/7]">
                    <Image
                    src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=600&h=700&fit=crop"
                    alt="Doctora sonriendo"
                    fill
                    className="rounded-lg shadow-2xl object-cover"
                    data-ai-hint="smiling doctor"
                    />
                    <div className="absolute top-8 -right-8 bg-white p-6 rounded-lg shadow-lg max-w-xs text-center">
                        <ShieldQuestion className="h-12 w-12 text-primary mx-auto mb-4"/>
                        <p className="font-bold text-lg text-foreground">¿Tiene Preguntas?</p>
                        <p className="text-sm text-muted-foreground">Nuestro equipo está listo para ayudarle.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    </>
  );
};

export default Services;
