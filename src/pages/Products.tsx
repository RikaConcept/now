import { STRIPE_PRODUCTS } from '../stripe-config';
import StripeCheckout from '../components/StripeCheckout';
import { Package } from 'lucide-react';

export default function Products() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-6xl mx-auto px-4">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Nos Produits
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Découvrez notre sélection de produits exclusifs disponibles pour nos membres.
          </p>
        </div>

        {STRIPE_PRODUCTS.length > 0 ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {STRIPE_PRODUCTS.map((product) => (
              <div key={product.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
                <div className="p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <Package className="w-8 h-8 text-blue-600" />
                    <h3 className="text-xl font-bold text-gray-900">{product.name}</h3>
                  </div>
                  <p className="text-gray-600 mb-4">{product.description}</p>
                  <div className="text-2xl font-bold text-blue-600 mb-6">
                    {product.currency === 'usd' ? '$' : '€'}{product.price.toFixed(2)}
                  </div>
                  <StripeCheckout product={product} />
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <Package className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              Aucun produit disponible
            </h3>
            <p className="text-gray-600">
              Nos produits seront bientôt disponibles. Revenez plus tard !
            </p>
          </div>
        )}
      </div>
    </div>
  );
}