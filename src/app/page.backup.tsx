import Header from '@/components/landing/header';
import Hero from '@/components/landing/hero';
import About from '@/components/landing/about';
import Services from '@/components/landing/services';
import Plans from '@/components/landing/plans';
import Announcements from '@/components/landing/announcements';
import Contact from '@/components/landing/contact';
import ContactInfo from '@/components/landing/contact-info';
import FloatingContactButton from '@/components/landing/floating-contact';
import Footer from '@/components/landing/footer';
import Stats from '@/components/landing/stats';
import Resources from '@/components/landing/resources';

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen bg-background">
      <Header />
      <main className="flex-grow">
        <Hero />
        <About />
        <Stats />
        <Services />
        <Plans />
        <Resources />
        <ContactInfo />
        <Announcements />
        <Contact />
      </main>
      <Footer />
      <FloatingContactButton />
    </div>
  );
}
