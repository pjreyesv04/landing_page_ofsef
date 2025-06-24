import Header from '@/components/landing/header';
import Hero from '@/components/landing/hero';
import Services from '@/components/landing/services';
import Plans from '@/components/landing/plans';
import Announcements from '@/components/landing/announcements';
import Resources from '@/components/landing/resources';
import Contact from '@/components/landing/contact';
import Footer from '@/components/landing/footer';

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen bg-background">
      <Header />
      <main className="flex-grow">
        <Hero />
        <Services />
        <Plans />
        <Announcements />
        <Resources />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}
