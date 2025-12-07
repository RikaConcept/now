import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { useAuth } from '../contexts/AuthContext';
import { ShoppingCart, CreditCard, CheckCircle, ExternalLink } from 'lucide-react';

interface Member {
  code: string;
  status: string;
}

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  image_url: string;
  category: string;
  stock: number;
  purchase_link: string | null;
  is_active: boolean;
}

export default function Shop() {
  const { user } = useAuth();
  const [member, setMember] = useState<Member | null>(null);
  const [products, setProducts] = useState<Product[]>([]);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const [amount, setAmount] = useState(50);
  const [paymentMethod, setPaymentMethod] = useState('card');
  const [loading, setLoading] = useState(false);
  const [orderComplete, setOrderComplete] = useState(false);

  useEffect(() => {
    loadProducts();
    if (user) {
      loadMember();
    }
  }, [user]);

  const loadProducts = async () => {
    try {
      const response = await api.getProducts();
      if (response.success && response.data) {
        setProducts(response.data);
        if (response.data.length > 0) {
          setSelectedProduct(response.data[0]);
          setAmount(response.data[0].price);
        }
      }
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

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
    if (!user || !member) return;

    setLoading(true);

    try {
      const response = await api.createOrder(amount, paymentMethod);
      
      if (response.success) {
        // Update order status to paid (for simple payments)
        // In real scenario, this would be done after actual payment
        await api.updateOrderStatus(response.data.order_id, 'paid');
        setOrderComplete(true);
      } else {
        throw new Error('Order creation failed');
      }
    } catch (error) {
      console.error('Payment error:', error);
      alert('Erreur lors du paiement. Veuillez réessayer.');
    } finally {
      setLoading(false);
    }
  };

  if (orderComplete) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
          <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Paiement confirmé !</h2>
          <p className="text-gray-600 mb-6">
            {member?.status === 'pending'
              ? 'Félicitations ! Votre statut de NOW!Lovers est maintenant actif.'
              : 'Merci pour votre achat !'}
          </p>
          <button
            onClick={() => window.location.href = '/dashboard'}
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
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Commander un Produit
          </h1>
          <p className="text-gray-600 mb-4">
            Sélectionnez un produit et procédez au paiement
          </p>
          {member?.status === 'pending' && (
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 max-w-2xl mx-auto">
              <p className="text-blue-800">
                <strong>Activez votre code :</strong> Effectuez votre premier achat pour activer votre statut de membre et profiter de tous vos avantages !
              </p>
            </div>
          )}
        </div>

        <div className="mb-6 text-center">
          <button
            onClick={() => window.location.href = '/catalog'}
            className="text-blue-600 hover:text-blue-700 font-medium flex items-center gap-2 mx-auto"
          >
            ← Voir tous les produits du catalogue
          </button>
        </div>

        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          <div className="bg-white rounded-xl shadow-lg p-6">
            <div className="flex items-center gap-3 mb-6">
              <ShoppingCart className="w-8 h-8 text-blue-600" />
              <h2 className="text-2xl font-bold text-gray-900">Sélectionner un produit</h2>
            </div>

            <div className="space-y-4">
              {products.map((product) => (
                <div
                  key={product.id}
                  onClick={() => {
                    setSelectedProduct(product);
                    setAmount(product.price);
                  }}
                  className={`border-2 rounded-lg p-4 transition-all cursor-pointer ${
                    selectedProduct?.id === product.id
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200 hover:border-blue-300'
                  }`}
                >
                  <div className="flex gap-4">
                    <img
                      src={product.image_url}
                      alt={product.name}
                      className="w-20 h-20 object-cover rounded-lg"
                    />
                    <div className="flex-1">
                      <h3 className="font-medium text-gray-900">{product.name}</h3>
                      <p className="text-sm text-gray-600 line-clamp-2">{product.description}</p>
                      <div className="flex items-center justify-between mt-2">
                        <p className="text-xl font-bold text-blue-600">{product.price} €</p>
                        {product.purchase_link && (
                          <a
                            href={product.purchase_link}
                            target="_blank"
                            rel="noopener noreferrer"
                            onClick={(e) => e.stopPropagation()}
                            className="text-sm text-blue-600 hover:underline flex items-center gap-1"
                          >
                            Lien externe <ExternalLink className="w-3 h-3" />
                          </a>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              ))}

              {products.length === 0 && (
                <div className="text-center py-8 text-gray-500">
                  Aucun produit disponible pour le moment
                </div>
              )}
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-lg p-6">
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
                      {member.status === 'active' ? 'Actif' : "En attente d'activation"}
                    </span>
                  </p>
                </div>

                {selectedProduct && (
                  <div className="bg-gray-50 rounded-lg p-4 mb-4">
                    <p className="text-sm text-gray-600 mb-2">Produit sélectionné</p>
                    <div className="flex gap-3">
                      <img
                        src={selectedProduct.image_url}
                        alt={selectedProduct.name}
                        className="w-16 h-16 object-cover rounded"
                      />
                      <div>
                        <p className="font-medium text-gray-900">{selectedProduct.name}</p>
                        <p className="text-lg font-bold text-blue-600">{selectedProduct.price} €</p>
                      </div>
                    </div>
                  </div>
                )}

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Méthode de paiement
                  </label>
                  <select
                    value={paymentMethod}
                    onChange={(e) => setPaymentMethod(e.target.value)}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="card">Carte bancaire</option>
                    <option value="paypal">PayPal</option>
                    <option value="transfer">Virement bancaire</option>
                  </select>
                </div>

                <button
                  onClick={handlePayment}
                  disabled={loading}
                  className="w-full bg-blue-600 text-white py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
                >
                  {loading ? 'Traitement...' : `Payer ${amount} €`}
                </button>

                <p className="text-xs text-gray-500 text-center">
                  Paiement sécurisé - Vos données sont protégées
                </p>
              </div>
            ) : (
              <div className="text-center py-8">
                <p className="text-gray-600 mb-4">
                  Vous devez générer un code membre pour effectuer un achat.
                </p>
                <button
                  onClick={() => window.location.href = '/'}
                  className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
                >
                  Générer mon code
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}