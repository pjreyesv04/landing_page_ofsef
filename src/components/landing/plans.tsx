import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { CheckCircle, Shield, HeartPulse, Handshake } from 'lucide-react';
import Link from 'next/link';

const coverages = [
  {
    name: 'Seguro Integral de Salud (SIS)',
    icon: <HeartPulse className="h-10 w-10 text-primary" />,
    description: 'Brinda cobertura a todos los peruanos y residentes que no cuenten con otro seguro de salud.',
    features: [
      'Afiliación para todos los residentes.',
      'Planes de acuerdo a tu condición.',
      'Atenciones preventivas y recuperativas.',
      'Acceso a la red de establecimientos del MINSA.'
    ]
  },
  {
    name: 'Fondo Solidario (FISSAL)',
    icon: <Shield className="h-10 w-10 text-primary" />,
    description: 'Financia la atención de enfermedades de alto costo, raras o huérfanas para los afiliados al SIS.',
    features: [
      'Cobertura de enfermedades de alto costo.',
      'Financiamiento de tratamiento de cáncer.',
      'Atención de insuficiencia renal crónica.',
      'Garantiza acceso a tratamientos complejos.'
    ],
    isPopular: true,
  },
  {
    name: 'Seguro de Tránsito (SOAT)',
    icon: <Handshake className="h-10 w-10 text-primary" />,
    description: 'Orientación para la activación y uso de la cobertura para víctimas de accidentes de tránsito.',
    features: [
      'Atención médica de emergencia.',
      'Cobertura de hospitalización y cirugía.',
      'Indemnizaciones por incapacidad o fallecimiento.',
      'Cubre gastos médicos y de sepelio.'
    ]
  }
];

const Plans = () => {
  return (
    <section id="coberturas" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">NUESTRAS COBERTURAS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Coberturas de Salud a tu Alcance</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Gestionamos el acceso a coberturas de salud integrales para protegerte a ti y tu familia, con el respaldo del Estado.
          </p>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
          {coverages.map((plan) => (
            <Card key={plan.name} className={`flex flex-col h-full shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-105 ${plan.isPopular ? 'border-accent border-2 relative' : 'border-border'}`}>
              {plan.isPopular && (
                <div className="absolute -top-4 right-4 bg-accent text-accent-foreground px-4 py-1 text-sm font-semibold rounded-full shadow-lg">
                  FISSAL
                </div>
              )}
              <CardHeader className="items-center text-center pt-8">
                <div className="p-4 bg-primary/10 rounded-full mb-4">
                  {plan.icon}
                </div>
                <CardTitle className="text-2xl font-headline h-16 flex items-center">{plan.name}</CardTitle>
                <CardDescription className="px-4 h-16">{plan.description}</CardDescription>
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
                 <Button asChild className="w-full font-semibold" variant={plan.isPopular ? 'default' : 'outline'}>
                    <Link href="#contacto">Más Información</Link>
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
