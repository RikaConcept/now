# Guide Rapide: Adaptation AdminDashboard.tsx

Ce fichier est très long (~1635 lignes). Voici comment l'adapter rapidement.

## 1. Importer l'API (ligne 2)

```typescript
// REMPLACER
import { supabase } from '../lib/supabase';

// PAR
import { api } from '../lib/api';
```

## 2. Fonction checkAdminAccess (lignes 31-45)

```typescript
const checkAdminAccess = async () => {
  if (!user) return;

  try {
    const response = await api.getCurrentUser();
    if (response.success && response.data?.user?.is_admin) {
      setIsAdmin(true);
      loadStats();
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

## 3. Fonction loadStats (lignes 47-69)

```typescript
const loadStats = async () => {
  try {
    const statsResponse = await api.getAdminStats();
    if (statsResponse.success) {
      setStats({
        totalMembers: statsResponse.data.total_members || 0,
        totalOrders: statsResponse.data.total_orders || 0,
        totalProductRequests: statsResponse.data.pending_requests || 0,
        totalRevenue: statsResponse.data.total_revenue || 0
      });
    }
  } catch (error) {
    console.error('Error loading stats:', error);
  }
};
```

## 4. AdminProducts Component

### loadProducts (ligne 207)

```typescript
const loadProducts = async () => {
  try {
    const response = await api.getProducts();
    if (response.success && response.data) {
      setProducts(response.data);
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

### handleDeleteProduct (ligne 218)

```typescript
const handleDeleteProduct = async (id: string) => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')) return;

  try {
    await api.deleteProduct(id);
    loadProducts();
  } catch (error) {
    alert('Erreur lors de la suppression');
  }
};
```

### ProductForm handleSubmit (ligne 383)

```typescript
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
```

## 5. AdminMembers Component

### loadMembers (ligne 537)

```typescript
const loadMembers = async () => {
  try {
    const response = await api.getAllMembers({ limit: 100 });
    if (response.success && response.data) {
      setMembers(response.data);
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

### loadMembershipLevels (ligne 547)

```typescript
const loadMembershipLevels = async () => {
  try {
    const response = await api.getMembershipLevels();
    if (response.success && response.data) {
      setMembershipLevels(response.data);
    }
  } catch (error) {
    console.error(error);
  }
};
```

### updateMemberStatus (ligne 556)

```typescript
const updateMemberStatus = async (memberId: string, newStatus: string) => {
  try {
    // Note: Vous devrez peut-être ajouter cette méthode à api.ts
    await fetch(`${import.meta.env.VITE_API_URL}/members?id=${memberId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
      },
      body: JSON.stringify({ status: newStatus })
    });
    loadMembers();
  } catch (error) {
    alert('Erreur lors de la mise à jour');
  }
};
```

## 6. AdminOrders Component

### loadOrders (ligne 742)

```typescript
const loadOrders = async () => {
  try {
    const response = await api.getAllOrders({ limit: 100 });
    if (response.success && response.data) {
      setOrders(response.data);
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

## 7. AdminRequests Component

### loadRequests (ligne 1200)

```typescript
const loadRequests = async () => {
  try {
    const response = await api.getAdminProductRequests({ limit: 100 });
    if (response.success && response.data) {
      setRequests(response.data);
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

### updateStatus (ligne 1210)

```typescript
const updateStatus = async (id: string, status: string) => {
  try {
    await api.updateProductRequest(id, status);
    loadRequests();
  } catch (error) {
    console.error(error);
  }
};
```

## 8. AdminLocations Component

### loadData (ligne 815)

```typescript
const loadData = async () => {
  try {
    const [countriesResponse, localitiesResponse] = await Promise.all([
      api.getCountries(),
      api.getLocalities()
    ]);

    if (countriesResponse.success) {
      setCountries(countriesResponse.data || []);
    }
    if (localitiesResponse.success) {
      setLocalities(localitiesResponse.data || []);
    }
  } catch (error) {
    console.error(error);
  }
  setLoading(false);
};
```

## 9. Supprimer tous les uploads Supabase Storage

Rechercher tous les blocs qui contiennent `supabase.storage` et les remplacer par:

```typescript
// AVANT
const { error } = await supabase.storage
  .from('product-images')
  .upload(fileName, imageFile, { upsert: true });

const { data: { publicUrl } } = supabase.storage
  .from('product-images')
  .getPublicUrl(fileName);

// APRÈS
const response = await api.uploadFile(imageFile);
if (response.success && response.data?.url) {
  const imageUrl = response.data.url;
}
```

## Script de Remplacement Automatique

Vous pouvez utiliser ces commandes find/replace dans votre éditeur:

### Rechercher et remplacer:

1. **Import:**
   - Chercher: `from '../lib/supabase'`
   - Remplacer: `from '../lib/api'`

2. **Variable supabase:**
   - Chercher: `import { supabase }`
   - Remplacer: `import { api }`

3. **Appels génériques (à adapter manuellement):**
   - Chercher: `supabase.from(`
   - À remplacer manuellement par les appels `api.*()` appropriés

## Notes Importantes

- **Upload de fichiers:** Tous les `supabase.storage` → `api.uploadFile()`
- **Authentification:** `supabase.auth` → `api.getCurrentUser()` ou `useAuth()`
- **Queries:** Adapter selon le pattern `api.getX()` ou `api.updateX()`

## Tester l'Admin Dashboard

Après adaptation:
1. Build: `npm run build`
2. Tester en local ou déployer
3. Se connecter avec: rikaconcept@gmail.com / AdminNow25#
4. Vérifier chaque onglet du dashboard

---

**Temps estimé:** 45-60 minutes pour adapter complètement AdminDashboard.tsx
