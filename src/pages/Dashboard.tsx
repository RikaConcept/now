import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { useAuth } from '../contexts/AuthContext';
import { Store, Tag, Package, LogOut, User, MapPin, Share2, Copy, Check, CreditCard } from 'lucide-react';
import SubscriptionStatus from '../components/SubscriptionStatus';

interface Member {
  code: string;
  status: string;
  locality_id: string;
  created_at: string;
  activated_at: string | null;
  referral_code: string | null;
  total_spent: number;
}

interface Locality {
  name: string;
}

interface PartnerShop {
  id: string;
  name: string;
  category: string;
  description: string;
  discount_percentage: number;
  address: string;
}

interface ProductRequest {
  id: string;
  product_name: string;
  status: string;
  created_at: string;
  best_price_found: number;
}

interface Order {
  id: string;
  amount: number;
  status: string;
  payment_method: string;
  created_at: string;
  paid_at: string | null;
}

export default function Dashboard() {
  const { user, signOut } = useAuth();
  const [member, setMember] = useState<Member | null>(null);
  const [locality, setLocality] = useState<Locality | null>(null);
  const [partnerShops, setPartnerShops] = useState<PartnerShop[]>([]);
  const [productRequests, setProductRequests] = useState<ProductRequest[]>([]);
  const [orders, setOrders] = useState<Order[]>([]);
  const [referralStats, setReferralStats] = useState({ total: 0, active: 0 });
  const [copied, setCopied] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadDashboardData();
    }
  }, [user]);

  const loadDashboardData = async () => {
    if (!user) return;

    const { data: memberData } = await supabase
      .from('members')
      .select('*, localities(name)')
      .eq('id', user.id)
      .maybeSingle();

    if (memberData) {
      setMember(memberData);
      if (memberData.localities) {
        setLocality({ name: memberData.localities.name });
      }
    }

    const { data: shopsData } = await supabase
      .from('partner_shops')
      .select('*')
      .eq('is_active', true)
      .order('category');

    if (shopsData) {
      setPartnerShops(shopsData);
    }

    const { data: requestsData } = await supabase
      .from('product_requests')
      .select('id, product_name, status, created_at, best_price_found')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })
      .limit(5);

    if (requestsData) {
      setProductRequests(requestsData);
    }

    const { data: referralData } = await supabase
      .from('referrals')
      .select('id, status')
      .eq('referrer_id', user.id);

    if (referralData) {
      setReferralStats({
        total: referralData.length,
        active: referralData.filter(r => r.status === 'completed').length
      });
    }

    const { data: ordersData } = await supabase
      .from('orders')
      .select('*')
      .eq('member_id', user.id)
      .order('created_at', { ascending: false })
      .limit(10);

    if (ordersData) {
      setOrders(ordersData);
    }

    setLoading(false);
  };

  const copyReferralCode = () => {
    if (member?.referral_code) {
      const referralLink = `${window.location.origin}/?ref=${member.referral_code}`;
      navigator.clipboard.writeText(referralLink);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const handleSignOut = async () => {
    await signOut();
    window.location.href = '/';
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement...</p>
        </div>
      </div>
    );
  }

  if (!member) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-lg shadow-lg p-8 max-w-md w-full text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Aucun code membre</h2>
          <p className="text-gray-600 mb-6">Vous devez d'abord générer votre code NOW!Lovers.</p>
          <button
            onClick={() => window.location.href = '/generate-code'}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
          >
            Générer mon code
          </button>
        </div>
      </div>
    );
  }

  const groupedShops = partnerShops.reduce((acc, shop) => {
    if (!acc[shop.category]) {
      acc[shop.category] = [];
    }
    acc[shop.category].push(shop);
    return acc;
  }, {} as Record<string, PartnerShop[]>);

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
          <h1 className="text-2xl font-bold text-blue-600">NOW!</h1>
          <button
            onClick={handleSignOut}
            className="flex items-center gap-2 text-gray-600 hover:text-gray-900"
          >
            <LogOut className="w-5 h-5" />
            Déconnexion
          </button>
        </div>
      </nav>

      <div className="max-w-7xl mx-auto px-4 py-8">
        <SubscriptionStatus />
        
        <div className="bg-gradient-to-r from-blue-600 to-indigo-600 rounded-2xl shadow-xl p-8 mb-8 text-white">
          <div className="flex items-center gap-3 mb-4">
            <User className="w-12 h-12" />
            <div>
              <h2 className="text-3xl font-bold">Bienvenue {user?.email}</h2>
              <p className="text-blue-100">NOW!Lovers</p>
            </div>
          </div>

          <div className="grid md:grid-cols-4 gap-6 mt-6">
            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <p className="text-blue-100 text-sm mb-1">Votre code</p>
              <p className="text-2xl font-bold">{member.code}</p>
            </div>

            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <p className="text-blue-100 text-sm mb-1">Statut</p>
              <p className="text-2xl font-bold capitalize">
                {member.status === 'active' ? 'Actif' : 'En attente'}
              </p>
            </div>

            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <div className="flex items-center gap-2">
                <MapPin className="w-5 h-5" />
                <div>
                  <p className="text-blue-100 text-sm">Localité</p>
                  <p className="text-xl font-bold">{locality?.name}</p>
                </div>
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <p className="text-blue-100 text-sm mb-1">Dépenses totales</p>
              <p className="text-2xl font-bold">{member.total_spent?.toFixed(2) || 0} €</p>
            </div>
          </div>

          {member.status === 'pending' && (
            <div className="mt-6 bg-yellow-500/20 backdrop-blur border border-yellow-300 rounded-lg p-4">
              <p className="font-medium">Activez votre statut de membre !</p>
              <p className="text-sm text-blue-100 mt-1">
                Effectuez votre premier achat pour débloquer tous vos avantages.
              </p>
              <button
                onClick={() => window.location.href = '/shop'}
                className="mt-3 bg-white text-blue-600 px-4 py-2 rounded-lg font-medium hover:bg-blue-50 transition-colors"
              >
                Visiter la boutique
              </button>
            </div>
          )}
        </div>

        <div className="grid lg:grid-cols-4 gap-8 mb-8">
          <div className="bg-white rounded-xl shadow-lg p-6">
            <div className="flex items-center gap-3 mb-4">
              <Share2 className="w-6 h-6 text-blue-600" />
              <h3 className="text-xl font-bold text-gray-900">Parrainage</h3>
            </div>
            {member?.referral_code ? (
              <>
                <div className="bg-blue-50 rounded-lg p-4 mb-4">
                  <p className="text-xs text-gray-600 mb-2">Votre code de parrainage</p>
                  <p className="text-sm font-mono font-bold text-blue-600 mb-3 break-all">{member.referral_code}</p>
                  <button
                    onClick={copyReferralCode}
                    className={`w-full flex items-center justify-center gap-2 py-2 px-3 rounded-lg text-sm font-medium transition-colors ${
                      copied
                        ? 'bg-green-500 text-white'
                        : 'bg-blue-600 text-white hover:bg-blue-700'
                    }`}
                  >
                    {copied ? (
                      <>
                        <Check className="w-4 h-4" />
                        Copié !
                      </>
                    ) : (
                      <>
                        <Copy className="w-4 h-4" />
                        Copier le lien
                      </>
                    )}
                  </button>
                </div>
                <div className="space-y-2">
                  <div className="border border-gray-200 rounded p-3">
                    <p className="text-xs text-gray-600">Parrainages actifs</p>
                    <p className="text-2xl font-bold text-blue-600">{referralStats.active}/{referralStats.total}</p>
                  </div>
                </div>
              </>
            ) : (
              <div className="text-center py-8">
                <p className="text-sm text-gray-600">Vous recevrez un code de parrainage dès que votre compte sera activé.</p>
              </div>
            )}
          </div>

          <div className="lg:col-span-1 bg-white rounded-xl shadow-lg p-6">
            <div className="flex items-center gap-3 mb-4">
              <Tag className="w-6 h-6 text-green-600" />
              <h3 className="text-xl font-bold text-gray-900">Vos avantages</h3>
            </div>
            <ul className="space-y-3">
              <li className="flex items-start gap-2">
                <span className="text-green-600 font-bold">✓</span>
                <span className="text-gray-700">Réductions exclusives chez nos partenaires</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-green-600 font-bold">✓</span>
                <span className="text-gray-700">Demandes de produits sans commission</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-green-600 font-bold">✓</span>
                <span className="text-gray-700">Accès prioritaire aux nouvelles offres</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-green-600 font-bold">✓</span>
                <span className="text-gray-700">Support client dédié</span>
              </li>
            </ul>
          </div>

          <div className="lg:col-span-2 bg-white rounded-xl shadow-lg p-6" >
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <Package className="w-6 h-6 text-purple-600" />
                <h3 className="text-xl font-bold text-gray-900">Mes demandes de produits</h3>
              </div>
              <button
                onClick={() => window.location.href = '/product-request'}
                className="text-sm bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-colors"
              >
                Nouvelle demande
              </button>
            </div>

            {productRequests.length > 0 ? (
              <div className="space-y-3">
                {productRequests.map((request) => (
                  <div key={request.id} className="border border-gray-200 rounded-lg p-4 hover:border-purple-500 transition-colors">
                    <div className="flex justify-between items-start">
                      <div>
                        <h4 className="font-medium text-gray-900">{request.product_name}</h4>
                        <p className="text-sm text-gray-600">
                          Prix trouvé: {request.best_price_found} €
                        </p>
                      </div>
                      <span className={`text-xs px-2 py-1 rounded-full ${
                        request.status === 'completed' ? 'bg-green-100 text-green-800' :
                        request.status === 'processing' ? 'bg-blue-100 text-blue-800' :
                        'bg-gray-100 text-gray-800'
                      }`}>
                        {request.status === 'completed' ? 'Complété' :
                         request.status === 'processing' ? 'En cours' : 'En attente'}
                      </span>
                    </div>
                    <p className="text-xs text-gray-500 mt-2">
                      {new Date(request.created_at).toLocaleDateString('fr-FR')}
                    </p>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-500">
                <Package className="w-12 h-12 mx-auto mb-2 opacity-50" />
                <p>Aucune demande de produit pour le moment</p>
              </div>
            )}
          </div>
        </div>

        <div className="bg-white rounded-xl shadow-lg p-6 mb-8">
          <div className="flex items-center gap-3 mb-6">
            <CreditCard className="w-6 h-6 text-blue-600" />
            <h3 className="text-2xl font-bold text-gray-900">Historique des commandes</h3>
          </div>

          {orders.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-gray-200">
                    <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">Date</th>
                    <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">Montant</th>
                    <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">Méthode</th>
                    <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">Statut</th>
                  </tr>
                </thead>
                <tbody>
                  {orders.map((order) => (
                    <tr key={order.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="py-3 px-4 text-sm text-gray-900">
                        {new Date(order.created_at).toLocaleDateString('fr-FR', {
                          year: 'numeric',
                          month: 'long',
                          day: 'numeric',
                        })}
                      </td>
                      <td className="py-3 px-4 text-sm font-medium text-gray-900">
                        {order.amount.toFixed(2)} €
                      </td>
                      <td className="py-3 px-4 text-sm text-gray-600 capitalize">
                        {order.payment_method === 'card' ? 'Carte bancaire' : order.payment_method}
                      </td>
                      <td className="py-3 px-4">
                        <span className={`text-xs px-2 py-1 rounded-full ${
                          order.status === 'paid' ? 'bg-green-100 text-green-800' :
                          order.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-red-100 text-red-800'
                        }`}>
                          {order.status === 'paid' ? 'Payé' :
                           order.status === 'pending' ? 'En attente' : 'Annulé'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center py-8 text-gray-500">
              <CreditCard className="w-12 h-12 mx-auto mb-2 opacity-50" />
              <p>Aucune commande pour le moment</p>
              <button
                onClick={() => window.location.href = '/catalog'}
                className="mt-4 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors"
              >
                Voir le catalogue
              </button>
            </div>
          )}
        </div>

        <div className="bg-white rounded-xl shadow-lg p-6">
          <div className="flex items-center gap-3 mb-6">
            <Store className="w-6 h-6 text-blue-600" />
            <h3 className="text-2xl font-bold text-gray-900">Boutiques partenaires</h3>
          </div>

          {Object.entries(groupedShops).map(([category, shops]) => (
            <div key={category} className="mb-8">
              <h4 className="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">
                {category}
              </h4>
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                {shops.map((shop) => (
                  <div key={shop.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-500 hover:shadow-md transition-all">
                    <div className="flex justify-between items-start mb-2">
                      <h5 className="font-medium text-gray-900">{shop.name}</h5>
                      <span className="bg-green-100 text-green-800 text-xs font-bold px-2 py-1 rounded">
                        -{shop.discount_percentage}%
                      </span>
                    </div>
                    <p className="text-sm text-gray-600 mb-2">{shop.description}</p>
                    {shop.address && (
                      <p className="text-xs text-gray-500 flex items-start gap-1">
                        <MapPin className="w-3 h-3 mt-0.5 flex-shrink-0" />
                        {shop.address}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}