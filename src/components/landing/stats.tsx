import { Users, Stethoscope, Hospital, BarChart3 } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

const stats = [
  {
    icon: <Users className="h-10 w-10 text-primary" />,
    value: '1.8M+',
    label: 'Afiliados Protegidos',
    description: 'Asegurando a la comunidad de Lima Norte.',
  },
  {
    icon: <Stethoscope className="h-10 w-10 text-primary" />,
    value: '5M+',
    label: 'Atenciones Anuales',
    description: 'Consultas, emergencias y procedimientos cubiertos.',
  },
  {
    icon: <Hospital className="h-10 w-10 text-primary" />,
    value: '300+',
    label: 'Establecimientos de Salud',
    description: 'Nuestra red de salud a tu disposición.',
  },
  {
    icon: <BarChart3 className="h-10 w-10 text-primary" />,
    value: '95%',
    label: 'Satisfacción del Afiliado',
    description: 'Comprometidos con un servicio de calidad.',
  },
];

const Stats = () => {
  return (
    <section id="estadisticas" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">NUESTRO IMPACTO EN CIFRAS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Resultados que Hablan por Sí Mismos</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Estamos orgullosos de nuestro trabajo y del impacto positivo que generamos en la salud de la comunidad de Lima Norte.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {stats.map((stat) => (
            <Card key={stat.label} className="text-center shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardHeader className="items-center pb-4">
                 <div className="bg-primary/10 p-4 rounded-full mb-2">
                    {stat.icon}
                </div>
                <CardTitle className="text-4xl font-bold text-primary">{stat.value}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-lg font-semibold">{stat.label}</p>
                <p className="text-sm text-muted-foreground">{stat.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Stats;
