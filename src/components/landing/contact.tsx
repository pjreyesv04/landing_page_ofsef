"use client";

import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { Form, FormControl, FormField, FormItem, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { getImagePath } from '@/lib/image-paths';
import Image from 'next/image';
import { useToast } from "@/hooks/use-toast";
import { ArrowRight } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

const formSchema = z.object({
  name: z.string().min(2, { message: "El nombre es requerido." }),
  email: z.string().email({ message: "Por favor ingrese un email válido." }),
  subject: z.string().min(3, { message: "El asunto es requerido." }),
  message: z.string().min(10, { message: "El mensaje debe tener al menos 10 caracteres." }),
});

const Contact = () => {
  const { toast } = useToast();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { name: "", email: "", subject: "", message: "" },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    // Crear el enlace mailto con los datos del formulario
    const emailTo = "oficina.segurosdirisln@gmail.com";
    const subject = encodeURIComponent(values.subject);
    const body = encodeURIComponent(
      `Nombre: ${values.name}\nEmail: ${values.email}\n\nMensaje:\n${values.message}`
    );
    
    const mailtoLink = `mailto:${emailTo}?subject=${subject}&body=${body}`;
    
    // Abrir cliente de correo
    window.location.href = mailtoLink;
    
    toast({
      title: "Redirigiendo al cliente de correo",
      description: "Se abrirá su aplicación de correo con el mensaje prellenado.",
    });
    
    // Limpiar formulario después de un breve delay
    setTimeout(() => {
      form.reset();
    }, 1000);
  }

  return (
    <section 
      id="contacto" 
      className="py-24 relative"
    >
      <Image
        src={getImagePath("images/backgrounds/call-center.jpg")}
        alt="Agentes de call center"
        fill
        className="object-cover"
        data-ai-hint="call center agents"
      />
      <div className="absolute inset-0 bg-background/90"></div>
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid lg:grid-cols-2 gap-12">
            <div className="space-y-6">
                <p className="font-semibold text-primary">CONTÁCTENOS</p>
                <h2 className="text-3xl md:text-4xl font-bold font-headline">
                    ¿Tiene alguna consulta, trámite o sugerencia? Estamos para ayudarlo.
                </h2>
                <p className="text-lg text-muted-foreground">
                  Nuestro equipo está listo para responder cualquier duda o solicitud relacionada con seguros de salud, atención al usuario, trámites administrativos, reclamos,
                  orientación sobre coberturas y cualquier otro tema vinculado a la DIRIS Lima Norte. 
                  No dude en comunicarse con nosotros.
                </p>
                <div className="border-l-4 border-primary pl-6 space-y-3">
                    <h3 className="font-semibold text-lg">Oficina Principal</h3>
                    <p className="text-muted-foreground">Calle A Mz. 02 Lt. 03 Asoc. Víctor Raúl Haya de la Torre - Distrito Independencia - Lima - Perú</p>
                    <p className="text-muted-foreground"><strong>Email:</strong> oficina.segurosdirisln@gmail.com</p>
                    <p className="text-muted-foreground"><strong>Teléfono:</strong> (01) 521-3400</p>
                    <div className="mt-4 pt-3 border-t border-muted">
                        <h4 className="font-semibold text-base text-primary">Horarios de Atención</h4>
                        <div className="mt-2 space-y-1">
                            <p className="text-sm text-muted-foreground"><strong>Lunes a Viernes:</strong> 8:00 AM - 16:30 PM</p>
                            <p className="text-sm text-muted-foreground"><strong>telefono:</strong>(01) 521-3401</p>
                        
                        </div>
                    </div>
                </div>
            </div>
            <div>
                 <Card className="p-8 shadow-2xl bg-card/80 backdrop-blur-sm">
                    <CardHeader className="p-0 mb-6">
                        <CardTitle className="text-2xl font-headline">Envíenos un Mensaje</CardTitle>
                    </CardHeader>
                    <CardContent className="p-0">
                        <Form {...form}>
                            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                                <div className="grid sm:grid-cols-2 gap-4">
                                <FormField control={form.control} name="name" render={({ field }) => (
                                    <FormItem><FormControl><Input placeholder="Su Nombre" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <FormField control={form.control} name="email" render={({ field }) => (
                                    <FormItem><FormControl><Input type="email" placeholder="Su Email" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                </div>
                                <FormField control={form.control} name="subject" render={({ field }) => (
                                    <FormItem><FormControl><Input placeholder="Asunto" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <FormField control={form.control} name="message" render={({ field }) => (
                                    <FormItem><FormControl><Textarea placeholder="Su Mensaje" rows={5} {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <Button type="submit" size="lg" className="w-full bg-accent hover:bg-accent/90">
                                    Enviar por Email <ArrowRight className="ml-2 h-5 w-5"/>
                                </Button>
                                <p className="text-xs text-muted-foreground text-center mt-2">
                                    Al hacer clic, se abrirá su cliente de correo con el mensaje prellenado para enviar a oficina.segurosdirisln@gmail.com
                                </p>
                            </form>
                        </Form>
                    </CardContent>
                 </Card>
            </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;

