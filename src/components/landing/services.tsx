import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { HeartPulse, ShieldCheck, Stethoscope } from 'lucide-react';

const services = [
  {
    icon: <ShieldCheck className="h-10 w-10 text-primary" />,
    title: 'Cobertura Integral',
    description: 'Planes que cubren desde consultas de rutina hasta procedimientos complejos, garantizando su tranquilidad.'
  },
  {
    icon: <HeartPulse className="h-10 w-10 text-primary" />,
    title: 'Atención Personalizada',
    description: 'Un equipo de asesores dedicados a encontrar la mejor solución de seguro para sus necesidades específicas.'
  },
  {
    icon: <Stethoscope className="h-10 w-10 text-primary" />,
    title: 'Red de Especialistas',
    description: 'Acceso a una amplia red de clínicas, hospitales y médicos especialistas en toda Lima Norte.'
  }
];

const Services = () => {
  return (
    <section id="servicios" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary">Nuestros Servicios</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Ofrecemos una gama de servicios diseñados para proteger lo que más importa: su salud y la de su familia.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {services.map((service, index) => (
            <Card key={index} className="text-center shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardHeader className="items-center">
                <div className="bg-accent/20 p-4 rounded-full">
                  {service.icon}
                </div>
              </CardHeader>
              <CardContent className="space-y-2">
                <CardTitle className="font-headline text-xl">{service.title}</CardTitle>
                <p className="text-muted-foreground">{service.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Services;
