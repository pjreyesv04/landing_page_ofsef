import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Stethoscope, Bed, Smile, Baby, FlaskConical, Ambulance } from 'lucide-react';
import Link from 'next/link';

const services = [
  {
    icon: <Stethoscope className="h-10 w-10 text-primary" />,
    title: 'Consultas Médicas',
    description: 'Acceso a una amplia red de médicos generales y especialistas para cuidar de tu salud.'
  },
  {
    icon: <Bed className="h-10 w-10 text-primary" />,
    title: 'Hospitalización',
    description: 'Cobertura completa para internamientos médicos y quirúrgicos en nuestra red de clínicas.'
  },
  {
    icon: <Smile className="h-10 w-10 text-primary" />,
    title: 'Salud Dental',
    description: 'Planes con cobertura para consultas, limpiezas, y procedimientos dentales básicos.'
  },
  {
    icon: <Baby className="h-10 w-10 text-primary" />,
    title: 'Programa de Maternidad',
    description: 'Acompañamiento integral durante el embarazo, parto y postparto para la madre y el bebé.'
  },
  {
    icon: <FlaskConical className="h-10 w-10 text-primary" />,
    title: 'Exámenes de Laboratorio',
    description: 'Cobertura para análisis clínicos y de laboratorio para un diagnóstico preciso y oportuno.'
  },
  {
    icon: <Ambulance className="h-10 w-10 text-primary" />,
    title: 'Emergencias Médicas',
    description: 'Atención de emergencias las 24 horas del día, los 7 días de la semana en toda nuestra red.'
  }
];

const Services = () => {
  return (
    <section id="servicios" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary">Nuestros Servicios de Salud</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Ofrecemos una gama de servicios diseñados para proteger lo que más importa: su salud y la de su familia.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {services.map((service) => (
            <Card key={service.title} className="text-center shadow-lg hover:shadow-xl transition-shadow duration-300 p-6">
              <CardHeader className="items-center p-0 mb-4">
                <div className="bg-primary/10 p-4 rounded-full">
                  {service.icon}
                </div>
              </CardHeader>
              <CardContent className="space-y-2 p-0">
                <CardTitle className="font-headline text-xl">{service.title}</CardTitle>
                <p className="text-muted-foreground text-sm">{service.description}</p>
                <Link href="#" className="font-semibold text-primary hover:text-accent transition-colors text-sm">
                  Leer Más →
                </Link>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Services;
