"use client";

import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Menu, ShieldCheck, Phone, Mail, MapPin, Facebook, Twitter, Instagram } from 'lucide-react';
import { useState } from 'react';

// --- URL CORRECTA YA APLICADA ---
const SISTEMA_URL = 'http://simsic.dirislimanorte.gob.pe/indicadores/sistema.php'; 

const navLinks = [
  { href: '#sobre-nosotros', label: 'Sobre Nosotros' },
  { href: '#estadisticas', label: 'Nuestras Cifras' },
  { href: '#servicios', label: 'Nuestros Servicios' },
  { href: '#porque-elegirnos', label: 'Nuestro Compromiso' },
  { href: '#planes', label: 'Planes SIS' },
  { href: '#recursos', label: 'Recursos' },
  { href: '#anuncios', label: 'Anuncios' },
  { href: '#contacto', label: 'Contáctenos' },
];

const Header = () => {
  const [isMenuOpen, setMenuOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 w-full bg-background shadow-md">
      {/* Top Bar */}
      <div className="bg-primary text-primary-foreground py-2">
        <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
            <div className="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-6 text-xs sm:text-sm">
              <div className="flex items-center gap-2">
                <Phone className="h-3 w-3" />
                <span>Teléfono: (01) 2011340</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="h-3 w-3" />
                <span>seguros@dirislimanorte.gob.pe</span>
              </div>
              <div className="hidden md:flex items-center gap-2">
                <MapPin className="h-3 w-3" />
                <span>Lun-Vie: 8:00-4:30</span>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <span className="text-xs hidden sm:inline">Síguenos:</span>
              <div className="flex gap-2">
                <Link href="https://web.facebook.com/DIRISLimaNorte/?_rdc=1&_rdr" className="hover:text-accent transition-colors">
                  <Facebook className="h-3 w-3" />
                </Link>
                <Link href="https://x.com/DirisLimaNorte" className="hover:text-accent transition-colors">
                  <Twitter className="h-3 w-3" />
                </Link>
                <Link href="https://www.instagram.com/dirislimanorte_oficial/" className="hover:text-accent transition-colors">
                  <Instagram className="h-3 w-3" />
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      {/* Main Navigation */}
      <div className="container mx-auto flex h-20 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <Link href="/" className="flex items-center gap-2">
          <ShieldCheck className="h-8 w-8 text-primary" />
          <span className="font-bold text-xl text-primary font-headline">Oficina de Seguros</span>
        </Link>

        <nav className="hidden lg:flex items-center gap-8">
          {navLinks.map((link) => (
            <Link key={link.href} href={link.href} className="text-sm font-medium text-foreground hover:text-primary transition-colors">
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-4">
            <Button asChild className="hidden lg:flex bg-accent text-accent-foreground hover:bg-accent/90 font-semibold">
              <Link 
                href={SISTEMA_URL}
                target="_blank"
                rel="noopener noreferrer"
              >
                Acceder al Sistema
              </Link>
            </Button>
            
            <div className="lg:hidden">
            <Sheet open={isMenuOpen} onOpenChange={setMenuOpen}>
                <SheetTrigger asChild>
                <Button variant="ghost" size="icon">
                    <Menu className="h-6 w-6" />
                    <span className="sr-only">Abrir menú</span>
                </Button>
                </SheetTrigger>
                <SheetContent side="right">
                <div className="flex flex-col gap-6 p-6">
                    <Link href="/" className="flex items-center gap-2 mb-4" onClick={() => setMenuOpen(false)}>
                    <ShieldCheck className="h-8 w-8 text-primary" />
                    <span className="font-bold text-lg text-primary font-headline">Oficina de Seguros</span>
                    </Link>
                    {navLinks.map((link) => (
                    <Link key={link.href} href={link.href} className="text-lg font-medium" onClick={() => setMenuOpen(false)}>
                        {link.label}
                    </Link>
                    ))}
                    <Button asChild className="bg-accent text-accent-foreground hover:bg-accent/90 mt-4">
                      <Link 
                        href={SISTEMA_URL}
                        target="_blank"
                        rel="noopener noreferrer"
                        onClick={() => setMenuOpen(false)}
                      >
                        Accede al Sistema
                      </Link>
                    </Button>
                </div>
                </SheetContent>
            </Sheet>
            </div>
        </div>
      </div>
    </header>
  );
};

export default Header;