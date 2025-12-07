import { useEffect, useState } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { CheckCircle, ArrowRight, Package } from 'lucide-react';

export default function Success() {
  const [searchParams] = useSearchParams();
  const sessionId = searchParams.get('session_id');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simulate loading time for better UX
    const timer = setTimeout(() => {
      setLoading(false);
    }, 1500);

    return () => clearTimeout(timer);
  }, []);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-green-600 mx-auto mb-4"></div>
          <p className="text-green-700 font-medium">Traitement de votre commande...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white rounded-xl shadow-lg p-8 text-center">
        <div className="mb-6">
          <CheckCircle className="w-20 h-20 text-green-500 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Paiement réussi!</h1>
          <p className="text-gray-600">
            Votre commande a été traitée avec succès.
          </p>
        </div>

        {sessionId && (
          <div className="bg-gray-50 rounded-lg p-4 mb-6">
            <p className="text-sm text-gray-600 mb-1">ID de session:</p>
            <p className="text-xs font-mono text-gray-800 break-all">{sessionId}</p>
          </div>
        )}

        <div className="space-y-4">
          <div className="flex items-center justify-center text-green-600 mb-4">
            <Package className="w-5 h-5 mr-2" />
            <span className="font-medium">Commande confirmée</span>
          </div>

          <p className="text-gray-600 text-sm mb-6">
            Vous recevrez un email de confirmation sous peu avec tous les détails de votre commande.
          </p>

          <div className="space-y-3">
            <Link
              to="/products"
              className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-blue-700 transition-colors inline-flex items-center justify-center"
            >
              Voir d'autres produits
              <ArrowRight className="w-4 h-4 ml-2" />
            </Link>
            
            <Link
              to="/"
              className="w-full bg-gray-100 text-gray-700 py-3 px-4 rounded-lg font-medium hover:bg-gray-200 transition-colors inline-flex items-center justify-center"
            >
              Retour à l'accueil
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}