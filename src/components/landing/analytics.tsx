"use client";

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  BarChart3, 
  PieChart, 
  TrendingUp, 
  Users, 
  Building2, 
  UserCheck, 
  Activity, 
  Database,
  FileBarChart,
  ExternalLink,
  Download
} from 'lucide-react';
import React from 'react';

const reportCategories = [
  {
    title: 'Atenciones por Establecimiento',
    description: 'Reportes detallados de atenciones médicas por cada establecimiento de salud de la red DIRIS Lima Norte.',
    icon: Building2,
    type: 'power-bi',
    status: 'Actualizado',
    lastUpdate: 'Última actualización: Julio 2025',
    metrics: ['119 Establecimientos', '369,327 Atenciones/mes', '2,053,046 Registros'],
    link: '#',
    color: 'bg-blue-500'
  },
  {
    title: 'Atenciones por Profesional',
    description: 'Análisis de productividad y atenciones realizadas por cada profesional de salud en la red.',
    icon: UserCheck,
    type: 'database',
    status: 'En tiempo real',
    lastUpdate: 'Actualización automática cada hora',
    metrics: ['1,250+ Profesionales', '295 Atenciones/día promedio', '98.5% Disponibilidad'],
    link: '#',
    color: 'bg-green-500'
  },
  {
    title: 'Afiliados SIS por Distrito',
    description: 'Distribución geográfica y demográfica de afiliados al Seguro Integral de Salud por distrito.',
    icon: Users,
    type: 'power-bi',
    status: 'Actualizado',
    lastUpdate: 'Última actualización: Julio 2025',
    metrics: ['2,053,046 Afiliados', '7 Distritos', '85% Cobertura poblacional'],
    link: '#',
    color: 'bg-purple-500'
  },
  {
    title: 'Indicadores de Gestión',
    description: 'Dashboard ejecutivo con KPIs principales de gestión sanitaria y administrativa.',
    icon: TrendingUp,
    type: 'database',
    status: 'En tiempo real',
    lastUpdate: 'Actualización continua',
    metrics: ['15 KPIs principales', '92% Cumplimiento metas', '24/7 Monitoreo'],
    link: '#',
    color: 'bg-orange-500'
  }
];

const quickStats = [
  {
    title: 'Total Registros',
    value: '2.1M+',
    icon: Database,
    change: '+12.5%',
    changeType: 'positive'
  },
  {
    title: 'Reportes Disponibles',
    value: '24',
    icon: FileBarChart,
    change: '+3',
    changeType: 'positive'
  },
  {
    title: 'Actualización',
    value: 'Tiempo Real',
    icon: Activity,
    change: 'Live',
    changeType: 'neutral'
  }
];

const Analytics = () => {
  const getTypeIcon = (type: string) => {
    return type === 'power-bi' ? BarChart3 : PieChart;
  };

  const getTypeBadge = (type: string) => {
    return type === 'power-bi' ? 'Power BI' : 'Base de Datos';
  };

  return (
    <section id="analytics" className="py-20 bg-gradient-to-br from-slate-50 to-blue-50">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center space-y-4 mb-16">
          <p className="font-semibold text-primary">ANALYTICS & REPORTES</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">
            Centro de Inteligencia de Datos
          </h2>
          <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
            Acceda a reportes interactivos, dashboards en tiempo real y análisis avanzados 
            de la gestión sanitaria de DIRIS Lima Norte.
          </p>
        </div>

        {/* Quick Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {quickStats.map((stat) => {
            const IconComponent = stat.icon;
            return (
              <Card key={stat.title} className="p-6 bg-white/70 backdrop-blur-sm border-0 shadow-lg">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-medium text-muted-foreground">{stat.title}</p>
                    <p className="text-2xl font-bold">{stat.value}</p>
                    <div className="flex items-center mt-1">
                      <span className={`text-xs px-2 py-1 rounded-full ${
                        stat.changeType === 'positive' ? 'bg-green-100 text-green-700' :
                        stat.changeType === 'negative' ? 'bg-red-100 text-red-700' :
                        'bg-blue-100 text-blue-700'
                      }`}>
                        {stat.change}
                      </span>
                    </div>
                  </div>
                  <div className="bg-primary/10 p-3 rounded-full">
                    <IconComponent className="h-6 w-6 text-primary" />
                  </div>
                </div>
              </Card>
            );
          })}
        </div>

        {/* Report Categories */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {reportCategories.map((category) => {
            const IconComponent = category.icon;
            const TypeIconComponent = getTypeIcon(category.type);
            
            return (
              <Card key={category.title} className="group hover:shadow-2xl transition-all duration-300 bg-white/80 backdrop-blur-sm border-0 overflow-hidden">
                {/* Color Bar */}
                <div className={`h-1 w-full ${category.color}`} />
                
                <CardHeader className="pb-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center space-x-3">
                      <div className={`p-3 rounded-xl ${category.color} bg-opacity-10`}>
                        <IconComponent className="h-8 w-8 text-white" style={{filter: `drop-shadow(0 0 8px ${category.color.replace('bg-', '')})`}} />
                      </div>
                      <div>
                        <CardTitle className="text-xl font-semibold">{category.title}</CardTitle>
                        <div className="flex items-center space-x-2 mt-1">
                          <Badge variant="secondary" className="text-xs">
                            <TypeIconComponent className="w-3 h-3 mr-1" />
                            {getTypeBadge(category.type)}
                          </Badge>
                          <Badge variant={category.status === 'En tiempo real' ? 'default' : 'outline'} className="text-xs">
                            {category.status}
                          </Badge>
                        </div>
                      </div>
                    </div>
                  </div>
                </CardHeader>

                <CardContent className="space-y-4">
                  <CardDescription className="text-base leading-relaxed">
                    {category.description}
                  </CardDescription>

                  {/* Metrics */}
                  <div className="grid grid-cols-1 gap-2">
                    {category.metrics.map((metric, index) => (
                      <div key={index} className="flex items-center space-x-2 text-sm">
                        <div className="w-2 h-2 bg-primary rounded-full opacity-60" />
                        <span className="text-muted-foreground">{metric}</span>
                      </div>
                    ))}
                  </div>

                  <div className="pt-2 space-y-2">
                    <p className="text-xs text-muted-foreground">{category.lastUpdate}</p>
                    
                    <div className="flex space-x-2">
                      <Button asChild size="sm" className="flex-1">
                        <a href={category.link} target="_blank" rel="noopener noreferrer">
                          <ExternalLink className="mr-2 h-4 w-4" />
                          Ver Reporte
                        </a>
                      </Button>
                      <Button variant="outline" size="sm">
                        <Download className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
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
              <span className="font-semibold text-primary">Sistema de Monitoreo en Tiempo Real</span>
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
