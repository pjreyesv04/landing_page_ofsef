"use client";

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  TrendingUp, 
  Users, 
  Building2, 
  UserCheck, 
  Activity, 
  Database,
  FileBarChart,
  ExternalLink
} from 'lucide-react';
import React from 'react';

const reportCategories = [
  {
    title: 'Atenciones por Establecimiento',
    subtitle: '119 Establecimientos',
    icon: Building2,
    type: 'Power BI',
    value: '369K',
    unit: 'atenciones/mes',
    link: 'https://app.powerbi.com/view?r=eyJrIjoiNzQxMWM3ZWEtYzgyNS00NTVkLWJiZTItYzY0YTE2ZjJiODM1IiwidCI6IjAzZmJlMjRiLThkNzMtNDhiZC04OWE1LTYyYmQ4YzdkYmQxZiIsImMiOjR9',
    color: 'from-blue-400 to-blue-600',
    bgColor: 'bg-blue-50'
  },
  {
    title: 'Atenciones por Profesional',
    subtitle: '1,250+ Profesionales',
    icon: UserCheck,
    type: 'Power BI',
    value: '369K',
    unit: 'atenciones/mes',
    link: 'https://app.powerbi.com/view?r=eyJrIjoiMWQyMTliY2ItMGExYS00ODU2LWI4ZmUtM2Y2NTM5MGY3M2ZhIiwidCI6IjAzZmJlMjRiLThkNzMtNDhiZC04OWE1LTYyYmQ4YzdkYmQxZiIsImMiOjR9',
    color: 'from-green-400 to-green-600',
    bgColor: 'bg-green-50'
  },
  {
    title: 'Afiliados SIS',
    subtitle: '9 Distritos',
    icon: Users,
    type: 'Power BI',
    value: '2.05M',
    unit: 'afiliados',
    link: 'https://app.powerbi.com/view?r=eyJrIjoiMDg4MjhlMGEtM2M4ZS00MGM4LTg3N2EtNWYxNmFjNzY1OTRmIiwidCI6IjAzZmJlMjRiLThkNzMtNDhiZC04OWE1LTYyYmQ4YzdkYmQxZiIsImMiOjR9',
    color: 'from-purple-400 to-purple-600',
    bgColor: 'bg-purple-50'
  },
  {
    title: 'Indicadores De Convenio',
    subtitle: '3 Indicadores',
    icon: TrendingUp,
    type: 'Dashboard',
    value: '%',
    unit: 'cumplimiento',
    link: 'https://app.powerbi.com/view?r=eyJrIjoiMGQwY2U1Y2QtMDE5My00YzYxLWJhZTEtOGMxNzkzODE3MzVmIiwidCI6IjAzZmJlMjRiLThkNzMtNDhiZC04OWE1LTYyYmQ4YzdkYmQxZiIsImMiOjR9',
    color: 'from-orange-400 to-orange-600',
    bgColor: 'bg-orange-50'
  },
  {
    title: 'Reportes Mensuales',
    subtitle: 'Gestión Sanitaria',
    icon: FileBarChart,
    type: 'Análisis',
    value: '24',
    unit: 'reportes',
    link: 'http://192.168.22.52:3000/public/dashboard/b7aba5e7-f2c7-4685-8e9f-2f0a3c7a3f81',
    color: 'from-teal-400 to-teal-600',
    bgColor: 'bg-teal-50'
  },
  {
    title: 'Acreditaciones SUSALUD ',
    subtitle: 'SITEDS WEB ',
    icon: Activity,
    type: 'Real Time',
    value: '100% EESS',
    unit: 'monitoreo',
    link: 'https://bi.susalud.gob.pe/QvAJAXZfc/opendoc.htm?document=QV%20Produccion%2FSIG_SUSALUD.qvw&host=QVS%40servidor01106&anonymous=true',
    color: 'from-red-400 to-red-600',
    bgColor: 'bg-red-50'
  }
];

const quickStats = [
  {
    title: 'Total Registros',
    value: '2.1M+',
    icon: Database,
    color: 'from-blue-400 to-blue-600'
  },
  {
    title: 'Reportes Activos',
    value: '24',
    icon: FileBarChart,
    color: 'from-green-400 to-green-600'
  },
  {
    title: 'Tiempo Real',
    value: 'Live',
    icon: Activity,
    color: 'from-purple-400 to-purple-600'
  }
];

const Analytics = () => {
  return (
    <section id="analytics" className="py-20 bg-gradient-to-br from-slate-50 to-blue-50">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center space-y-4 mb-16">
          <p className="font-semibold text-primary">REPORTES & DASHBOARD</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">
            Oficina de Seguros 
          </h2>
          <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
            Acceda a reportes interactivos, dashboards y análisis avanzados 
            de la gestión sanitaria de DIRIS Lima Norte.
          </p>
        </div>

        {/* Report Categories */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {reportCategories.map((category) => {
            const IconComponent = category.icon;
            
            return (
              <Card key={category.title} className={`group hover:scale-105 transition-all duration-300 ${category.bgColor} border-0 overflow-hidden cursor-pointer`}>
                <CardContent className="p-6">
                  <div className="flex items-center justify-between mb-4">
                    <div className={`p-3 rounded-2xl bg-gradient-to-br ${category.color} shadow-lg`}>
                      <IconComponent className="h-8 w-8 text-white" />
                    </div>
                    <Badge variant="secondary" className="text-xs font-medium">
                      {category.type}
                    </Badge>
                  </div>
                  
                  <div className="space-y-2">
                    <h3 className="font-bold text-lg text-gray-800 leading-tight">
                      {category.title}
                    </h3>
                    <p className="text-sm text-gray-600">
                      {category.subtitle}
                    </p>
                    
                    <div className="flex items-baseline space-x-1 pt-2">
                      <span className="text-2xl font-bold text-gray-900">
                        {category.value}
                      </span>
                      <span className="text-sm text-gray-500">
                        {category.unit}
                      </span>
                    </div>
                  </div>

                  <Button asChild size="sm" className="w-full mt-4 bg-gradient-to-r from-gray-600 to-gray-700 hover:from-gray-700 hover:to-gray-800">
                    <a href={category.link} target="_blank" rel="noopener noreferrer">
                      <ExternalLink className="mr-2 h-4 w-4" />
                      Ver Reporte
                    </a>
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Footer Info */}
        <div className="mt-16 text-center">
          <div className="bg-white/60 backdrop-blur-sm rounded-xl p-6 border-0 shadow-lg">
            <div className="flex items-center justify-center space-x-2 mb-3">
              <Activity className="h-5 w-5 text-primary" />
              <span className="font-semibold text-primary">Sistema de Seguimiento y Monitoreo</span>
            </div>
            <p className="text-muted-foreground text-sm max-w-2xl mx-auto">
              Todos los reportes se actualizan automáticamente desde nuestras bases de datos principales. 
              Para acceso completo a dashboards interactivos, contacte al área de Sistemas de Información.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Analytics;
