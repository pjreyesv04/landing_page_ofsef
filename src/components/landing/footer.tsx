import { ShieldCheck, Twitter, Facebook, Instagram, Mail, MapPin, Phone, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import { Button } from '../ui/button';
import { Input } from '../ui/input';

const Footer = () => {
  const year = new Date().getFullYear();

  return (
    <footer className="bg-slate-900 text-slate-300" id="footer-contact">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-8">
          <div className="space-y-4">
            <Link href="/" className="flex items-center gap-2">
              <ShieldCheck className="h-8 w-8 text-accent" />
              <span className="font-bold text-xl text-white font-headline">Redes Seguras</span>
            </Link>
            <p className="text-sm">
              Gestionando el acceso al Seguro Integral de Salud (SIS) y otras coberturas para la comunidad de Lima Norte, bajo el respaldo del Ministerio de Salud.
            </p>
             <div className="flex gap-4 pt-2">
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Twitter">
                <Twitter className="h-5 w-5" />
              </Link>
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Facebook">
                <Facebook className="h-5 w-5" />
              </Link>
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Instagram">
                <Instagram className="h-5 w-5" />
              </Link>
            </div>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-white">Enlaces Rápidos</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="#sobre-nosotros" className="hover:text-white">Sobre Nosotros</Link></li>
              <li><Link href="#servicios" className="hover:text-white">Servicios</Link></li>
              <li><Link href="#coberturas" className="hover:text-white">Coberturas</Link></li>
              <li><Link href="#anuncios" className="hover:text-white">Anuncios</Link></li>
              <li><Link href="#contacto" className="hover:text-white">Contacto</Link></li>
            </ul>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-white">Contacto</h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-start gap-3">
                <MapPin className="h-4 w-4 text-accent mt-1 shrink-0" />
                <span>Av. Túpac Amaru Km. 5.5, Independencia, Lima</span>
              </li>
              <li className="flex items-start gap-3">
                <Mail className="h-4 w-4 text-accent mt-1 shrink-0" />
                <a href="mailto:seguros@dirislimanorte.gob.pe" className="hover:text-white break-all">seguros@dirislimanorte.gob.pe</a>
              </li>
               <li className="flex items-start gap-3">
                <Phone className="h-4 w-4 text-accent mt-1 shrink-0" />
                <a href="tel:+5115551234" className="hover:text-white">(01) 555-1234</a>
              </li>
            </ul>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-white">Boletín Informativo</h3>
            <p className="text-sm">Suscríbase para recibir nuestras últimas noticias y ofertas especiales.</p>
            <form className="flex gap-2">
                <Input type="email" placeholder="Su email" className="bg-slate-800 border-slate-700 text-white" />
                <Button type="submit" size="icon" className="bg-accent hover:bg-accent/80 shrink-0">
                    <ArrowRight className="h-4 w-4" />
                </Button>
            </form>
          </div>
        </div>
      </div>
      <div className="bg-slate-950 py-4">
         <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 text-center text-sm text-slate-400">
             © {year} Dirección de Redes Integradas de Salud Lima Norte. Todos los derechos reservados.
        </div>
      </div>
    </footer>
  );
};

export default Footer;
