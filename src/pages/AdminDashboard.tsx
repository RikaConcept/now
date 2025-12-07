import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { useAuth } from '../contexts/AuthContext';
import { LayoutDashboard, Package, Users, TrendingUp, LogOut, Settings, Store, Edit2, Trash2, ShoppingBag, Globe } from 'lucide-react';
import ImageUpload from '../components/ImageUpload';

interface AdminTab {
  id: string;
  label: string;
  icon: React.ReactNode;
}

export default function AdminDashboard() {
  const { user, signOut } = useAuth();
  const [isAdmin, setIsAdmin] = useState(false);
  const [activeTab, setActiveTab] = useState('overview');
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalMembers: 0,
    totalOrders: 0,
    totalProductRequests: 0,
    totalRevenue: 0
  });

  useEffect(() => {
    if (user) {
      checkAdminAccess();
    }
  }, [user]);

  const checkAdminAccess = async () => {
    if (!user) return;

    try {
      const response = await api.getCurrentUser();
      if (response.success && response.data?.user?.is_admin) {
        setIsAdmin(true);
        loadStats();
      }
    } catch (error) {
      console.error('Error checking admin access:', error);
    }
    setLoading(false);
  };

  const loadStats = async () => {
    try {
      const response = await api.getAdminStats();
      if (response.success && response.data) {
        setStats({
          totalMembers: response.data.total_members || 0,
          totalOrders: response.data.total_orders || 0,
          totalProductRequests: response.data.pending_requests || 0,
          totalRevenue: response.data.total_revenue || 0
        });
      }
    } catch (error) {
      console.error('Error loading stats:', error);
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

  if (!isAdmin) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-lg shadow-lg p-8 max-w-md w-full text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Accès refusé</h2>
          <p className="text-gray-600 mb-6">Vous n'avez pas les permissions pour accéder à ce tableau de bord.</p>
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

  const tabs: AdminTab[] = [
    { id: 'overview', label: 'Aperçu', icon: <LayoutDashboard className="w-5 h-5" /> },
    { id: 'products', label: 'Produits', icon: <Package className="w-5 h-5" /> },
    { id: 'partners', label: 'Boutiques Partenaires', icon: <Store className="w-5 h-5" /> },
    { id: 'members', label: 'Membres', icon: <Users className="w-5 h-5" /> },
    { id: 'levels', label: 'Niveaux', icon: <TrendingUp className="w-5 h-5" /> },
    { id: 'orders', label: 'Commandes', icon: <ShoppingBag className="w-5 h-5" /> },
    { id: 'requests', label: 'Demandes', icon: <Package className="w-5 h-5" /> },
    { id: 'referrals', label: 'Parrainages', icon: <Users className="w-5 h-5" /> },
    { id: 'locations', label: 'Localités', icon: <Globe className="w-5 h-5" /> },
  ];

  return (
    <div className="min-h-screen bg-gray-100 flex">
      <aside className="w-64 bg-white shadow-lg min-h-screen fixed left-0 top-0">
        <div className="p-6 border-b border-gray-200">
          <h1 className="text-2xl font-bold text-blue-600">NOW! Admin</h1>
        </div>

        <nav className="p-4">
          <ul className="space-y-2">
            {tabs.map((tab) => (
              <li key={tab.id}>
                <button
                  onClick={() => setActiveTab(tab.id)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                    activeTab === tab.id
                      ? 'bg-blue-600 text-white shadow-md'
                      : 'text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  {tab.icon}
                  <span>{tab.label}</span>
                </button>
              </li>
            ))}
          </ul>
        </nav>

        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-200 space-y-2">
          <button
            onClick={() => window.location.href = '/admin/site-settings'}
            className="w-full flex items-center justify-center gap-2 px-4 py-3 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <Settings className="w-5 h-5" />
            <span>Paramètres du site</span>
          </button>
          <button
            onClick={handleSignOut}
            className="w-full flex items-center justify-center gap-2 px-4 py-3 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Déconnexion</span>
          </button>
        </div>
      </aside>

      <div className="flex-1 ml-64">
        {activeTab === 'overview' && (
          <div className="p-6">
            <div className="grid md:grid-cols-4 gap-4">
              <div className="bg-white rounded-lg shadow p-6">
                <div className="text-gray-600 text-sm font-medium mb-2">Membres</div>
                <div className="text-3xl font-bold text-blue-600">{stats.totalMembers}</div>
              </div>
              <div className="bg-white rounded-lg shadow p-6">
                <div className="text-gray-600 text-sm font-medium mb-2">Commandes</div>
                <div className="text-3xl font-bold text-green-600">{stats.totalOrders}</div>
              </div>
              <div className="bg-white rounded-lg shadow p-6">
                <div className="text-gray-600 text-sm font-medium mb-2">Demandes de produits</div>
                <div className="text-3xl font-bold text-purple-600">{stats.totalProductRequests}</div>
              </div>
              <div className="bg-white rounded-lg shadow p-6">
                <div className="text-gray-600 text-sm font-medium mb-2">Revenu total</div>
                <div className="text-3xl font-bold text-orange-600">{stats.totalRevenue.toFixed(2)} €</div>
              </div>
            </div>
          </div>
        )}

        {activeTab === 'products' && <AdminProducts />}
        {activeTab === 'partners' && <AdminPartnerShops />}
        {activeTab === 'members' && <AdminMembers />}
        {activeTab === 'levels' && <AdminLevels />}
        {activeTab === 'orders' && <AdminOrders />}
        {activeTab === 'requests' && <AdminRequests />}
        {activeTab === 'referrals' && <AdminReferrals />}
        {activeTab === 'locations' && <AdminLocations />}
      </div>
    </div>
  );
}

function AdminProducts() {
  const [products, setProducts] = useState<any[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [editingProduct, setEditingProduct] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      const response = await api.getProducts();
      if (response.success && response.data) {
        setProducts(response.data);
      }
    } catch (error) {
      console.error('Error loading products:', error);
    }
    setLoading(false);
  };

  const handleDeleteProduct = async (id: string) => {
    if (!confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')) return;

    try {
      await api.deleteProduct(id);
      loadProducts();
    } catch (error) {
      alert('Erreur lors de la suppression');
    }
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="mb-6">
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-blue-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-700 transition-colors"
        >
          Ajouter un produit
        </button>
      </div>

      {showForm && <ProductForm onSuccess={() => { setShowForm(false); setEditingProduct(null); loadProducts(); }} editingProduct={editingProduct} />}

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Image</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Nom</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Catégorie</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Prix</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Stock</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Lien achat</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody>
            {products.map((product) => (
              <tr key={product.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4">
                  <img src={product.image_url} alt={product.name} className="w-12 h-12 object-cover rounded" />
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">{product.name}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{product.category}</td>
                <td className="px-6 py-4 text-sm text-gray-900">{product.price} €</td>
                <td className="px-6 py-4 text-sm text-gray-900">{product.stock}</td>
                <td className="px-6 py-4 text-sm">
                  {product.purchase_link ? (
                    <a href={product.purchase_link} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                      Voir
                    </a>
                  ) : (
                    <span className="text-gray-400">-</span>
                  )}
                </td>
                <td className="px-6 py-4 text-sm">
                  <span className={`px-2 py-1 rounded text-xs font-medium ${
                    product.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                  }`}>
                    {product.is_active ? 'Actif' : 'Inactif'}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm">
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => { setEditingProduct(product); setShowForm(true); }}
                      className="text-blue-600 hover:text-blue-800"
                      title="Modifier"
                    >
                      <Edit2 className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleDeleteProduct(product.id)}
                      className="text-red-600 hover:text-red-800"
                      title="Supprimer"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function ProductForm({ onSuccess, editingProduct }: { onSuccess: () => void; editingProduct?: any }) {
  const [formData, setFormData] = useState({
    name: editingProduct?.name || '',
    description: editingProduct?.description || '',
    price: editingProduct?.price?.toString() || '',
    category: editingProduct?.category || '',
    stock: editingProduct?.stock?.toString() || '',
    image_url: editingProduct?.image_url || '',
    purchase_link: editingProduct?.purchase_link || '',
    is_active: editingProduct?.is_active ?? true,
  });
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(editingProduct?.image_url || null);
  const [imageError, setImageError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleImageSelect = (file: File) => {
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
    setFormData({ ...formData, image_url: '' });
  };

  const uploadImage = async (productId: string): Promise<string | null> => {
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

    if (!imageFile && !formData.image_url) {
      setImageError('Une image est obligatoire');
      return;
    }

    setLoading(true);

    try {
      let finalImageUrl = formData.image_url;

      if (imageFile) {
        const uploadResponse = await api.uploadFile(imageFile);
        if (uploadResponse.success && uploadResponse.data?.url) {
          finalImageUrl = uploadResponse.data.url;
        }
      }

      const productData = {
        name: formData.name,
        description: formData.description,
        price: parseFloat(formData.price),
        category: formData.category,
        stock: parseInt(formData.stock),
        image_url: finalImageUrl,
        purchase_link: formData.purchase_link || null,
        is_active: formData.is_active
      };

      if (editingProduct) {
        await api.updateProduct(editingProduct.id, productData);
      } else {
        await api.createProduct(productData);
      }

      onSuccess();
    } catch (error) {
      alert(editingProduct ? 'Erreur lors de la modification du produit' : 'Erreur lors de l\'ajout du produit');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow p-6 mb-6">
      <h3 className="text-lg font-bold mb-4">{editingProduct ? 'Modifier le produit' : 'Ajouter un produit'}</h3>
      <form onSubmit={handleSubmit} className="grid md:grid-cols-2 gap-4">
        <input
          type="text"
          placeholder="Nom du produit"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <input
          type="text"
          placeholder="Catégorie"
          value={formData.category}
          onChange={(e) => setFormData({ ...formData, category: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <div className="col-span-2">
          <ImageUpload
            onImageSelect={handleImageSelect}
            preview={imagePreview}
            onRemove={removeImage}
            error={imageError}
            required
          />
          <p className="text-xs text-gray-500 mt-2">Ou</p>
          <input
            type="url"
            placeholder="URL de l'image"
            value={formData.image_url}
            onChange={(e) => setFormData({ ...formData, image_url: e.target.value })}
            className="px-4 py-2 border rounded-lg w-full mt-2"
          />
        </div>
        <input
          type="url"
          placeholder="Lien d'achat externe (facultatif)"
          value={formData.purchase_link}
          onChange={(e) => setFormData({ ...formData, purchase_link: e.target.value })}
          className="px-4 py-2 border rounded-lg col-span-2"
        />
        <textarea
          placeholder="Description"
          value={formData.description}
          onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          className="px-4 py-2 border rounded-lg col-span-2"
          rows={2}
        />
        <input
          type="number"
          step="0.01"
          placeholder="Prix"
          value={formData.price}
          onChange={(e) => setFormData({ ...formData, price: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <input
          type="number"
          placeholder="Stock"
          value={formData.stock}
          onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <div className="col-span-2 flex items-center gap-4">
          <label className="flex items-center gap-2">
            <input
              type="checkbox"
              checked={formData.is_active}
              onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
              className="w-4 h-4 text-blue-600"
            />
            <span className="text-sm text-gray-700">Produit actif</span>
          </label>
        </div>
        <button
          type="submit"
          disabled={loading}
          className="bg-blue-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-700 transition-colors col-span-2 disabled:bg-gray-400"
        >
          {loading ? (editingProduct ? 'Modification...' : 'Ajout en cours...') : (editingProduct ? 'Modifier le produit' : 'Ajouter le produit')}
        </button>
      </form>
    </div>
  );
}

function AdminMembers() {
  const [members, setMembers] = useState<any[]>([]);
  const [membershipLevels, setMembershipLevels] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadMembers();
    loadMembershipLevels();
  }, []);

  const loadMembers = async () => {
    try {
      const response = await api.getAllMembers({ limit: 100 });
      if (response.success && response.data) {
        setMembers(response.data);
      }
    } catch (error) {
      console.error('Error loading members:', error);
    }
    setLoading(false);
  };

  const loadMembershipLevels = async () => {
    try {
      const response = await api.getMembershipLevels();
      if (response.success && response.data) {
        setMembershipLevels(response.data);
      }
    } catch (error) {
      console.error('Error loading levels:', error);
    }
  };

  const updateMemberStatus = async (memberId: string, newStatus: string) => {
    try {
      await api.updateMember({ status: newStatus });
      loadMembers();
    } catch (error) {
      alert('Erreur lors de la mise à jour');
    }
  };

  const updateMemberLevel = async (memberId: string, newLevelId: string | null) => {
    try {
      await api.updateMember({ membership_level_id: newLevelId });
      loadMembers();
    } catch (error) {
      alert('Erreur lors de la mise à jour');
    }
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  const getLevelColor = (levelName: string) => {
    switch(levelName) {
      case 'RACINE': return 'bg-amber-100 text-amber-800';
      case 'TRONC': return 'bg-orange-100 text-orange-800';
      case 'BRANCHES': return 'bg-green-100 text-green-800';
      case 'FEUILLES': return 'bg-emerald-100 text-emerald-800';
      case 'POLLEN': return 'bg-yellow-100 text-yellow-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <div className="p-6">
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Email</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Code</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Localité</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Niveau</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Dépenses</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody>
            {members.map((member) => (
              <tr key={member.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4 text-sm text-gray-900">{member.email}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{member.code}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{member.localities?.name || '-'}</td>
                <td className="px-6 py-4 text-sm">
                  {member.membership_levels?.name ? (
                    <span className={`px-2 py-1 rounded text-xs font-medium ${getLevelColor(member.membership_levels.name)}`}>
                      {member.membership_levels.name}
                    </span>
                  ) : (
                    <span className="text-gray-400">-</span>
                  )}
                </td>
                <td className="px-6 py-4 text-sm">
                  <span className={`px-2 py-1 rounded text-xs font-medium ${
                    member.status === 'active' ? 'bg-green-100 text-green-800' :
                    member.status === 'inactive' ? 'bg-red-100 text-red-800' :
                    'bg-yellow-100 text-yellow-800'
                  }`}>
                    {member.status === 'active' ? 'Actif' : member.status === 'inactive' ? 'Inactif' : 'En attente'}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">{member.total_spent?.toFixed(2) || 0} €</td>
                <td className="px-6 py-4 text-sm">
                  <div className="space-y-2">
                    <select
                      value={member.membership_level_id || ''}
                      onChange={(e) => updateMemberLevel(member.id, e.target.value || null)}
                      className="w-full px-2 py-1 border rounded text-xs"
                      title="Changer le niveau"
                    >
                      <option value="">Aucun niveau</option>
                      {membershipLevels.map((level) => (
                        <option key={level.id} value={level.id}>{level.name}</option>
                      ))}
                    </select>
                    <select
                      value={member.status}
                      onChange={(e) => updateMemberStatus(member.id, e.target.value)}
                      className="w-full px-2 py-1 border rounded text-xs"
                      title="Changer le statut"
                    >
                      <option value="pending">En attente</option>
                      <option value="active">Actif</option>
                      <option value="inactive">Inactif</option>
                    </select>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function AdminLevels() {
  const [levels, setLevels] = useState<any[]>([]);
  const [editingLevel, setEditingLevel] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadLevels();
  }, []);

  const loadLevels = async () => {
    try {
      const response = await api.getMembershipLevels();
      if (response.success && response.data) {
        setLevels(response.data);
      }
    } catch (error) {
      console.error('Error loading levels:', error);
    }
    setLoading(false);
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      {editingLevel && (
        <LevelEditForm
          level={editingLevel}
          onSuccess={() => { setEditingLevel(null); loadLevels(); }}
          onCancel={() => setEditingLevel(null)}
        />
      )}

      <div className="grid md:grid-cols-2 gap-4">
        {levels.map((level) => (
          <div key={level.id} className="bg-white rounded-lg shadow p-6">
            <div className="flex justify-between items-start mb-2">
              <h3 className="text-lg font-bold">{level.name}</h3>
              <button
                onClick={() => setEditingLevel(level)}
                className="text-blue-600 hover:text-blue-800"
                title="Modifier"
              >
                <Edit2 className="w-4 h-4" />
              </button>
            </div>
            <p className="text-sm text-gray-600 mb-4">Achats minimum: {level.minimum_purchases} €</p>
            <p className="text-sm text-gray-600 mb-4">Réduction: {level.discount_percentage}%</p>
            <div className="bg-blue-50 rounded p-3">
              <p className="text-xs font-medium text-gray-700 mb-2">Avantages:</p>
              <ul className="text-xs text-gray-600 space-y-1">
                {level.benefits?.map((benefit: string, idx: number) => (
                  <li key={idx}>• {benefit}</li>
                ))}
              </ul>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function AdminOrders() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadOrders();
  }, []);

  const loadOrders = async () => {
    try {
      const response = await api.getAllOrders({ limit: 100 });
      if (response.success && response.data) {
        setOrders(response.data);
      }
    } catch (error) {
      console.error('Error loading orders:', error);
    }
    setLoading(false);
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Date</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Membre</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Code</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Montant</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Paiement</th>
            </tr>
          </thead>
          <tbody>
            {orders.map((order) => (
              <tr key={order.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4 text-sm text-gray-900">
                  {new Date(order.created_at).toLocaleDateString('fr-FR')}
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">{order.members?.email || '-'}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{order.members?.code || '-'}</td>
                <td className="px-6 py-4 text-sm font-medium text-gray-900">{order.amount} €</td>
                <td className="px-6 py-4 text-sm">
                  <span className={`px-2 py-1 rounded text-xs font-medium ${
                    order.status === 'paid' ? 'bg-green-100 text-green-800' :
                    order.status === 'cancelled' ? 'bg-red-100 text-red-800' :
                    'bg-yellow-100 text-yellow-800'
                  }`}>
                    {order.status === 'paid' ? 'Payé' : order.status === 'cancelled' ? 'Annulé' : 'En attente'}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-600">{order.payment_method || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>

        {orders.length === 0 && (
          <div className="text-center py-12 text-gray-500">
            Aucune commande enregistrée
          </div>
        )}
      </div>
    </div>
  );
}

function AdminLocations() {
  const [countries, setCountries] = useState<any[]>([]);
  const [localities, setLocalities] = useState<any[]>([]);
  const [showCountryForm, setShowCountryForm] = useState(false);
  const [showLocalityForm, setShowLocalityForm] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [countriesResponse, localitiesResponse] = await Promise.all([
        api.getCountries(),
        api.getLocalities()
      ]);

      if (countriesResponse.success && countriesResponse.data) {
        setCountries(countriesResponse.data);
      }
      if (localitiesResponse.success && localitiesResponse.data) {
        setLocalities(localitiesResponse.data);
      }
    } catch (error) {
      console.error('Error loading data:', error);
    }
    setLoading(false);
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="grid md:grid-cols-2 gap-6">
        <div>
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-bold">Pays</h3>
            <button
              onClick={() => setShowCountryForm(!showCountryForm)}
              className="bg-blue-600 text-white px-3 py-1 rounded-lg text-sm hover:bg-blue-700"
            >
              {showCountryForm ? 'Fermer' : 'Ajouter'}
            </button>
          </div>

          {showCountryForm && <AddCountryForm onSuccess={() => { setShowCountryForm(false); loadData(); }} />}

          <div className="bg-white rounded-lg shadow overflow-hidden">
            <table className="w-full">
              <thead className="bg-gray-50 border-b">
                <tr>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Nom</th>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Code</th>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Devise</th>
                </tr>
              </thead>
              <tbody>
                {countries.map((country) => (
                  <tr key={country.id} className="border-b hover:bg-gray-50">
                    <td className="px-4 py-2 text-xs text-gray-900">{country.name}</td>
                    <td className="px-4 py-2 text-xs text-gray-600">{country.code}</td>
                    <td className="px-4 py-2 text-xs text-gray-600">{country.currency_code}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div>
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-bold">Localités</h3>
            <button
              onClick={() => setShowLocalityForm(!showLocalityForm)}
              className="bg-blue-600 text-white px-3 py-1 rounded-lg text-sm hover:bg-blue-700"
            >
              {showLocalityForm ? 'Fermer' : 'Ajouter'}
            </button>
          </div>

          {showLocalityForm && <AddLocalityForm onSuccess={() => { setShowLocalityForm(false); loadData(); }} countries={countries} />}

          <div className="bg-white rounded-lg shadow overflow-hidden max-h-[600px] overflow-y-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b sticky top-0">
                <tr>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Nom</th>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Code</th>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-700">Pays</th>
                </tr>
              </thead>
              <tbody>
                {localities.map((locality) => (
                  <tr key={locality.id} className="border-b hover:bg-gray-50">
                    <td className="px-4 py-2 text-xs text-gray-900">{locality.name}</td>
                    <td className="px-4 py-2 text-xs text-gray-600">{locality.code_prefix}</td>
                    <td className="px-4 py-2 text-xs text-gray-600">{locality.countries?.name || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

function AddCountryForm({ onSuccess }: { onSuccess: () => void }) {
  const [formData, setFormData] = useState({
    name: '',
    code: '',
    phone_prefix: '',
    currency_code: '',
    language_code: 'fr',
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Note: Vous devrez ajouter cette méthode à l'API ou utiliser fetch direct
      const API_URL = import.meta.env.VITE_API_URL || 'https://arnowconcept.com/api';
      const response = await fetch(`${API_URL}/countries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        onSuccess();
      } else {
        throw new Error('Failed to add country');
      }
    } catch (error) {
      alert('Erreur lors de l\'ajout du pays');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-gray-50 p-4 rounded-lg mb-4">
      <div className="grid grid-cols-2 gap-2">
        <input
          type="text"
          placeholder="Nom du pays"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="px-3 py-2 border rounded text-sm"
          required
        />
        <input
          type="text"
          placeholder="Code (ex: FR)"
          value={formData.code}
          onChange={(e) => setFormData({ ...formData, code: e.target.value.toUpperCase() })}
          className="px-3 py-2 border rounded text-sm"
          maxLength={2}
          required
        />
        <input
          type="text"
          placeholder="Préfixe tél (ex: +33)"
          value={formData.phone_prefix}
          onChange={(e) => setFormData({ ...formData, phone_prefix: e.target.value })}
          className="px-3 py-2 border rounded text-sm"
          required
        />
        <input
          type="text"
          placeholder="Devise (ex: EUR)"
          value={formData.currency_code}
          onChange={(e) => setFormData({ ...formData, currency_code: e.target.value.toUpperCase() })}
          className="px-3 py-2 border rounded text-sm"
          maxLength={3}
          required
        />
      </div>
      <button
        type="submit"
        disabled={loading}
        className="mt-2 w-full bg-blue-600 text-white px-4 py-2 rounded text-sm hover:bg-blue-700 disabled:bg-gray-400"
      >
        {loading ? 'Ajout...' : 'Ajouter'}
      </button>
    </form>
  );
}

function AddLocalityForm({ onSuccess, countries }: { onSuccess: () => void; countries: any[] }) {
  const [formData, setFormData] = useState({
    name: '',
    code_prefix: '',
    country_id: '',
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { error } = await supabase
        .from('localities')
        .insert({
          ...formData,
          member_count: 0
        });

      if (error) throw error;
      onSuccess();
    } catch (error) {
      alert('Erreur lors de l\'ajout de la localité');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-gray-50 p-4 rounded-lg mb-4">
      <div className="space-y-2">
        <input
          type="text"
          placeholder="Nom de la ville"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="w-full px-3 py-2 border rounded text-sm"
          required
        />
        <input
          type="text"
          placeholder="Code (ex: PAR)"
          value={formData.code_prefix}
          onChange={(e) => setFormData({ ...formData, code_prefix: e.target.value.toUpperCase() })}
          className="w-full px-3 py-2 border rounded text-sm"
          maxLength={3}
          required
        />
        <select
          value={formData.country_id}
          onChange={(e) => setFormData({ ...formData, country_id: e.target.value })}
          className="w-full px-3 py-2 border rounded text-sm"
          required
        >
          <option value="">Sélectionner un pays</option>
          {countries.map((country) => (
            <option key={country.id} value={country.id}>{country.name}</option>
          ))}
        </select>
      </div>
      <button
        type="submit"
        disabled={loading}
        className="mt-2 w-full bg-blue-600 text-white px-4 py-2 rounded text-sm hover:bg-blue-700 disabled:bg-gray-400"
      >
        {loading ? 'Ajout...' : 'Ajouter'}
      </button>
    </form>
  );
}

function LevelEditForm({ level, onSuccess, onCancel }: { level: any; onSuccess: () => void; onCancel: () => void }) {
  const [formData, setFormData] = useState({
    minimum_purchases: level.minimum_purchases?.toString() || '0',
    discount_percentage: level.discount_percentage?.toString() || '0',
    benefits: level.benefits || [],
  });
  const [newBenefit, setNewBenefit] = useState('');
  const [loading, setLoading] = useState(false);

  const addBenefit = () => {
    if (newBenefit.trim()) {
      setFormData({ ...formData, benefits: [...formData.benefits, newBenefit.trim()] });
      setNewBenefit('');
    }
  };

  const removeBenefit = (index: number) => {
    const updatedBenefits = formData.benefits.filter((_: any, i: number) => i !== index);
    setFormData({ ...formData, benefits: updatedBenefits });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { error } = await supabase
        .from('membership_levels')
        .update({
          minimum_purchases: parseFloat(formData.minimum_purchases),
          discount_percentage: parseFloat(formData.discount_percentage),
          benefits: formData.benefits,
        })
        .eq('id', level.id);

      if (error) throw error;
      onSuccess();
    } catch (error) {
      alert('Erreur lors de la modification du niveau');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow p-6 mb-6">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-lg font-bold">Modifier le niveau: {level.name}</h3>
        <button onClick={onCancel} className="text-gray-500 hover:text-gray-700">✕</button>
      </div>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Achats minimum (€)</label>
            <input
              type="number"
              step="0.01"
              value={formData.minimum_purchases}
              onChange={(e) => setFormData({ ...formData, minimum_purchases: e.target.value })}
              className="w-full px-4 py-2 border rounded-lg"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Réduction (%)</label>
            <input
              type="number"
              step="0.01"
              value={formData.discount_percentage}
              onChange={(e) => setFormData({ ...formData, discount_percentage: e.target.value })}
              className="w-full px-4 py-2 border rounded-lg"
              required
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Avantages</label>
          <div className="space-y-2 mb-2">
            {formData.benefits.map((benefit: string, idx: number) => (
              <div key={idx} className="flex items-center gap-2 bg-gray-50 p-2 rounded">
                <span className="flex-1 text-sm">{benefit}</span>
                <button
                  type="button"
                  onClick={() => removeBenefit(idx)}
                  className="text-red-600 hover:text-red-800"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
          <div className="flex gap-2">
            <input
              type="text"
              value={newBenefit}
              onChange={(e) => setNewBenefit(e.target.value)}
              placeholder="Nouvel avantage"
              className="flex-1 px-4 py-2 border rounded-lg"
            />
            <button
              type="button"
              onClick={addBenefit}
              className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200"
            >
              Ajouter
            </button>
          </div>
        </div>

        <div className="flex gap-2 pt-4">
          <button
            type="submit"
            disabled={loading}
            className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-700 disabled:bg-gray-400"
          >
            {loading ? 'Modification...' : 'Enregistrer'}
          </button>
          <button
            type="button"
            onClick={onCancel}
            className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
          >
            Annuler
          </button>
        </div>
      </form>
    </div>
  );
}

function AdminRequests() {
  const [requests, setRequests] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadRequests();
  }, []);

  const loadRequests = async () => {
    const { data } = await supabase
      .from('product_requests')
      .select('*')
      .order('created_at', { ascending: false });

    if (data) setRequests(data);
    setLoading(false);
  };

  const updateStatus = async (id: string, status: string) => {
    await supabase
      .from('product_requests')
      .update({ status })
      .eq('id', id);
    loadRequests();
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Produit</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Email</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Prix trouvé</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody>
            {requests.map((request) => (
              <tr key={request.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4 text-sm text-gray-900">{request.product_name}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{request.email}</td>
                <td className="px-6 py-4 text-sm text-gray-900">{request.best_price_found} €</td>
                <td className="px-6 py-4 text-sm">
                  <select
                    value={request.status}
                    onChange={(e) => updateStatus(request.id, e.target.value)}
                    className="px-2 py-1 border rounded text-sm"
                  >
                    <option value="pending">En attente</option>
                    <option value="processing">En cours</option>
                    <option value="completed">Complété</option>
                  </select>
                </td>
                <td className="px-6 py-4 text-sm">
                  {request.image_url && (
                    <a href={request.image_url} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                      Voir image
                    </a>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function AdminReferrals() {
  const [referrals, setReferrals] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadReferrals();
  }, []);

  const loadReferrals = async () => {
    const { data } = await supabase
      .from('referrals')
      .select('*, members_referrer:members!referrer_id(email), members_referred:members!referred_id(email)')
      .order('created_at', { ascending: false });

    if (data) setReferrals(data);
    setLoading(false);
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Parrain</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Filleul</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Code</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Bonus</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
            </tr>
          </thead>
          <tbody>
            {referrals.map((referral) => (
              <tr key={referral.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4 text-sm text-gray-900">{referral.members_referrer?.email || 'N/A'}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{referral.members_referred?.email || 'N/A'}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{referral.referral_code}</td>
                <td className="px-6 py-4 text-sm text-gray-900">{referral.bonus_amount} €</td>
                <td className="px-6 py-4 text-sm">
                  <span className={`px-2 py-1 rounded text-xs font-medium ${
                    referral.status === 'completed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                  }`}>
                    {referral.status === 'completed' ? 'Complété' : 'En attente'}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {referrals.length === 0 && (
          <div className="text-center py-12 text-gray-500">
            Aucun parrainage enregistré
          </div>
        )}
      </div>
    </div>
  );
}

function AdminPartnerShops() {
  const [shops, setShops] = useState<any[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [editingShop, setEditingShop] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadShops();
  }, []);

  const loadShops = async () => {
    const { data } = await supabase
      .from('partner_shops')
      .select('*')
      .order('created_at', { ascending: false });

    if (data) setShops(data);
    setLoading(false);
  };

  const handleDeleteShop = async (id: string) => {
    if (!confirm('Êtes-vous sûr de vouloir supprimer cette boutique partenaire ?')) return;

    const { error } = await supabase
      .from('partner_shops')
      .delete()
      .eq('id', id);

    if (error) {
      alert('Erreur lors de la suppression');
    } else {
      loadShops();
    }
  };

  if (loading) {
    return <div className="text-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div></div>;
  }

  return (
    <div className="p-6">
      <div className="mb-6">
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-blue-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-700 transition-colors"
        >
          Ajouter une boutique partenaire
        </button>
      </div>

      {showForm && <PartnerShopForm onSuccess={() => { setShowForm(false); setEditingShop(null); loadShops(); }} editingShop={editingShop} />}

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Logo</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Nom</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Description</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Réduction</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody>
            {shops.map((shop) => (
              <tr key={shop.id} className="border-b hover:bg-gray-50">
                <td className="px-6 py-4">
                  {shop.logo_url ? (
                    <img src={shop.logo_url} alt={shop.name} className="w-12 h-12 object-cover rounded" />
                  ) : (
                    <div className="w-12 h-12 bg-gray-200 rounded flex items-center justify-center">
                      <Store className="w-6 h-6 text-gray-400" />
                    </div>
                  )}
                </td>
                <td className="px-6 py-4 text-sm font-medium text-gray-900">{shop.name}</td>
                <td className="px-6 py-4 text-sm text-gray-600 max-w-xs truncate">{shop.description}</td>
                <td className="px-6 py-4 text-sm font-medium text-green-600">{shop.discount_percentage}%</td>
                <td className="px-6 py-4 text-sm">
                  <span className={`px-2 py-1 rounded text-xs font-medium ${
                    shop.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                  }`}>
                    {shop.is_active ? 'Actif' : 'Inactif'}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => { setEditingShop(shop); setShowForm(true); }}
                      className="text-blue-600 hover:text-blue-800"
                      title="Modifier"
                    >
                      <Edit2 className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleDeleteShop(shop.id)}
                      className="text-red-600 hover:text-red-800"
                      title="Supprimer"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {shops.length === 0 && (
          <div className="text-center py-12 text-gray-500">
            Aucune boutique partenaire enregistrée
          </div>
        )}
      </div>
    </div>
  );
}

function PartnerShopForm({ onSuccess, editingShop }: { onSuccess: () => void; editingShop?: any }) {
  const [formData, setFormData] = useState({
    name: editingShop?.name || '',
    description: editingShop?.description || '',
    discount_percentage: editingShop?.discount_percentage?.toString() || '',
    logo_url: editingShop?.logo_url || '',
    category: editingShop?.category || '',
    is_active: editingShop?.is_active ?? true,
  });
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(editingShop?.logo_url || null);
  const [imageError, setImageError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleImageSelect = (file: File) => {
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
    setFormData({ ...formData, logo_url: '' });
  };

  const uploadImage = async (shopId: string): Promise<string | null> => {
    if (!imageFile) return null;

    const fileExt = imageFile.name.split('.').pop();
    const fileName = `partner-shops/${shopId}.${fileExt}`;

    const { error } = await supabase.storage
      .from('product-images')
      .upload(fileName, imageFile, { upsert: true });

    if (error) {
      console.error('Erreur upload:', error);
      return null;
    }

    const { data: { publicUrl } } = supabase.storage
      .from('product-images')
      .getPublicUrl(fileName);

    return publicUrl;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      let finalLogoUrl = formData.logo_url;

      if (imageFile) {
        const tempId = editingShop?.id || crypto.randomUUID();
        const uploadedUrl = await uploadImage(tempId);
        if (uploadedUrl) {
          finalLogoUrl = uploadedUrl;
        }
      }

      const shopData = {
        name: formData.name,
        description: formData.description,
        discount_percentage: parseFloat(formData.discount_percentage),
        logo_url: finalLogoUrl || null,
        category: formData.category,
        is_active: formData.is_active
      };

      if (editingShop) {
        const { error } = await supabase
          .from('partner_shops')
          .update(shopData)
          .eq('id', editingShop.id);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('partner_shops')
          .insert(shopData);
        if (error) throw error;
      }

      onSuccess();
    } catch (error) {
      alert(editingShop ? 'Erreur lors de la modification de la boutique' : 'Erreur lors de l\'ajout de la boutique partenaire');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6 mb-6">
      <h3 className="text-lg font-bold mb-4">{editingShop ? 'Modifier la boutique partenaire' : 'Nouvelle boutique partenaire'}</h3>
      <div className="grid grid-cols-2 gap-4">
        <input
          type="text"
          placeholder="Nom de la boutique"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <input
          type="text"
          placeholder="Catégorie"
          value={formData.category}
          onChange={(e) => setFormData({ ...formData, category: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <input
          type="number"
          step="0.01"
          placeholder="% de réduction"
          value={formData.discount_percentage}
          onChange={(e) => setFormData({ ...formData, discount_percentage: e.target.value })}
          className="px-4 py-2 border rounded-lg"
          required
        />
        <textarea
          placeholder="Description"
          value={formData.description}
          onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          className="px-4 py-2 border rounded-lg col-span-2"
          rows={3}
          required
        />
        <div className="col-span-2">
          <ImageUpload
            onImageSelect={handleImageSelect}
            preview={imagePreview}
            onRemove={removeImage}
            error={imageError}
          />
          <p className="text-xs text-gray-500 mt-2">Ou</p>
          <input
            type="url"
            placeholder="URL du logo"
            value={formData.logo_url}
            onChange={(e) => setFormData({ ...formData, logo_url: e.target.value })}
            className="px-4 py-2 border rounded-lg w-full mt-2"
          />
        </div>
        <div className="col-span-2 flex items-center gap-4">
          <label className="flex items-center gap-2">
            <input
              type="checkbox"
              checked={formData.is_active}
              onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
              className="w-4 h-4 text-blue-600"
            />
            <span className="text-sm text-gray-700">Boutique active</span>
          </label>
        </div>
      </div>
      <button
        type="submit"
        disabled={loading}
        className="mt-4 bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 disabled:bg-gray-400"
      >
        {loading ? (editingShop ? 'Modification...' : 'Ajout...') : (editingShop ? 'Modifier' : 'Ajouter')}
      </button>
    </form>
  );
}
