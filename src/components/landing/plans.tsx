import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { CheckCircle } from 'lucide-react';
import Link from 'next/link';

const plans = [
  {
    name: 'Plan Esencial',
    price: 'S/ 59',
    period: '/mes',
    description: 'La cobertura fundamental para tu tranquilidad y cuidado preventivo.',
    features: [
      'Atención médica ambulatoria',
      'Exámenes de laboratorio básicos',
      'Descuentos en farmacias afiliadas',
      'Médico a domicilio (copago)'
    ]
  },
  {
    name: 'Plan Familiar',
    price: 'S/ 149',
    period: '/mes',
    description: 'Protección completa para todos los miembros de tu familia.',
    features: [
      'Todo lo del Plan Esencial',
      'Cobertura de hospitalización',
      'Chequeo preventivo anual',
      'Programa de maternidad'
    ],
    isPopular: true,
  },
  {
    name: 'Plan Premium',
    price: 'S/ 299',
    period: '/mes',
    description: 'Acceso exclusivo a los mejores servicios y especialistas.',
    features: [
      'Todo lo del Plan Familiar',
      'Cobertura internacional',
      'Segunda opinión médica',
      'Reembolsos por atenciones'
    ]
  }
];

const Plans = () => {
  return (
    <section id="planes" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">PLANES Y PRECIOS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Planes de Seguro a tu Medida</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Elige el plan que mejor se adapte a tu estilo de vida y necesidades. Ofrecemos flexibilidad y cobertura integral.
          </p>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
          {plans.map((plan) => (
            <Card key={plan.name} className={`flex flex-col h-full shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-105 ${plan.isPopular ? 'border-accent border-2 relative' : 'border-border'}`}>
              {plan.isPopular && (
                <div className="absolute -top-4 right-4 bg-accent text-accent-foreground px-4 py-1 text-sm font-semibold rounded-full shadow-lg">
                  Más Popular
                </div>
              )}
              <CardHeader className="items-center text-center pt-8">
                <CardTitle className="text-2xl font-headline">{plan.name}</CardTitle>
                <div className="flex items-baseline">
                  <span className="text-4xl font-bold text-primary">{plan.price}</span>
                  <span className="text-muted-foreground">{plan.period}</span>
                </div>
                <CardDescription className="px-4">{plan.description}</CardDescription>
              </CardHeader>
              <CardContent className="flex-grow">
                <ul className="space-y-3">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="flex items-center gap-3">
                      <CheckCircle className="h-5 w-5 text-green-500" />
                      <span className="text-foreground/80">{feature}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
              <CardFooter>
                 <Button asChild className="w-full font-semibold" variant={plan.isPopular ? 'default' : 'outline'}>
                    <Link href="#contacto">Elegir Plan</Link>
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
