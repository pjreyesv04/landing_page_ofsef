import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { CheckCircle, Users, Globe, Briefcase, Store } from 'lucide-react';
import Link from 'next/link';

const sisPlans = [
  {
    name: 'SIS Gratuito',
    icon: <Users className="h-10 w-10 text-primary" />,
    description: 'Para personas en situación de pobreza, gestantes, niños, bomberos y más.',
    features: [
      'Cobertura integral y gratuita.',
      'Acceso a servicios de salud preventivos.',
      'Atención de maternidad y parto.',
      'Medicamentos y procedimientos cubiertos.'
    ],
    isPopular: false,
    link: 'https://www.gob.pe/133-afiliarte-al-sis-gratuito'
  },
  {
    name: 'SIS Para Todos',
    icon: <Globe className="h-10 w-10 text-primary" />,
    description: 'Para todos los peruanos y residentes que no cuenten con otro seguro de salud.',
    features: [
      'Afiliación automática con DNI.',
      'Cubre más de 1400 diagnósticos.',
      'Atención de emergencias.',
      'Sin costo para el ciudadano.'
    ],
    isPopular: false,
    link: 'https://www.gob.pe/8970-afiliarte-al-sis-para-todos'
  },
  {
    name: 'SIS Independiente',
    icon: <Briefcase className="h-10 w-10 text-primary" />,
    description: 'Para trabajadores independientes que deseen aportar a su seguro.',
    features: [
      'Aportes mensuales accesibles.',
      'Cobertura para el titular y derechohabientes.',
      'Amplia red de establecimientos.',
      'Acceso a atenciones complejas.'
    ],
    isPopular: false,
    link: 'https://www.gob.pe/172-sis-independiente'
  },
    {
    name: 'SIS Microempresas',
    icon: <Store className="h-10 w-10 text-primary" />,
    description: 'Dirigido a los trabajadores de microempresas formales.',
    features: [
      'Aporte subsidiado por el Estado.',
      'Protección para el trabajador y su familia.',
      'Cobertura de atenciones y medicamentos.',
      'Fomenta la formalización laboral.'
    ],
    isPopular: false,
    link: 'https://www.gob.pe/180-sis-microempresas'
  }
];

const Plans = () => {
  return (
    <section id="planes" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">PLANES DE SEGURO SIS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Un Plan para Cada Necesidad</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            El Seguro Integral de Salud (SIS) ofrece diversos planes para garantizar el acceso universal a la salud de todos los peruanos.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 items-start">
          {sisPlans.map((plan) => (
            <Card key={plan.name} className="flex flex-col h-full shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-105 border-border">
              <CardHeader className="items-center text-center pt-8">
                <div className="p-4 bg-primary/10 rounded-full mb-4">
                  {plan.icon}
                </div>
                <CardTitle className="text-2xl font-headline h-16 flex items-center text-center">{plan.name}</CardTitle>
                <CardDescription className="px-4 h-24 flex items-center">{plan.description}</CardDescription>
              </CardHeader>
              <CardContent className="flex-grow">
                <ul className="space-y-3">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="flex items-start gap-3">
                      <CheckCircle className="h-6 w-6 text-green-500 shrink-0 mt-1" />
                      <span className="text-foreground/80">{feature}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
              <CardFooter>
                 <Button asChild className="w-full font-semibold" variant="outline">
                    <Link href={plan.link} target="_blank" rel="noopener noreferrer">Más Información</Link>
                </Button>
              </CardFooter>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Plans;
