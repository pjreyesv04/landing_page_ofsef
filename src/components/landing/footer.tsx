import { ShieldCheck, Twitter, Facebook, Instagram, Mail, MapPin, Phone } from 'lucide-react';
import Link from 'next/link';

const Footer = () => {
  const year = new Date().getFullYear();

  return (
    <footer className="bg-primary/5 border-t" id="footer-contact">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-8">
          <div className="space-y-4">
            <Link href="/" className="flex items-center gap-2">
              <ShieldCheck className="h-8 w-8 text-primary" />
              <span className="font-bold text-xl text-primary font-headline">Redes Seguras</span>
            </Link>
            <p className="text-muted-foreground text-sm">
              Oficina de Seguros de la DIRIS Lima Norte, comprometidos con su bienestar y el de su familia.
            </p>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-foreground">Enlaces Rápidos</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="#sobre-nosotros" className="text-muted-foreground hover:text-primary">Sobre Nosotros</Link></li>
              <li><Link href="#servicios" className="text-muted-foreground hover:text-primary">Servicios</Link></li>
              <li><Link href="#planes" className="text-muted-foreground hover:text-primary">Planes</Link></li>
              <li><Link href="#anuncios" className="text-muted-foreground hover:text-primary">Anuncios</Link></li>
            </ul>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-foreground">Recursos</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="#" className="text-muted-foreground hover:text-primary">Formulario de Reclamo</Link></li>
              <li><Link href="#" className="text-muted-foreground hover:text-primary">Documentos de Póliza</Link></li>
              <li><Link href="#" className="text-muted-foreground hover:text-primary">Preguntas Frecuentes</Link></li>
            </ul>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-foreground">Contacto</h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-start gap-3">
                <MapPin className="h-4 w-4 text-primary mt-1 shrink-0" />
                <span className="text-muted-foreground">Av. Túpac Amaru Km. 5.5, Independencia, Lima</span>
              </li>
              <li className="flex items-start gap-3">
                <Mail className="h-4 w-4 text-primary mt-1 shrink-0" />
                <a href="mailto:seguros@dirislimanorte.gob.pe" className="text-muted-foreground hover:text-primary break-all">seguros@dirislimanorte.gob.pe</a>
              </li>
               <li className="flex items-start gap-3">
                <Phone className="h-4 w-4 text-primary mt-1 shrink-0" />
                <a href="tel:+5115551234" className="text-muted-foreground hover:text-primary">(01) 555-1234</a>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-center md:text-left">
          <p className="text-sm text-muted-foreground order-last md:order-none">
            © {year} Dirección de Redes Integradas de Salud Lima Norte. Todos los derechos reservados.
          </p>
          <div className="flex gap-4">
            <Link href="#" className="text-muted-foreground hover:text-primary transition-colors" aria-label="Twitter">
              <Twitter className="h-5 w-5" />
            </Link>
            <Link href="#" className="text-muted-foreground hover:text-primary transition-colors" aria-label="Facebook">
              <Facebook className="h-5 w-5" />
            </Link>
            <Link href="#" className="text-muted-foreground hover:text-primary transition-colors" aria-label="Instagram">
              <Instagram className="h-5 w-5" />
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
