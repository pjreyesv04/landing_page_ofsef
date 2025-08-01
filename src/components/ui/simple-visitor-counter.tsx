"use client";

import { useEffect, useState } from 'react';
import { Eye } from 'lucide-react';

const SimpleVisitorCounter = () => {
  const [visitorCount, setVisitorCount] = useState<number>(0);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const getVisitorCount = () => {
      const existingStats = localStorage.getItem('visitor-stats');
      if (existingStats) {
        const stats = JSON.parse(existingStats);
        setVisitorCount(stats.totalVisits || 0);
      }
      setIsLoaded(true);
    };

    // Pequeño delay para asegurar que el contador principal se ejecute primero
    const timer = setTimeout(getVisitorCount, 100);
    
    return () => clearTimeout(timer);
  }, []);

  if (!isLoaded) {
    return (
      <div className="flex items-center gap-1 text-xs text-muted-foreground">
        <Eye className="h-3 w-3" />
        <span>---</span>
      </div>
    );
  }

  return (
    <div className="flex items-center gap-1 text-xs text-muted-foreground">
      <Eye className="h-3 w-3" />
      <span title="Visitas totales">{visitorCount.toLocaleString('es-PE')} visitas</span>
    </div>
  );
};

export default SimpleVisitorCounter;
