"use client";

import { useEffect, useState } from 'react';
import { Eye } from 'lucide-react';

interface VisitorStats {
  totalVisits: number;
  todayVisits: number;
  lastVisit: string;
}

const VisitorCounter = () => {
  const [stats, setStats] = useState<VisitorStats>({
    totalVisits: 0,
    todayVisits: 0,
    lastVisit: ''
  });
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    // Solo ejecutar en el cliente
    if (typeof window === 'undefined') return;

    const updateVisitorStats = () => {
      const now = new Date();
      const today = now.toDateString();
      
      // Obtener estadísticas existentes
      const existingStats = localStorage.getItem('visitor-stats');
      let currentStats: VisitorStats = {
        totalVisits: 0,
        todayVisits: 0,
        lastVisit: ''
      };

      if (existingStats) {
        currentStats = JSON.parse(existingStats);
      }

      // Verificar visitas de hoy
      const todayVisits = localStorage.getItem('today-visits');
      let todayVisitsList: { date: string; count: number } = { date: today, count: 0 };
      
      if (todayVisits) {
        const parsed = JSON.parse(todayVisits);
        if (parsed.date === today) {
          todayVisitsList = parsed;
        } else {
          // Nuevo día, reiniciar contador
          todayVisitsList = { date: today, count: 0 };
        }
      }

      // Verificar si ya visitó hoy este navegador
      const lastVisitToday = localStorage.getItem('last-visit-today');
      let shouldCountTodayVisit = true;
      
      if (lastVisitToday === today) {
        shouldCountTodayVisit = false;
      } else {
        localStorage.setItem('last-visit-today', today);
      }

      // Actualizar estadísticas
      const newStats: VisitorStats = {
        totalVisits: currentStats.totalVisits + 1,
        todayVisits: shouldCountTodayVisit ? todayVisitsList.count + 1 : todayVisitsList.count,
        lastVisit: now.toISOString()
      };

      // Guardar estadísticas actualizadas
      localStorage.setItem('visitor-stats', JSON.stringify(newStats));
      
      // Actualizar visitas de hoy
      if (shouldCountTodayVisit) {
        localStorage.setItem('today-visits', JSON.stringify({
          date: today,
          count: newStats.todayVisits
        }));
      }

      setStats(newStats);
      setIsLoaded(true);
    };

    const getOrCreateVisitorId = (): string => {
      let visitorId = localStorage.getItem('visitor-id');
      if (!visitorId) {
        visitorId = 'visitor-' + Math.random().toString(36).substr(2, 9) + Date.now().toString(36);
        localStorage.setItem('visitor-id', visitorId);
      }
      return visitorId;
    };

    updateVisitorStats();
  }, []);

  if (!isLoaded) {
    return (
      <div className="flex items-center gap-4 text-slate-400 text-sm">
        <div className="flex items-center gap-1">
          <Eye className="h-4 w-4" />
          <span>Cargando...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-center gap-6 text-slate-400 text-sm">
      <div className="flex items-center gap-1">
        <Eye className="h-4 w-4" />
        <span>Visitas totales: <strong className="text-slate-300">{stats.totalVisits.toLocaleString('es-PE')}</strong></span>
      </div>
      <div className="flex items-center gap-1">
        <Eye className="h-4 w-4" />
        <span>Hoy: <strong className="text-slate-300">{stats.todayVisits.toLocaleString('es-PE')}</strong></span>
      </div>
    </div>
  );
};

export default VisitorCounter;
