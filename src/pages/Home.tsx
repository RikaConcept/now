import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { api } from '../lib/api';
import * as Icons from 'lucide-react';

interface PartnerShop {
  id: string;
  name: string;
  description: string;
  image_url: string;
  website_url: string;
  discount_percentage: number;
  category: string;
}

interface SiteSettings {
  app_name: string;
  logo_url: string;
  primary_color: string;
  secondary_color: string;
  accent_color: string;
  hero_title: string;
  hero_description: string;
  why_choose_title: string;
  why_choose_description: string;
  feature_1_title: string;
  feature_1_description: string;
  feature_1_icon: string;
  feature_2_title: string;
  feature_2_description: string;
  feature_2_icon: string;
  feature_3_title: string;
  feature_3_description: string;
  feature_3_icon: string;
  stats_members: string;
  stats_partners: string;
  stats_satisfaction: string;
  contact_title: string;
  contact_description: string;
  contact_address: string;
  contact_phone: string;
  contact_hours: string;
  contact_email: string;
  contact_support_email: string;
  footer_description: string;
  footer_copyright: string;
  social_facebook: string;
  social_twitter: string;
  social_instagram: string;
  social_linkedin: string;
}

export default function Home() {
  const { user, signOut } = useAuth();
  const [partnerShops, setPartnerShops] = useState<PartnerShop[]>([]);
  const [settings, setSettings] = useState<SiteSettings | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const handleSignOut = async () => {
    await signOut();
  };

  const loadData = async () => {
    try {
      const [shopsResponse, settingsResponse] = await Promise.all([
        api.getPartnerShops(),
        api.getSiteSettings()
      ]);

      if (shopsResponse.success && shopsResponse.data) {
        setPartnerShops(shopsResponse.data.slice(0, 6));
      }

      if (settingsResponse.success && settingsResponse.data) {
        // Si les settings existent, les utiliser
        setSettings(settingsResponse.data);
      } else {
        // Sinon, utiliser des valeurs par défaut
        setSettings({
          app_name: 'NOW!CONCEPT',
          logo_url: '',
          primary_color: '#2563eb',
          secondary_color: '#4f46e5',
          accent_color: '#fbbf24',
          hero_title: 'Rejoignez NOW!Lovers',
          hero_description: 'Découvrez une communauté de membres bénéficiant de réductions exceptionnelles',
          why_choose_title: 'Pourquoi rejoindre NOW!Lovers ?',
          why_choose_description: 'Des avantages exclusifs, une communauté engagée',
          feature_1_title: 'Réductions Exclusives',
          feature_1_description: 'Bénéficiez de réductions chez nos partenaires',
          feature_1_icon: 'Tag',
          feature_2_title: 'Communauté Active',
          feature_2_description: 'Rejoignez une communauté de membres actifs',
          feature_2_icon: 'Users',
          feature_3_title: 'Service Personnalisé',
          feature_3_description: 'Bénéficiez d\'un service client dédié',
          feature_3_icon: 'Award',
          stats_members: '1,000+',
          stats_partners: '50+',
          stats_satisfaction: '4.8/5',
          contact_title: 'Contactez-nous',
          contact_description: 'Notre équipe est à votre écoute',
          contact_address: '123 Rue de la République\n75001 Paris',
          contact_phone: '+33 1 23 45 67 89',
          contact_hours: 'Lun-Ven: 9h-18h',
          contact_email: 'contact@nowlovers.com',
          contact_support_email: 'support@nowlovers.com',
          footer_description: 'NOW!Lovers - La communauté qui partage les bonnes affaires',
          footer_copyright: '© 2025 NOW!Lovers. Tous droits réservés.',
          social_facebook: '',
          social_twitter: '',
          social_instagram: '',
          social_linkedin: ''
        });
      }
    } catch (error) {
      console.error('Error loading data:', error);
      // Utiliser valeurs par défaut en cas d'erreur
      setSettings({
        app_name: 'NOW!Lovers',
        logo_url: '',
        primary_color: '#2563eb',
        secondary_color: '#4f46e5',
        accent_color: '#fbbf24',
        hero_title: 'Rejoignez NOW!Lovers',
        hero_description: 'Découvrez une communauté de membres',
        why_choose_title: 'Pourquoi nous rejoindre ?',
        why_choose_description: 'Des avantages exclusifs',
        feature_1_title: 'Réductions',
        feature_1_description: 'Réductions chez nos partenaires',
        feature_1_icon: 'Tag',
        feature_2_title: 'Communauté',
        feature_2_description: 'Communauté active',
        feature_2_icon: 'Users',
        feature_3_title: 'Service',
        feature_3_description: 'Service dédié',
        feature_3_icon: 'Award',
        stats_members: '1,000+',
        stats_partners: '50+',
        stats_satisfaction: '4.8/5',
        contact_title: 'Contact',
        contact_description: 'Nous sommes là',
        contact_address: 'Paris, France',
        contact_phone: '+33 1 23 45 67 89',
        contact_hours: 'Lun-Ven: 9h-18h',
        contact_email: 'contact@nowlovers.com',
        contact_support_email: 'support@nowlovers.com',
        footer_description: 'NOW!Lovers',
        footer_copyright: '© 2025 NOW!Lovers',
        social_facebook: '',
        social_twitter: '',
        social_instagram: '',
        social_linkedin: ''
      });
    }

    setLoading(false);
  };

  const getIcon = (iconName: string) => {
    const Icon = (Icons as any)[iconName] || Icons.Star;
    return Icon;
  };

  if (!settings) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  const Feature1Icon = getIcon(settings.feature_1_icon);
  const Feature2Icon = getIcon(settings.feature_2_icon);
  const Feature3Icon = getIcon(settings.feature_3_icon);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section
        className="text-white py-20"
        style={{
          background: `linear-gradient(to bottom right, ${settings.primary_color}, ${settings.secondary_color})`
        }}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              {settings.hero_title}
            </h1>
            <p className="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">
              {settings.hero_description}
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/generate-code"
                className="px-8 py-3 rounded-lg font-semibold transition-colors inline-flex items-center justify-center"
                style={{
                  backgroundColor: settings.accent_color,
                  color: '#111827'
                }}
              >
                Rejoindre la communauté {settings.app_name}
                <Icons.ArrowRight className="ml-2 h-5 w-5" />
              </Link>
              <a
                href="#partners"
                className="border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white transition-colors"
                style={{
                  ':hover': { color: settings.primary_color }
                }}
              >
                Découvrir nos partenaires
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="about" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              {settings.why_choose_title}
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              {settings.why_choose_description}
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.primary_color}20` }}>
                <Feature1Icon className="h-8 w-8" style={{ color: settings.primary_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">{settings.feature_1_title}</h3>
              <p className="text-gray-600">
                {settings.feature_1_description}
              </p>
            </div>

            <div className="text-center p-6">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.secondary_color}20` }}>
                <Feature2Icon className="h-8 w-8" style={{ color: settings.secondary_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">{settings.feature_2_title}</h3>
              <p className="text-gray-600">
                {settings.feature_2_description}
              </p>
            </div>

            <div className="text-center p-6">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.accent_color}20` }}>
                <Feature3Icon className="h-8 w-8" style={{ color: settings.accent_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">{settings.feature_3_title}</h3>
              <p className="text-gray-600">
                {settings.feature_3_description}
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Partner Shops Section */}
      <section id="partners" className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Nos partenaires de confiance
            </h2>
            <p className="text-xl text-gray-600">
              Découvrez une sélection de boutiques et services d'exception
            </p>
          </div>

          {loading ? (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="bg-white rounded-lg shadow-md p-6 animate-pulse">
                  <div className="bg-gray-300 h-48 rounded-lg mb-4"></div>
                  <div className="bg-gray-300 h-4 rounded mb-2"></div>
                  <div className="bg-gray-300 h-3 rounded mb-4"></div>
                  <div className="bg-gray-300 h-8 rounded"></div>
                </div>
              ))}
            </div>
          ) : (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {partnerShops.map((shop) => (
                <div key={shop.id} className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                  <img 
                    src={shop.image_url} 
                    alt={shop.name}
                    className="w-full h-48 object-cover"
                  />
                  <div className="p-6">
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="text-xl font-semibold text-gray-900">{shop.name}</h3>
                      <span className="bg-green-100 text-green-800 text-sm font-medium px-2 py-1 rounded">
                        -{shop.discount_percentage}%
                      </span>
                    </div>
                    <p className="text-gray-600 mb-4 line-clamp-2">{shop.description}</p>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-500 bg-gray-100 px-2 py-1 rounded">
                        {shop.category}
                      </span>
                      <a
                        href={shop.website_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-blue-600 hover:text-blue-700 font-medium inline-flex items-center"
                      >
                        Visiter
                        <Icons.ArrowRight className="ml-1 h-4 w-4" />
                      </a>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}

          <div className="text-center mt-12">
            <Link
              to="/partners"
              className="text-white px-8 py-3 rounded-lg font-semibold transition-colors inline-flex items-center"
              style={{ backgroundColor: settings.primary_color }}
            >
              Voir tous nos partenaires
              <Icons.ArrowRight className="ml-2 h-5 w-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 text-white" style={{ backgroundColor: settings.primary_color }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="flex items-center justify-center mb-4">
                <Icons.Users className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">{settings.stats_members}</div>
              <div className="text-xl">Membres actifs</div>
            </div>

            <div>
              <div className="flex items-center justify-center mb-4">
                <Icons.ShoppingBag className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">{settings.stats_partners}</div>
              <div className="text-xl">Partenaires</div>
            </div>

            <div>
              <div className="flex items-center justify-center mb-4">
                <Icons.Star className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">{settings.stats_satisfaction}</div>
              <div className="text-xl">Satisfaction client</div>
            </div>
          </div>
        </div>
      </section>

      {/* Contact Section */}
      <section id="contact" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              {settings.contact_title}
            </h2>
            <p className="text-xl text-gray-600">
              {settings.contact_description}
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.primary_color}20` }}>
                <Icons.MapPin className="h-8 w-8" style={{ color: settings.primary_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">Adresse</h3>
              <p className="text-gray-600" dangerouslySetInnerHTML={{ __html: (settings.contact_address || '').replace(/\n/g, '<br />') }} />
            </div>

            <div className="text-center">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.secondary_color}20` }}>
                <Icons.Phone className="h-8 w-8" style={{ color: settings.secondary_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">Téléphone</h3>
              <p className="text-gray-600">
                {settings.contact_phone}<br />
                {settings.contact_hours}
              </p>
            </div>

            <div className="text-center">
              <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${settings.accent_color}20` }}>
                <Icons.Mail className="h-8 w-8" style={{ color: settings.accent_color }} />
              </div>
              <h3 className="text-xl font-semibold mb-2">Email</h3>
              <p className="text-gray-600">
                {settings.contact_email}<br />
                {settings.contact_support_email}
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center mb-4">
                {settings.logo_url ? (
                  <img src={settings.logo_url} alt={settings.app_name} className="h-8" />
                ) : (
                  <span className="text-xl font-bold">{settings.app_name}</span>
                )}
              </div>
              <p className="text-gray-400">
                {settings.footer_description}
              </p>
            </div>

            <div>
              <h4 className="text-lg font-semibold mb-4">Liens rapides</h4>
              <ul className="space-y-2">
                <li><a href="#about" className="text-gray-400 hover:text-white transition-colors">À propos</a></li>
                <li><Link to="/catalog" className="text-gray-400 hover:text-white transition-colors">Produits</Link></li>
                <li><Link to="/partners" className="text-gray-400 hover:text-white transition-colors">Partenaires</Link></li>
                <li><Link to="/product-request" className="text-gray-400 hover:text-white transition-colors">Demander un produit</Link></li>
                <li><a href="#contact" className="text-gray-400 hover:text-white transition-colors">Contact</a></li>
              </ul>
            </div>

            <div>
              <h4 className="text-lg font-semibold mb-4">Compte</h4>
              <ul className="space-y-2">
                <li><Link to="/login" className="text-gray-400 hover:text-white transition-colors">Connexion</Link></li>
                <li><Link to="/generate-code" className="text-gray-400 hover:text-white transition-colors">Générer mon code</Link></li>
                <li><Link to="/dashboard" className="text-gray-400 hover:text-white transition-colors">Mon profil</Link></li>
                <li><Link to="/dashboard" className="text-gray-400 hover:text-white transition-colors">Mes commandes</Link></li>
              </ul>
            </div>

            <div>
              <h4 className="text-lg font-semibold mb-4">Suivez-nous</h4>
              <div className="flex space-x-4">
                {settings.social_facebook && (
                  <a href={settings.social_facebook} target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-white transition-colors">
                    <Icons.Globe className="h-6 w-6" />
                  </a>
                )}
                {settings.social_twitter && (
                  <a href={settings.social_twitter} target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-white transition-colors">
                    <Icons.Globe className="h-6 w-6" />
                  </a>
                )}
                {settings.social_instagram && (
                  <a href={settings.social_instagram} target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-white transition-colors">
                    <Icons.Globe className="h-6 w-6" />
                  </a>
                )}
                {settings.social_linkedin && (
                  <a href={settings.social_linkedin} target="_blank" rel="noopener noreferrer" className="text-gray-400 hover:text-white transition-colors">
                    <Icons.Globe className="h-6 w-6" />
                  </a>
                )}
              </div>
            </div>
          </div>

          <div className="border-t border-gray-800 mt-8 pt-8 text-center">
            <p className="text-gray-400">
              {settings.footer_copyright}
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
