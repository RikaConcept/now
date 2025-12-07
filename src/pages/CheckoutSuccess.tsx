import { useEffect, useState } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { CheckCircle, ArrowLeft, Package } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useCartStore } from '../lib/cartStore';

export default function CheckoutSuccess() {
  const [searchParams] = useSearchParams();
  const { user } = useAuth();
  const { clearCart } = useCartStore();
  const [orderDetails, setOrderDetails] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  const sessionId = searchParams.get('session_id');

  useEffect(() => {
    clearCart();
    if (sessionId && user) {
      loadOrderDetails();
    } else {
      setLoading(false);
    }
  }, [sessionId, user]);

  const loadOrderDetails = async () => {
    try {
      const { data } = await supabase
        .from('stripe_orders')
        .select('*')
        .eq('checkout_session_id', sessionId)
        .maybeSingle();

      if (data) {
        setOrderDetails(data);
      }
    } catch (error) {
      console.error('Erreur lors du chargement des détails de commande:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatAmount = (amount: number, currency: string) => {
    const symbol = currency === 'usd' ? '$' : '€';
    return `${symbol}${(amount / 100).toFixed(2)}`;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement des détails de votre commande...</p>
        </div>
      </div>
    );
  }

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

          {orderDetails && (
            <div className="bg-gray-50 rounded-lg p-6 mb-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center justify-center gap-2">
                <Package className="w-5 h-5" />
                Détails de la commande
              </h2>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Numéro de commande:</span>
                  <span className="font-medium">#{orderDetails.id}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Montant total:</span>
                  <span className="font-medium">
                    {formatAmount(orderDetails.amount_total, orderDetails.currency)}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Statut du paiement:</span>
                  <span className="font-medium text-green-600">
                    {orderDetails.payment_status === 'paid' ? 'Payé' : orderDetails.payment_status}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Date:</span>
                  <span className="font-medium">
                    {new Date(orderDetails.created_at).toLocaleDateString('fr-FR')}
                  </span>
                </div>
              </div>
            </div>
          )}

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