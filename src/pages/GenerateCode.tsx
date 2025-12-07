import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';
import { MapPin, Loader2, CheckCircle, Globe, Phone } from 'lucide-react';

interface Country {
  id: string;
  name: string;
  code: string;
  phone_prefix: string;
  phone_format: string;
}

interface Locality {
  id: string;
  name: string;
  code_prefix: string;
  member_count: number;
  country_id: string;
}

export default function GenerateCode() {
  const { user, signUp, signIn } = useAuth();
  const navigate = useNavigate();
  const [countries, setCountries] = useState<Country[]>([]);
  const [localities, setLocalities] = useState<Locality[]>([]);
  const [filteredLocalities, setFilteredLocalities] = useState<Locality[]>([]);
  const [selectedCountry, setSelectedCountry] = useState<string>('');
  const [selectedLocality, setSelectedLocality] = useState<string>('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('');
  const [loading, setLoading] = useState(false);
  const [generatedCode, setGeneratedCode] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadCountriesAndLocalities();
  }, []);

  useEffect(() => {
    if (selectedCountry) {
      const filtered = localities.filter(l => l.country_id === selectedCountry);
      setFilteredLocalities(filtered);
      if (filtered.length > 0) {
        setSelectedLocality(filtered[0].id);
      }
    }
  }, [selectedCountry, localities]);

  const loadCountriesAndLocalities = async () => {
    const { data: countriesData } = await supabase
      .from('countries')
      .select('*')
      .order('name');

    const { data: localitiesData } = await supabase
      .from('localities')
      .select('*')
      .order('name');

    if (countriesData) {
      setCountries(countriesData);
      if (countriesData.length > 0) {
        setSelectedCountry(countriesData[0].id);
      }
    }

    if (localitiesData) {
      setLocalities(localitiesData);
    }
  };

  const getSelectedCountry = () => {
    return countries.find(c => c.id === selectedCountry);
  };

  const generateMemberCode = async () => {
    setLoading(true);
    setError(null);

    try {
      let userId = user?.id;

      if (!user) {
        const { error: signUpError } = await signUp(email, password);
        if (signUpError) {
          setError(signUpError.message);
          setLoading(false);
          return;
        }
        const { data: { user: newUser } } = await supabase.auth.getUser();
        userId = newUser?.id;
      }

      if (!userId) {
        setError('Erreur d\'authentification');
        setLoading(false);
        return;
      }

      const { data: existingMember } = await supabase
        .from('members')
        .select('code')
        .eq('id', userId)
        .maybeSingle();

      if (existingMember) {
        setGeneratedCode(existingMember.code);
        setLoading(false);
        return;
      }

      const locality = localities.find(l => l.id === selectedLocality);
      if (!locality) {
        setError('Veuillez sélectionner une localité');
        setLoading(false);
        return;
      }

      const newMemberCount = locality.member_count + 1;
      const code = `${locality.code_prefix}-${String(newMemberCount).padStart(6, '0')}`;

      const { error: memberError } = await supabase
        .from('members')
        .insert({
          id: userId,
          email: email || user?.email || '',
          phone,
          locality_id: selectedLocality,
          code,
          status: 'pending'
        });

      if (memberError) {
        setError(memberError.message);
        setLoading(false);
        return;
      }

      await supabase
        .from('localities')
        .update({ member_count: newMemberCount })
        .eq('id', selectedLocality);

      const shopUrl = `${window.location.origin}/shop`;

      await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-notification`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: email || user?.email,
          phone,
          type: 'code_generated',
          data: {
            code,
            locality: locality.name,
            advantages: [
              'Réductions exclusives dans nos boutiques partenaires',
              'Demandes de produits sans commission',
              'Accès prioritaire aux nouvelles offres'
            ],
            shopUrl
          }
        })
      });

      setGeneratedCode(code);

      setTimeout(() => {
        navigate('/shop');
      }, 3000);

    } catch (err) {
      setError('Une erreur est survenue');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (generatedCode) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
          <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Code généré avec succès !</h2>
          <div className="bg-blue-50 rounded-lg p-6 my-6">
            <p className="text-sm text-gray-600 mb-2">Votre code NOW!Lovers</p>
            <p className="text-3xl font-bold text-blue-600">{generatedCode}</p>
          </div>
          <p className="text-gray-600 mb-4">
            Un email et/ou un message WhatsApp vous a été envoyé avec tous les détails.
          </p>
          <p className="text-sm text-gray-500">
            Redirection vers la boutique dans quelques secondes...
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full">
        <h1 className="text-3xl font-bold text-gray-900 mb-2 text-center">
          Rejoignez NOW!Lovers
        </h1>
        <p className="text-gray-600 text-center mb-6">
          Générez votre code membre et profitez d'avantages exclusifs
        </p>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4">
            {error}
          </div>
        )}

        <div className="space-y-4">
          {!user && (
            <>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Mot de passe
                </label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                  minLength={6}
                />
                <p className="text-xs text-gray-500 mt-1">
                  Minimum 6 caractères
                </p>
              </div>
            </>
          )}

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              <Globe className="inline w-4 h-4 mr-1" />
              Pays
            </label>
            <select
              value={selectedCountry}
              onChange={(e) => setSelectedCountry(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {countries.map((country) => (
                <option key={country.id} value={country.id}>
                  {country.name}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              <MapPin className="inline w-4 h-4 mr-1" />
              Ville / Localité
            </label>
            <select
              value={selectedLocality}
              onChange={(e) => setSelectedLocality(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {filteredLocalities.map((locality) => (
                <option key={locality.id} value={locality.id}>
                  {locality.name}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              <Phone className="inline w-4 h-4 mr-1" />
              Téléphone (optionnel)
            </label>
            <div className="relative">
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder={getSelectedCountry()?.phone_format || "+XX XXX XXX XXX"}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              {getSelectedCountry() && (
                <span className="absolute right-3 top-1/2 -translate-y-1/2 text-sm text-gray-500">
                  {getSelectedCountry()?.phone_prefix}
                </span>
              )}
            </div>
            <p className="text-xs text-gray-500 mt-1">
              Format: {getSelectedCountry()?.phone_format || "Format international"}
            </p>
          </div>

          <button
            onClick={generateMemberCode}
            disabled={loading}
            className="w-full bg-blue-600 text-white py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            {loading ? (
              <>
                <Loader2 className="w-5 h-5 animate-spin" />
                Génération en cours...
              </>
            ) : (
              'Générer mon code NOW!Lovers'
            )}
          </button>
        </div>

        <div className="mt-6 p-4 bg-blue-50 rounded-lg">
          <h3 className="font-medium text-gray-900 mb-2">Vos avantages :</h3>
          <ul className="text-sm text-gray-600 space-y-1">
            <li>✓ Réductions exclusives chez nos partenaires</li>
            <li>✓ Demandes de produits sans commission</li>
            <li>✓ Accès prioritaire aux offres</li>
          </ul>
        </div>

        <div className="mt-4 text-center">
          <p className="text-sm text-gray-600">
            Déjà NOW!Lovers ?{' '}
            <button
              onClick={() => navigate('/login')}
              className="text-blue-600 hover:text-blue-700 font-medium"
            >
              Se connecter
            </button>
          </p>
        </div>
      </div>
    </div>
  );
}
