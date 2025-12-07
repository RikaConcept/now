import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { useAuth } from '../contexts/AuthContext';
import { useCurrency } from '../contexts/CurrencyContext';
import { useCartStore } from '../lib/cartStore';
import { convertPrice, formatPrice } from '../lib/currency';
import { ShoppingCart, CreditCard, CheckCircle, Trash2, Plus, Minus, ArrowLeft, Smartphone } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

interface Member {
  code: string;
  status: string;
}

export default function Cart() {
  const { user } = useAuth();
  const { currency } = useCurrency();
  const navigate = useNavigate();
  const { items, removeItem, updateQuantity, clearCart, getTotalPrice, getTotalItems } = useCartStore();
  const [member, setMember] = useState<Member | null>(null);
  const [paymentMethod, setPaymentMethod] = useState<'paypal' | 'paystack'>('paystack');
  const [loading, setLoading] = useState(false);
  const [orderComplete, setOrderComplete] = useState(false);

  useEffect(() => {
    if (user) {
      loadMember();
    }
  }, [user]);

  const loadMember = async () => {
    if (!user) return;

    try {
      const response = await api.getMember();
      if (response.success && response.data) {
        setMember({
          code: response.data.code,
          status: response.data.status
        });
      }
    } catch (error) {
      console.error('Error loading member:', error);
    }
  };

  const handlePayment = async () => {
    if (!user || !member || items.length === 0) return;

    setLoading(true);

    try {
      const totalAmount = getTotalPrice();

      // Create order first
      const orderResponse = await api.createOrder(totalAmount, paymentMethod);
      
      if (!orderResponse.success) {
        throw new Error('Order creation failed');
      }

      const orderId = orderResponse.data.order_id;
      const API_URL = import.meta.env.VITE_API_URL || 'https://arnowconcept.com/api';

      // Redirect to payment gateway
      if (paymentMethod === 'paypal') {
        // Call PayPal checkout endpoint
        const response = await fetch(`${API_URL}/checkout/paypal`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
          },
          body: JSON.stringify({
            order_id: orderId,
            amount: totalAmount.toFixed(2),
            currency: 'EUR'
          })
        });

        if (!response.ok) {
          throw new Error('PayPal checkout failed');
        }

        const data = await response.json();
        if (data.success && data.data?.approval_url) {
          window.location.href = data.data.approval_url;
        } else {
          throw new Error('No approval URL received');
        }
      } else {
        // Call Paystack checkout endpoint
        const response = await fetch(`${API_URL}/checkout/paystack`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
          },
          body: JSON.stringify({
            order_id: orderId,
            amount: totalAmount,
            email: user.email
          })
        });

        if (!response.ok) {
          throw new Error('Paystack checkout failed');
        }

        const data = await response.json();
        if (data.success && data.data?.authorization_url) {
          window.location.href = data.data.authorization_url;
        } else {
          throw new Error('No authorization URL received');
        }
      }
    } catch (error) {
      console.error('Payment error:', error);
      alert('Erreur lors du paiement. Veuillez réessayer.');
      setLoading(false);
    }
  };

  if (orderComplete) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
          <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Commande confirmée !</h2>
          <p className="text-gray-600 mb-6">
            {member?.status === 'pending'
              ? 'Félicitations ! Votre statut de membre NOW!Lovers est maintenant actif.'
              : 'Merci pour votre commande !'}
          </p>
          <button
            onClick={() => navigate('/dashboard')}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
          >
            Voir mon tableau de bord
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <button
          onClick={() => navigate('/catalog')}
          className="flex items-center gap-2 text-blue-600 hover:text-blue-700 font-medium mb-6"
        >
          <ArrowLeft className="w-4 h-4" />
          Retour au catalogue
        </button>

        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Mon Panier
          </h1>
          {member?.status === 'pending' && (
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 max-w-2xl mx-auto">
              <p className="text-blue-800">
                <strong>Activez votre code :</strong> Effectuez votre premier achat pour activer votre statut de membre et profiter de tous vos avantages !
              </p>
            </div>
          )}
        </div>

        {items.length === 0 ? (
          <div className="bg-white rounded-xl shadow-lg p-12 text-center max-w-2xl mx-auto">
            <ShoppingCart className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Votre panier est vide</h2>
            <p className="text-gray-600 mb-6">
              Ajoutez des produits depuis le catalogue pour commencer
            </p>
            <button
              onClick={() => navigate('/catalog')}
              className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
            >
              Voir le catalogue
            </button>
          </div>
        ) : (
          <div className="grid lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2">
              <div className="bg-white rounded-xl shadow-lg p-6">
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center gap-3">
                    <ShoppingCart className="w-8 h-8 text-blue-600" />
                    <h2 className="text-2xl font-bold text-gray-900">
                      Articles ({getTotalItems()})
                    </h2>
                  </div>
                  <button
                    onClick={clearCart}
                    className="text-red-600 hover:text-red-700 text-sm font-medium"
                  >
                    Vider le panier
                  </button>
                </div>

                <div className="space-y-4">
                  {items.map((item) => (
                    <div key={item.id} className="flex gap-4 p-4 border border-gray-200 rounded-lg">
                      <img
                        src={item.image_url}
                        alt={item.name}
                        className="w-24 h-24 object-cover rounded-lg"
                      />
                      <div className="flex-1">
                        <h3 className="font-bold text-gray-900 mb-2">{item.name}</h3>
                        <p className="text-lg font-bold text-blue-600 mb-3">
                          {formatPrice(convertPrice(item.price, 'EUR', currency), currency)}
                        </p>
                        <div className="flex items-center gap-3">
                          <button
                            onClick={() => updateQuantity(item.id, item.quantity - 1)}
                            className="p-1 rounded hover:bg-gray-100 transition-colors"
                          >
                            <Minus className="w-4 h-4 text-gray-600" />
                          </button>
                          <span className="w-8 text-center font-medium">{item.quantity}</span>
                          <button
                            onClick={() => updateQuantity(item.id, item.quantity + 1)}
                            className="p-1 rounded hover:bg-gray-100 transition-colors"
                          >
                            <Plus className="w-4 h-4 text-gray-600" />
                          </button>
                        </div>
                      </div>
                      <div className="flex flex-col items-end justify-between">
                        <button
                          onClick={() => removeItem(item.id)}
                          className="p-2 text-red-600 hover:bg-red-50 rounded transition-colors"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                        <p className="text-xl font-bold text-gray-900">
                          {formatPrice(convertPrice(item.price * item.quantity, 'EUR', currency), currency)}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            <div className="lg:col-span-1">
              <div className="bg-white rounded-xl shadow-lg p-6 sticky top-24">
                <div className="flex items-center gap-3 mb-6">
                  <CreditCard className="w-8 h-8 text-blue-600" />
                  <h2 className="text-2xl font-bold text-gray-900">Paiement</h2>
                </div>

                {member ? (
                  <div className="space-y-4">
                    <div className="bg-blue-50 rounded-lg p-4">
                      <p className="text-sm text-gray-600">Votre code membre</p>
                      <p className="text-xl font-bold text-blue-600">{member.code}</p>
                      <p className="text-sm text-gray-600 mt-1">
                        Statut: <span className={member.status === 'active' ? 'text-green-600' : 'text-orange-600'}>
                          {member.status === 'active' ? 'Actif' : 'En attente d\'activation'}
                        </span>
                      </p>
                    </div>

                    <div className="border-t border-gray-200 pt-4">
                      <div className="flex justify-between text-sm text-gray-600 mb-2">
                        <span>Sous-total</span>
                        <span>{formatPrice(convertPrice(getTotalPrice(), 'EUR', currency), currency)}</span>
                      </div>
                      <div className="flex justify-between text-lg font-bold text-gray-900 mb-6">
                        <span>Total</span>
                        <span>{formatPrice(convertPrice(getTotalPrice(), 'EUR', currency), currency)}</span>
                      </div>
                    </div>

                    <div className="space-y-4 mb-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-3">
                          Choisissez votre méthode de paiement
                        </label>
                        <div className="grid grid-cols-2 gap-3">
                          <button
                            type="button"
                            onClick={() => setPaymentMethod('paypal')}
                            className={`p-4 rounded-lg border-2 transition-all ${
                              paymentMethod === 'paypal'
                                ? 'border-blue-600 bg-blue-50'
                                : 'border-gray-200 hover:border-gray-300'
                            }`}
                          >
                            <div className="flex flex-col items-center gap-2">
                              <CreditCard className={`w-8 h-8 ${paymentMethod === 'paypal' ? 'text-blue-600' : 'text-gray-400'}`} />
                              <span className={`text-sm font-medium ${paymentMethod === 'paypal' ? 'text-blue-600' : 'text-gray-600'}`}>
                                Carte & PayPal
                              </span>
                              <span className="text-xs text-gray-500">Visa, PayPal</span>
                            </div>
                          </button>

                          <button
                            type="button"
                            onClick={() => setPaymentMethod('paystack')}
                            className={`p-4 rounded-lg border-2 transition-all ${
                              paymentMethod === 'paystack'
                                ? 'border-green-600 bg-green-50'
                                : 'border-gray-200 hover:border-gray-300'
                            }`}
                          >
                            <div className="flex flex-col items-center gap-2">
                              <Smartphone className={`w-8 h-8 ${paymentMethod === 'paystack' ? 'text-green-600' : 'text-gray-400'}`} />
                              <span className={`text-sm font-medium ${paymentMethod === 'paystack' ? 'text-green-600' : 'text-gray-600'}`}>
                                Mobile Money
                              </span>
                              <span className="text-xs text-gray-500">MTN, Orange, Moov, Wave</span>
                            </div>
                          </button>
                        </div>
                      </div>

                      <div className={`rounded-lg p-4 ${
                        paymentMethod === 'paypal'
                          ? 'bg-gradient-to-r from-blue-50 to-sky-50 border border-blue-200'
                          : 'bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200'
                      }`}>
                        <div className="flex items-center gap-3">
                          <div className="bg-white rounded-full p-2">
                            {paymentMethod === 'paypal' ? (
                              <CreditCard className="w-6 h-6 text-blue-600" />
                            ) : (
                              <Smartphone className="w-6 h-6 text-green-600" />
                            )}
                          </div>
                          <div>
                            <p className="font-semibold text-gray-900">
                              {paymentMethod === 'paypal' ? 'Paiement sécurisé par PayPal' : 'Paiement par Mobile Money'}
                            </p>
                            <p className="text-sm text-gray-600">
                              {paymentMethod === 'paypal'
                                ? 'Carte Visa, Mastercard ou compte PayPal'
                                : 'Tous les services Mobile Money acceptés'}
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <button
                      onClick={handlePayment}
                      disabled={loading || items.length === 0}
                      className={`w-full text-white py-4 rounded-lg font-semibold transition-all disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2 shadow-lg hover:shadow-xl ${
                        paymentMethod === 'paypal'
                          ? 'bg-blue-600 hover:bg-blue-700'
                          : 'bg-green-600 hover:bg-green-700'
                      }`}
                    >
                      {loading ? (
                        <>
                          <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                          Redirection en cours...
                        </>
                      ) : (
                        <>
                          {paymentMethod === 'paypal' ? (
                            <CreditCard className="w-5 h-5" />
                          ) : (
                            <Smartphone className="w-5 h-5" />
                          )}
                          {paymentMethod === 'paypal' ? 'Payer avec PayPal' : 'Payer avec Mobile Money'} - {formatPrice(convertPrice(getTotalPrice(), 'EUR', currency), currency)}
                        </>
                      )}
                    </button>

                    <div className="mt-4 flex items-center justify-center gap-2 text-xs text-gray-500">
                      <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clipRule="evenodd" />
                      </svg>
                      <span>Paiement 100% sécurisé et crypté</span>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-8">
                    <p className="text-gray-600 mb-4">
                      Vous devez générer un code membre pour effectuer un achat.
                    </p>
                    <button
                      onClick={() => navigate('/')}
                      className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
                    >
                      Générer mon code
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
