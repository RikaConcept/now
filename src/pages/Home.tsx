import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import { Heart, Users, ShoppingBag, Star, ArrowRight, MapPin, Phone, Mail, Globe, Zap, Shield, Award, LogOut, User } from 'lucide-react';

interface PartnerShop {
  id: string;
  name: string;
  description: string;
  image_url: string;
  website_url: string;
  discount_percentage: number;
  category: string;
}

export default function Home() {
  const { user, signOut } = useAuth();
  const [partnerShops, setPartnerShops] = useState<PartnerShop[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadPartnerShops();
  }, []);

  const handleSignOut = async () => {
    await signOut();
  };

  const loadPartnerShops = async () => {
    const { data } = await supabase
      .from('partner_shops')
      .select('*')
      .limit(6);
    
    if (data) {
      setPartnerShops(data);
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-600 to-purple-700 text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              Bienvenue chez <span className="text-yellow-300">NOW!</span>
            </h1>
            <p className="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">
              Découvrez des produits exceptionnels et bénéficiez d'avantages exclusifs 
              chez nos partenaires de confiance
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/generate-code"
                className="bg-yellow-400 text-gray-900 px-8 py-3 rounded-lg font-semibold hover:bg-yellow-300 transition-colors inline-flex items-center justify-center"
              >
                Rejoindre la communauté NOW!
                <ArrowRight className="ml-2 h-5 w-5" />
              </Link>
              <a 
                href="#partners" 
                className="border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white hover:text-gray-900 transition-colors"
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
              Pourquoi choisir NOW!Concept ?
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Une plateforme unique qui vous connecte aux meilleurs produits et services
            </p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Zap className="h-8 w-8 text-blue-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Accès instantané</h3>
              <p className="text-gray-600">
                Découvrez immédiatement tous nos produits et services partenaires
              </p>
            </div>
            
            <div className="text-center p-6">
              <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Shield className="h-8 w-8 text-green-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Qualité garantie</h3>
              <p className="text-gray-600">
                Tous nos partenaires sont soigneusement sélectionnés pour leur excellence
              </p>
            </div>
            
            <div className="text-center p-6">
              <div className="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Award className="h-8 w-8 text-purple-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Avantages exclusifs</h3>
              <p className="text-gray-600">
                Bénéficiez de réductions et d'offres spéciales réservées aux membres
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
                        <ArrowRight className="ml-1 h-4 w-4" />
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
              className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors inline-flex items-center"
            >
              Voir tous nos partenaires
              <ArrowRight className="ml-2 h-5 w-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 bg-blue-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="flex items-center justify-center mb-4">
                <Users className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">10,000+</div>
              <div className="text-xl">Membres actifs</div>
            </div>
            
            <div>
              <div className="flex items-center justify-center mb-4">
                <ShoppingBag className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">500+</div>
              <div className="text-xl">Partenaires</div>
            </div>
            
            <div>
              <div className="flex items-center justify-center mb-4">
                <Star className="h-12 w-12" />
              </div>
              <div className="text-4xl font-bold mb-2">4.9/5</div>
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
              Contactez-nous
            </h2>
            <p className="text-xl text-gray-600">
              Une question ? Notre équipe est là pour vous aider
            </p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <MapPin className="h-8 w-8 text-blue-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Adresse</h3>
              <p className="text-gray-600">
                123 Rue de l'Innovation<br />
                75001 Paris, France
              </p>
            </div>
            
            <div className="text-center">
              <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Phone className="h-8 w-8 text-green-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Téléphone</h3>
              <p className="text-gray-600">
                +33 1 23 45 67 89<br />
                Lun-Ven 9h-18h
              </p>
            </div>
            
            <div className="text-center">
              <div className="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Mail className="h-8 w-8 text-purple-600" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Email</h3>
              <p className="text-gray-600">
                contact@nowlovers.com<br />
                support@nowlovers.com
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
                <span className="ml-2 text-xl font-bold">NOW!</span>
              </div>
              <p className="text-gray-400">
                La plateforme qui connecte les amoureux des beaux produits aux meilleures boutiques.
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
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Mon profil</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Mes commandes</a></li>
              </ul>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold mb-4">Suivez-nous</h4>
              <div className="flex space-x-4">
                <a href="#" className="text-gray-400 hover:text-white transition-colors">
                  <Globe className="h-6 w-6" />
                </a>
                <a href="#" className="text-gray-400 hover:text-white transition-colors">
                  <Mail className="h-6 w-6" />
                </a>
              </div>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-8 pt-8 text-center">
            <p className="text-gray-400">
              © 2024 NOW!. Tous droits réservés.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}