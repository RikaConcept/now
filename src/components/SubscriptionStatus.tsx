import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { Crown, AlertCircle } from 'lucide-react';

export default function SubscriptionStatus() {
  const { user } = useAuth();
  const [subscription, setSubscription] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadSubscription();
    }
  }, [user]);

  const loadSubscription = async () => {
    try {
      const { data } = await supabase
        .from('stripe_user_subscriptions')
        .select('*')
        .single();

      if (data) {
        setSubscription(data);
      }
    } catch (error) {
      console.error('Erreur lors du chargement de l\'abonnement:', error);
    } finally {
      setLoading(false);
    }
  };

  if (!user || loading) {
    return null;
  }

  if (!subscription || !subscription.subscription_id) {
    return (
      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-6">
        <div className="flex items-center gap-2">
          <AlertCircle className="w-5 h-5 text-yellow-600" />
          <span className="text-yellow-800 font-medium">Aucun abonnement actif</span>
        </div>
      </div>
    );
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active':
        return 'bg-green-50 border-green-200 text-green-800';
      case 'trialing':
        return 'bg-blue-50 border-blue-200 text-blue-800';
      case 'past_due':
        return 'bg-orange-50 border-orange-200 text-orange-800';
      case 'canceled':
        return 'bg-red-50 border-red-200 text-red-800';
      default:
        return 'bg-gray-50 border-gray-200 text-gray-800';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'active':
        return 'Actif';
      case 'trialing':
        return 'Période d\'essai';
      case 'past_due':
        return 'Paiement en retard';
      case 'canceled':
        return 'Annulé';
      default:
        return status;
    }
  };

  return (
    <div className={`border rounded-lg p-4 mb-6 ${getStatusColor(subscription.subscription_status)}`}>
      <div className="flex items-center gap-2 mb-2">
        <Crown className="w-5 h-5" />
        <span className="font-medium">Abonnement actuel</span>
      </div>
      <div className="text-sm space-y-1">
        <div>Statut: {getStatusText(subscription.subscription_status)}</div>
        {subscription.current_period_end && (
          <div>
            Renouvellement: {new Date(subscription.current_period_end * 1000).toLocaleDateString('fr-FR')}
          </div>
        )}
        {subscription.payment_method_brand && subscription.payment_method_last4 && (
          <div>
            Paiement: {subscription.payment_method_brand} •••• {subscription.payment_method_last4}
          </div>
        )}
      </div>
    </div>
  );
}