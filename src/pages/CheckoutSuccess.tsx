import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { CheckCircle, ArrowLeft, Package } from 'lucide-react';
import { useCartStore } from '../lib/cartStore';

export default function CheckoutSuccess() {
  const { clearCart } = useCartStore();

  useEffect(() => {
    clearCart();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-2xl mx-auto px-4">
        <div className="bg-white rounded-lg shadow-lg p-8 text-center">
          <div className="mb-6">
            <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
            <h1 className="text-3xl font-bold text-gray-900 mb-2">
              Paiement réussi !
            </h1>
            <p className="text-gray-600">
              Merci pour votre achat. Votre commande a été traitée avec succès.
            </p>
          </div>

          <div className="bg-gray-50 rounded-lg p-6 mb-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center justify-center gap-2">
              <Package className="w-5 h-5" />
              Votre commande est confirmée
            </h2>
            <p className="text-sm text-gray-600">
              Vous recevrez un email de confirmation dans quelques instants.
            </p>
          </div>

          <div className="space-y-4">
            <p className="text-gray-600">
              Un email de confirmation a été envoyé à votre adresse email.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/dashboard"
                className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
              >
                Voir mon tableau de bord
              </Link>
              <Link
                to="/"
                className="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg font-medium hover:bg-gray-200 transition-colors flex items-center justify-center gap-2"
              >
                <ArrowLeft className="w-4 h-4" />
                Retour à l'accueil
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}