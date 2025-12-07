import { useState } from 'react';
import { UserPlus, CheckCircle, XCircle, Loader2 } from 'lucide-react';

export default function CreateAdmin() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{ type: 'success' | 'error', message: string } | null>(null);

  const createAdmin = async () => {
    setLoading(true);
    setResult(null);

    try {
      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/create-admin`;

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
        },
      });

      const data = await response.json();

      if (!response.ok || !data.success) {
        throw new Error(data.error || data.message || 'Erreur lors de la création');
      }

      setResult({
        type: 'success',
        message: 'L\'administrateur a été créé avec succès ! Vous pouvez maintenant vous connecter.'
      });

    } catch (error: any) {
      console.error('Error:', error);

      if (error.message?.includes('existe déjà')) {
        setResult({
          type: 'error',
          message: 'Cet utilisateur existe déjà. Essayez de vous connecter sur /admin/login'
        });
      } else {
        setResult({
          type: 'error',
          message: error.message || 'Une erreur est survenue'
        });
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-slate-900 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mb-4">
            <UserPlus className="w-8 h-8 text-blue-600" />
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Créer l'administrateur
          </h1>
          <p className="text-gray-600">
            NOW!Lovers
          </p>
        </div>

        <div className="bg-blue-50 rounded-lg p-4 mb-6 border border-blue-200">
          <p className="text-sm font-medium text-gray-700 mb-2">
            Configuration par défaut :
          </p>
          <div className="text-xs text-gray-600 space-y-1">
            <p><strong>Email:</strong> <code className="bg-white px-2 py-1 rounded">admin@nowlovers.com</code></p>
            <p><strong>Password:</strong> <code className="bg-white px-2 py-1 rounded">NOW!Lovers2025Secure</code></p>
          </div>
        </div>

        {result && (
          <div className={`rounded-lg p-4 mb-6 flex items-start gap-3 ${
            result.type === 'success'
              ? 'bg-green-50 border border-green-200'
              : 'bg-red-50 border border-red-200'
          }`}>
            {result.type === 'success' ? (
              <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
            ) : (
              <XCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
            )}
            <p className={`text-sm ${
              result.type === 'success' ? 'text-green-800' : 'text-red-800'
            }`}>
              {result.message}
            </p>
          </div>
        )}

        <button
          onClick={createAdmin}
          disabled={loading || result?.type === 'success'}
          className="w-full bg-blue-600 text-white py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          {loading ? (
            <>
              <Loader2 className="w-5 h-5 animate-spin" />
              Création en cours...
            </>
          ) : result?.type === 'success' ? (
            <>
              <CheckCircle className="w-5 h-5" />
              Admin créé avec succès
            </>
          ) : (
            <>
              <UserPlus className="w-5 h-5" />
              Créer l'administrateur
            </>
          )}
        </button>

        {result?.type === 'success' && (
          <div className="mt-6 text-center">
            <a
              href="/admin/login"
              className="text-blue-600 hover:text-blue-700 font-medium inline-flex items-center gap-2"
            >
              Se connecter maintenant →
            </a>
          </div>
        )}

        <div className="mt-6 text-center">
          <a href="/" className="text-sm text-gray-600 hover:text-gray-700">
            ← Retour à l'accueil
          </a>
        </div>
      </div>
    </div>
  );
}
