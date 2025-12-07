import { useState, useEffect, useRef } from 'react';
import { api } from '../lib/api';
import { useAuth } from '../contexts/AuthContext';
import { Package, Loader2, CheckCircle, Info, Image as ImageIcon, X } from 'lucide-react';

export default function ProductRequest() {
  const { user } = useAuth();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isMember, setIsMember] = useState(false);
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [productName, setProductName] = useState('');
  const [bestPriceFound, setBestPriceFound] = useState('');
  const [priceSource, setPriceSource] = useState('');
  const [userBudget, setUserBudget] = useState('');
  const [marginDonation, setMarginDonation] = useState('');
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [imageError, setImageError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [requestId, setRequestId] = useState('');

  useEffect(() => {
    if (user) {
      checkMemberStatus();
      setEmail(user.email || '');
    }
  }, [user]);

  const checkMemberStatus = async () => {
    if (!user) return;

    try {
      const response = await api.getMember();
      if (response.success && response.data?.status === 'active') {
        setIsMember(true);
      }
    } catch (error) {
      // Member doesn't exist or error
      setIsMember(false);
    }
  };

  const handleImageSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setImageError(null);

    if (!file.type.startsWith('image/')) {
      setImageError('Veuillez sélectionner une image');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      setImageError('L\'image doit faire moins de 5 MB');
      return;
    }

    setImageFile(file);
    const reader = new FileReader();
    reader.onloadend = () => {
      setImagePreview(reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  const removeImage = () => {
    setImageFile(null);
    setImagePreview(null);
    setImageError(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const uploadImage = async (productRequestId: string): Promise<string | null> => {
    if (!imageFile) return null;

    try {
      const response = await api.uploadFile(imageFile);
      if (response.success && response.data?.url) {
        return response.data.url;
      }
    } catch (error) {
      console.error('Upload error:', error);
    }
    
    return null;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { data, error } = await supabase
        .from('product_requests')
        .insert({
          user_id: user?.id || null,
          email,
          phone,
          product_name: productName,
          best_price_found: parseFloat(bestPriceFound),
          price_source: priceSource,
          user_budget: parseFloat(userBudget),
          is_member: isMember,
          margin_donation: isMember && marginDonation ? parseFloat(marginDonation) : null,
          status: 'pending'
        })
        .select()
        .single();

      if (error) throw error;

      let imageUrl = null;
      if (imageFile) {
        imageUrl = await uploadImage(data.id);
        if (imageUrl) {
          await supabase
            .from('product_requests')
            .update({ image_url: imageUrl })
            .eq('id', data.id);
        }
      }

      await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-notification`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email,
          phone,
          type: 'product_request_confirmed',
          data: {
            productName,
            requestId: data.id
          }
        })
      });

      const { data: adminUsers } = await supabase
        .from('admin_users')
        .select('user_id');

      if (adminUsers && adminUsers.length > 0) {
        for (const admin of adminUsers) {
          const { data: adminData } = await supabase.auth.admin.getUserById(admin.user_id);
          if (adminData?.user?.email) {
            await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-notification`, {
              method: 'POST',
              headers: {
                'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                email: adminData.user.email,
                type: 'admin_product_request',
                data: {
                  productName,
                  requestId: data.id,
                  userEmail: email,
                  userPhone: phone,
                  bestPriceFound: parseFloat(bestPriceFound),
                  userBudget: parseFloat(userBudget),
                  priceSource,
                  isMember
                }
              })
            });
          }
        }
      }

      setRequestId(data.id);
      setSubmitted(true);
    } catch (error) {
      console.error('Erreur:', error);
      alert('Erreur lors de la soumission. Veuillez réessayer.');
    } finally {
      setLoading(false);
    }
  };

  if (submitted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
          <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Demande enregistrée !</h2>
          <p className="text-gray-600 mb-4">
            Votre demande pour <strong>{productName}</strong> a été enregistrée avec succès.
          </p>
          <div className="bg-gray-50 rounded-lg p-4 mb-6">
            <p className="text-sm text-gray-600">Numéro de référence</p>
            <p className="text-lg font-mono text-gray-900">{requestId.slice(0, 8).toUpperCase()}</p>
          </div>
          <p className="text-sm text-gray-600 mb-6">
            Vous recevrez une notification dès que nous aurons trouvé le meilleur prix pour vous.
          </p>
          <button
            onClick={() => window.location.href = '/'}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
          >
            Retour à l'accueil
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-100 py-12 px-4">
      <div className="max-w-2xl mx-auto">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          <div className="flex items-center gap-3 mb-6">
            <Package className="w-8 h-8 text-purple-600" />
            <h1 className="text-3xl font-bold text-gray-900">
              Demande de produit
            </h1>
          </div>

          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex gap-3">
            <Info className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div className="text-sm text-blue-800">
              {isMember ? (
                <>
                  <p className="font-medium mb-1">En tant que membre actif :</p>
                  <p>Si nous trouvons le produit à un prix inférieur, vous pouvez faire un don du montant de votre choix (optionnel).</p>
                </>
              ) : (
                <>
                  <p className="font-medium mb-1">Pour les non-membres :</p>
                  <p>Si nous trouvons le produit à un prix inférieur, 50% de la marge réalisée sera reversée à la plateforme.</p>
                </>
              )}
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email <span className="text-red-500">*</span>
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Téléphone
                </label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="+33 6 12 34 56 78"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Nom du produit <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={productName}
                onChange={(e) => setProductName(e.target.value)}
                placeholder="Ex: iPhone 15 Pro 256GB"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                required
              />
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Meilleur prix trouvé (€) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={bestPriceFound}
                  onChange={(e) => setBestPriceFound(e.target.value)}
                  placeholder="999.99"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Votre budget (€) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={userBudget}
                  onChange={(e) => setUserBudget(e.target.value)}
                  placeholder="1000.00"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Lien ou lieu de vente <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={priceSource}
                onChange={(e) => setPriceSource(e.target.value)}
                placeholder="https://example.com/product ou Magasin X, Paris"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                required
              />
              <p className="text-xs text-gray-500 mt-1">
                Indiquez le lien du site ou l'adresse du magasin où vous avez trouvé ce prix
              </p>
            </div>

            {isMember && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Don optionnel (€)
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={marginDonation}
                  onChange={(e) => setMarginDonation(e.target.value)}
                  placeholder="10.00"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                />
                <p className="text-xs text-gray-500 mt-1">
                  En tant que membre, vous pouvez faire un don du montant de votre choix si nous trouvons un meilleur prix
                </p>
              </div>
            )}

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Image du produit
              </label>
              {imageError && (
                <div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded-lg text-sm mb-2">
                  {imageError}
                </div>
              )}
              {imagePreview ? (
                <div className="relative">
                  <img
                    src={imagePreview}
                    alt="Aperçu du produit"
                    className="w-full h-48 object-cover rounded-lg border border-gray-300"
                  />
                  <button
                    type="button"
                    onClick={removeImage}
                    className="absolute top-2 right-2 bg-red-500 text-white p-1 rounded-full hover:bg-red-600 transition-colors"
                  >
                    <X className="w-5 h-5" />
                  </button>
                </div>
              ) : (
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  className="w-full border-2 border-dashed border-purple-300 rounded-lg p-6 text-center hover:border-purple-500 hover:bg-purple-50 transition-colors cursor-pointer"
                >
                  <ImageIcon className="w-8 h-8 text-purple-400 mx-auto mb-2" />
                  <p className="text-sm font-medium text-gray-700">Cliquez pour ajouter une image</p>
                  <p className="text-xs text-gray-500 mt-1">ou glissez une image ici</p>
                  <p className="text-xs text-gray-500 mt-1">Max 5 MB</p>
                </button>
              )}
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleImageSelect}
                className="hidden"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-purple-600 text-white py-3 rounded-lg font-medium hover:bg-purple-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <Loader2 className="w-5 h-5 animate-spin" />
                  Envoi en cours...
                </>
              ) : (
                'Envoyer ma demande'
              )}
            </button>
          </form>
        </div>

        {!isMember && (
          <div className="mt-6 bg-white rounded-lg shadow p-6 text-center">
            <h3 className="font-medium text-gray-900 mb-2">
              Vous n'êtes pas encore NOW!Lovers ?
            </h3>
            <p className="text-sm text-gray-600 mb-4">
              Rejoignez NOW! et profitez de demandes sans commission !
            </p>
            <button
              onClick={() => window.location.href = '/generate-code'}
              className="text-purple-600 hover:text-purple-700 font-medium"
            >
              Générer mon code NOW!Lovers
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
