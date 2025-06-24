import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Mail, MapPin, Phone } from 'lucide-react';

const contactInfo = [
  {
    icon: <Phone className="h-6 w-6 text-primary" />,
    title: 'Teléfono',
    value: '(01) 555-1234',
    href: 'tel:+5115551234'
  },
  {
    icon: <Mail className="h-6 w-6 text-primary" />,
    title: 'Correo Electrónico',
    value: 'seguros@dirislimanorte.gob.pe',
    href: 'mailto:seguros@dirislimanorte.gob.pe'
  },
  {
    icon: <MapPin className="h-6 w-6 text-primary" />,
    title: 'Dirección',
    value: 'Av. Túpac Amaru Km. 5.5, Independencia, Lima',
    href: 'https://maps.google.com/?q=Av.+Túpac+Amaru+Km.+5.5,+Independencia,+Lima'
  }
];

const Contact = () => {
  return (
    <section id="contacto" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary">Contáctenos</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Estamos aquí para ayudarle. Póngase en contacto con nosotros a través de cualquiera de estos canales.
          </p>
        </div>
        <div className="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
          {contactInfo.map((info) => (
            <Card key={info.title} className="text-center shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardHeader className="items-center">
                <div className="bg-accent/20 p-4 rounded-full">
                  {info.icon}
                </div>
              </CardHeader>
              <CardContent>
                <CardTitle className="text-lg font-headline mb-1">{info.title}</CardTitle>
                <a href={info.href} target="_blank" rel="noopener noreferrer" className="text-muted-foreground hover:text-primary transition-colors break-words">
                  {info.value}
                </a>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Contact;
