# Checklist de migration du Frontend

Cette checklist vous guide pour adapter tous les fichiers frontend qui utilisent Supabase vers la nouvelle API REST.

## ✅ Fichiers déjà migrés

- [x] `/src/lib/api.ts` - Nouveau service API créé
- [x] `/src/contexts/AuthContext.tsx` - Authentification JWT
- [x] `/package.json` - Dépendance Supabase retirée
- [x] `/.env.production` - URL API configurée

## 🔄 Fichiers à adapter

### Priorité HAUTE - Critiques

#### 1. `/src/pages/Login.tsx`
```typescript
// AVANT
import { supabase } from '../lib/supabase';
const { error } = await supabase.auth.signInWithPassword({ email, password });

// APRÈS  
import { api } from '../lib/api';
const { error } = await api.login(email, password);
```

#### 2. `/src/pages/Signup.tsx`
```typescript
// AVANT
const { error } = await supabase.auth.signUp({ email, password });

// APRÈS
const { error } = await api.register(email, password, phone, localityId);
```

#### 3. `/src/pages/AdminLogin.tsx`
Même changement que Login.tsx

#### 4. `/src/pages/Dashboard.tsx`
```typescript
// AVANT
const { data: member } = await supabase
  .from('members')
  .select('*, localities(*), membership_levels(*)')
  .eq('id', user.id)
  .single();

// APRÈS
const response = await api.getMember();
const member = response.data;
```

#### 5. `/src/pages/AdminDashboard.tsx`
```typescript
// AVANT
const { data: members } = await supabase
  .from('members')
  .select('*')
  .order('created_at', { ascending: false });

// APRÈS
const response = await api.getAllMembers({ limit: 100 });
const members = response.data;
```

### Priorité MOYENNE - Fonctionnalités principales

#### 6. `/src/pages/Catalog.tsx` ou `/src/pages/Products.tsx`
```typescript
// AVANT
const { data: products } = await supabase
  .from('products')
  .select('*')
  .eq('is_active', true);

// APRÈS
const response = await api.getProducts();
const products = response.data;
```

#### 7. `/src/pages/Cart.tsx`
```typescript
// AVANT - Création de commande
const { data: order } = await supabase
  .from('orders')
  .insert({ member_id: user.id, amount: total })
  .select()
  .single();

// APRÈS
const response = await api.createOrder(total, 'paypal');
const order = response.data;
```

#### 8. `/src/pages/ProductRequest.tsx`
```typescript
// AVANT
const { error } = await supabase
  .from('product_requests')
  .insert({
    email,
    product_name,
    best_price_found,
    price_source,
    user_budget,
    is_member
  });

// APRÈS
const response = await api.createProductRequest({
  email,
  product_name,
  best_price_found,
  price_source,
  user_budget,
  is_member
});
```

#### 9. `/src/pages/Partners.tsx`
```typescript
// AVANT
const { data: shops } = await supabase
  .from('partner_shops')
  .select('*')
  .eq('is_active', true);

// APRÈS
const response = await api.getPartnerShops();
const shops = response.data;
```

### Priorité BASSE - Fonctionnalités secondaires

#### 10. `/src/pages/GenerateCode.tsx`
Si ce fichier gère la génération de codes, adaptez:
```typescript
// Utiliser api.getMember() pour récupérer le code du membre
```

#### 11. `/src/pages/Success.tsx` et `/src/pages/CheckoutSuccess.tsx`
Vérifier le statut des commandes via:
```typescript
const response = await api.getOrders();
```

#### 12. `/src/pages/SiteSettings.tsx`
```typescript
// AVANT
const { data: settings } = await supabase
  .from('site_settings')
  .select('*');

// APRÈS
const response = await api.getSiteSettings();
const settings = response.data;

// Pour mise à jour
await api.updateSiteSettings({ key: value });
```

### Composants à vérifier

#### 13. `/src/components/Navigation.tsx`
Vérifier l'utilisation de `useAuth()` - devrait fonctionner automatiquement

#### 14. Tout composant utilisant `supabase.storage`
Pour l'upload d'images:
```typescript
// AVANT
const { data, error } = await supabase.storage
  .from('bucket')
  .upload('path', file);

// APRÈS
const response = await api.uploadFile(file);
const url = response.data.url;
```

## 🔍 Comment trouver les fichiers à modifier

```bash
# Rechercher tous les imports de supabase
grep -r "from '../lib/supabase'" src/

# Rechercher toutes les utilisations de supabase
grep -r "supabase\." src/

# Rechercher les appels auth
grep -r "supabase.auth" src/

# Rechercher les requêtes from
grep -r "\.from\(" src/
```

## 📝 Pattern de migration

Pour chaque fichier:

1. **Supprimer l'import Supabase:**
   ```typescript
   // Supprimer
   import { supabase } from '../lib/supabase';
   ```

2. **Ajouter l'import API:**
   ```typescript
   // Ajouter
   import { api } from '../lib/api';
   ```

3. **Remplacer les appels:**
   - `supabase.auth.*` → `api.login/register/logout/getCurrentUser()`
   - `supabase.from('table').select()` → `api.getTable()`
   - `supabase.from('table').insert()` → `api.createTable()`
   - `supabase.from('table').update()` → `api.updateTable()`
   - `supabase.from('table').delete()` → `api.deleteTable()`

4. **Adapter la gestion des réponses:**
   ```typescript
   // AVANT
   const { data, error } = await supabase.from('table').select();
   if (error) throw error;
   
   // APRÈS
   const response = await api.getTable();
   if (response.success) {
     const data = response.data;
   }
   ```

## 🧪 Tester chaque page

Après modification:
1. ✅ La page se charge sans erreur
2. ✅ Les données s'affichent correctement
3. ✅ Les actions (créer, modifier, supprimer) fonctionnent
4. ✅ Les erreurs sont gérées proprement
5. ✅ La navigation fonctionne

## ⚠️ Points d'attention

### Gestion des erreurs
```typescript
// AVANT - Supabase
const { data, error } = await supabase.from('table').select();
if (error) {
  // Gérer erreur
}

// APRÈS - API
try {
  const response = await api.getTable();
  if (response.success) {
    const data = response.data;
  } else {
    // Gérer erreur via response.message
  }
} catch (error) {
  // Gérer erreur réseau
}
```

### Types TypeScript
Si vous utilisez des types Supabase générés:
```typescript
// AVANT
import { Database } from '../lib/supabase';
type Member = Database['public']['Tables']['members']['Row'];

// APRÈS - Créer vos propres types
interface Member {
  id: string;
  email: string;
  code: string;
  status: 'pending' | 'active' | 'inactive';
  // ... autres champs
}
```

### Subscriptions en temps réel
Si vous utilisez `supabase.from('table').on('*')`:
- ⚠️ Cette fonctionnalité n'est plus disponible avec REST API
- Alternative: Polling périodique ou WebSockets personnalisés
- Pour l'instant: Refresh manuel

## 📊 Progression

Utilisez cette checklist pour suivre votre progression:

```
Fichiers migrés: ____ / ____
Tests réussis: ____ / ____
Pages fonctionnelles: ____ / ____
```

## 🎯 Objectif final

Aucune référence à `supabase` ne doit rester dans le code:

```bash
# Vérification finale
grep -r "supabase" src/

# Devrait retourner: (aucun résultat)
```

## 🚀 Après la migration

1. Tester l'application localement
2. Tester en staging si possible  
3. Build de production: `npm run build`
4. Déployer sur Infomaniak
5. Tests end-to-end en production

---

**Besoin d'aide?** Consultez [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) pour plus de détails.
