"use client";

import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Clock, Phone, Mail, MapPin, Calendar, MessageCircle, Globe } from 'lucide-react';
import Link from 'next/link';

const ContactInfo = () => {
  return (
    <section className="py-16 bg-gradient-to-br from-primary/5 to-accent/5">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <p className="font-semibold text-primary mb-2">INFORMACIÓN DE CONTACTO</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline mb-4">
            Estamos Aquí Para Ayudarte
          </h2>
          <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
            Múltiples canales de atención para brindarte el mejor servicio y resolver todas tus consultas sobre el SIS.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
          {/* Horarios de Atención */}
          <Card className="text-center hover:shadow-lg transition-all duration-300 border-l-4 border-l-primary">
            <CardContent className="p-6">
              <div className="bg-primary/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                <Clock className="h-6 w-6 text-primary" />
              </div>
              <h3 className="font-semibold text-lg mb-3">Horarios de Atención</h3>
              <div className="space-y-2 text-sm text-muted-foreground">
                <p><strong className="text-foreground">Lunes a Viernes:</strong><br />8:00 AM - 5:00 PM</p>
                <p><strong className="text-foreground">Sábados:</strong><br />8:00 AM - 1:00 PM</p>
                <p><strong className="text-primary">Emergencias:</strong><br />24/7</p>
              </div>
            </CardContent>
          </Card>

          {/* Teléfonos */}
          <Card className="text-center hover:shadow-lg transition-all duration-300 border-l-4 border-l-accent">
            <CardContent className="p-6">
              <div className="bg-accent/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                <Phone className="h-6 w-6 text-accent" />
              </div>
              <h3 className="font-semibold text-lg mb-3">Líneas Telefónicas</h3>
              <div className="space-y-2 text-sm text-muted-foreground">
                <p><strong className="text-foreground">Consultas Generales:</strong><br />(01) 2011340</p>
                {/* TEMPORALMENTE DESHABILITADO - WhatsApp */}
                {/* <p><strong className="text-foreground">WhatsApp:</strong><br />+51 987 654 321</p> */}
                <p><strong className="text-primary">Información:</strong><br />(01) 2011340</p>
              </div>
            </CardContent>
          </Card>

          {/* Atención Digital */}
          <Card className="text-center hover:shadow-lg transition-all duration-300 border-l-4 border-l-green-500">
            <CardContent className="p-6">
              <div className="bg-green-500/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                <Globe className="h-6 w-6 text-green-600" />
              </div>
              <h3 className="font-semibold text-lg mb-3">Atención Virtual</h3>
              <div className="space-y-2 text-sm text-muted-foreground">
                <p><strong className="text-foreground">Portal Web:</strong><br />24 horas disponible</p>
                <p><strong className="text-foreground">Chat en Línea:</strong><br />Lun-Vie: 8:00-17:00</p>
                <p><strong className="text-green-600">Videoconferencia:</strong><br />Con cita previa</p>
              </div>
            </CardContent>
          </Card>

          {/* Ubicación */}
          <Card className="text-center hover:shadow-lg transition-all duration-300 border-l-4 border-l-blue-500">
            <CardContent className="p-6">
              <div className="bg-blue-500/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                <MapPin className="h-6 w-6 text-blue-600" />
              </div>
              <h3 className="font-semibold text-lg mb-3">Ubicación</h3>
              <div className="space-y-2 text-sm text-muted-foreground">
                <p><strong className="text-foreground">Distrito:</strong><br />Independencia, Lima Norte</p>
                <p><strong className="text-foreground">Transporte:</strong><br />Cerca al Metro</p>
                <p><strong className="text-blue-600">Estacionamiento:</strong><br />Disponible y gratuito</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Botones de Acción Rápida */}
        <div className="bg-white/50 backdrop-blur-sm rounded-2xl p-8 border">
          <h3 className="text-xl font-semibold text-center mb-6">Acceso Rápido</h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {/* TEMPORALMENTE DESHABILITADO - WhatsApp */}
            {/* <Button asChild className="h-auto p-4 flex-col gap-2 bg-green-600 hover:bg-green-700">
              <Link href="https://wa.me/51987654321" target="_blank">
                <MessageCircle className="h-5 w-5" />
                <span className="text-sm">WhatsApp</span>
              </Link>
            </Button> */}
            
            <Button asChild variant="outline" className="h-auto p-4 flex-col gap-2 hover:bg-primary hover:text-primary-foreground">
              <Link href="tel:+515213400">
                <Phone className="h-5 w-5" />
                <span className="text-sm">Llamar Ahora</span>
              </Link>
            </Button>
            
            <Button asChild variant="outline" className="h-auto p-4 flex-col gap-2 hover:bg-accent hover:text-accent-foreground">
              <Link href="#contacto">
                <Calendar className="h-5 w-5" />
                <span className="text-sm">Agendar Cita</span>
              </Link>
            </Button>
            
            <Button asChild variant="outline" className="h-auto p-4 flex-col gap-2 hover:bg-blue-600 hover:text-white">
              <Link href="mailto:seguros@dirislimanorte.gob.pe">
                <Mail className="h-5 w-5" />
                <span className="text-sm">Enviar Email</span>
              </Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ContactInfo;
