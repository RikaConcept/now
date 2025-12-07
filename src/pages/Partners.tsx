import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { Store, ArrowRight, Loader2 } from 'lucide-react';

interface PartnerShop {
  id: string;
  name: string;
  description: string;
  image_url: string;
  website_url: string;
  discount_percentage: number;
  category: string;
}

export default function Partners() {
  const [partnerShops, setPartnerShops] = useState<PartnerShop[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  useEffect(() => {
    loadPartnerShops();
  }, []);

  const loadPartnerShops = async () => {
    try {
      const response = await api.getPartnerShops();
      if (response.success && response.data) {
        setPartnerShops(response.data);
      }
    } catch (error) {
      console.error('Error loading partner shops:', error);
    }
    setLoading(false);
  };

  const categories = ['all', ...Array.from(new Set(partnerShops.map(shop => shop.category)))];

  const filteredShops = selectedCategory === 'all'
    ? partnerShops
    : partnerShops.filter(shop => shop.category === selectedCategory);

  const groupedShops = filteredShops.reduce((acc, shop) => {
    if (!acc[shop.category]) {
      acc[shop.category] = [];
    }
    acc[shop.category].push(shop);
    return acc;
  }, {} as Record<string, PartnerShop[]>);

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-7xl mx-auto px-4">
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mb-4">
            <Store className="w-8 h-8 text-blue-600" />
          </div>
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Nos Partenaires
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Découvrez tous nos partenaires de confiance et profitez de réductions exclusives
          </p>
        </div>

        <div className="mb-8 flex flex-wrap gap-2 justify-center">
          {categories.map((category) => (
            <button
              key={category}
              onClick={() => setSelectedCategory(category)}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                selectedCategory === category
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-gray-700 hover:bg-gray-100'
              }`}
            >
              {category === 'all' ? 'Tous' : category}
            </button>
          ))}
        </div>

        {loading ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 className="w-12 h-12 text-blue-600 animate-spin" />
          </div>
        ) : filteredShops.length === 0 ? (
          <div className="text-center py-20">
            <Store className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              Aucun partenaire trouvé
            </h3>
            <p className="text-gray-600">
              Aucun partenaire disponible dans cette catégorie.
            </p>
          </div>
        ) : (
          <div className="space-y-12">
            {Object.entries(groupedShops).map(([category, shops]) => (
              <div key={category}>
                <h2 className="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                  <div className="h-1 w-12 bg-blue-600 rounded mr-4"></div>
                  {category}
                  <span className="ml-3 text-sm font-normal text-gray-500">
                    ({shops.length} {shops.length === 1 ? 'partenaire' : 'partenaires'})
                  </span>
                </h2>

                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                  {shops.map((shop) => (
                    <div
                      key={shop.id}
                      className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow"
                    >
                      {shop.image_url && (
                        <img
                          src={shop.image_url}
                          alt={shop.name}
                          className="w-full h-48 object-cover"
                        />
                      )}
                      <div className="p-6">
                        <div className="flex items-center justify-between mb-2">
                          <h3 className="text-xl font-semibold text-gray-900">{shop.name}</h3>
                          <span className="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                            -{shop.discount_percentage}%
                          </span>
                        </div>
                        <p className="text-gray-600 mb-4 line-clamp-3">{shop.description}</p>
                        {shop.website_url && (
                          <a
                            href={shop.website_url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="inline-flex items-center text-blue-600 hover:text-blue-700 font-medium"
                          >
                            Visiter le site
                            <ArrowRight className="ml-2 h-4 w-4" />
                          </a>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}