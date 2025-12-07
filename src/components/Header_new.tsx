import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Menu, X, User, LogOut, Settings } from 'lucide-react';

export default function Header() {
  const { user, signOut } = useAuth();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();

  const handleSignOut = async () => {
    await signOut();
    window.location.href = '/';
  };

  return (
    <header className="bg-white shadow-sm border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link to="/" className="text-2xl font-bold text-blue-600">
            NOW!Lovers
          </Link>

          {/* Desktop Menu */}
          <nav className="hidden md:flex items-center gap-6">
            <Link
              to="/"
              className={`text-gray-700 hover:text-blue-600 font-medium ${
                location.pathname === '/' ? 'text-blue-600' : ''
              }`}
            >
              Accueil
            </Link>
            <Link
              to="/catalog"
              className={`text-gray-700 hover:text-blue-600 font-medium ${
                location.pathname === '/catalog' ? 'text-blue-600' : ''
              }`}
            >
              Catalogue
            </Link>
            <Link
              to="/partners"
              className={`text-gray-700 hover:text-blue-600 font-medium ${
                location.pathname === '/partners' ? 'text-blue-600' : ''
              }`}
            >
              Partenaires
            </Link>

            {user ? (
              <>
                <Link
                  to="/dashboard"
                  className={`text-gray-700 hover:text-blue-600 font-medium ${
                    location.pathname === '/dashboard' ? 'text-blue-600' : ''
                  }`}
                >
                  Dashboard
                </Link>
                <button
                  onClick={handleSignOut}
                  className="flex items-center gap-2 text-gray-700 hover:text-red-600"
                >
                  <LogOut className="w-4 h-4" />
                  D\u00e9connexion
                </button>
              </>
            ) : (
              <>
                <Link
                  to="/login"
                  className="text-gray-700 hover:text-blue-600 font-medium"
                >
                  Connexion
                </Link>
                <Link
                  to="/generate-code"
                  className="bg-blue-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-700 transition-colors"
                >
                  G\u00e9n\u00e9rer mon code
                </Link>
              </>
            )}
          </nav>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="md:hidden p-2"
          >
            {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <nav className="md:hidden mt-4 pb-4 space-y-2">
            <Link
              to="/"
              className="block py-2 text-gray-700 hover:text-blue-600 font-medium"
              onClick={() => setIsMenuOpen(false)}
            >
              Accueil
            </Link>
            <Link
              to="/catalog"
              className="block py-2 text-gray-700 hover:text-blue-600 font-medium"
              onClick={() => setIsMenuOpen(false)}
            >
              Catalogue
            </Link>
            <Link
              to="/partners"
              className="block py-2 text-gray-700 hover:text-blue-600 font-medium"
              onClick={() => setIsMenuOpen(false)}
            >
              Partenaires
            </Link>

            {user ? (
              <>
                <Link
                  to="/dashboard"
                  className="block py-2 text-gray-700 hover:text-blue-600 font-medium"
                  onClick={() => setIsMenuOpen(false)}
                >
                  Dashboard
                </Link>
                <button
                  onClick={() => {
                    handleSignOut();
                    setIsMenuOpen(false);
                  }}
                  className="block py-2 text-gray-700 hover:text-red-600 font-medium w-full text-left"
                >
                  D\u00e9connexion
                </button>
              </>
            ) : (
              <>
                <Link
                  to="/login"
                  className="block py-2 text-gray-700 hover:text-blue-600 font-medium"
                  onClick={() => setIsMenuOpen(false)}
                >
                  Connexion
                </Link>
                <Link
                  to="/generate-code"
                  className="block py-2 bg-blue-600 text-white px-4 rounded-lg font-medium hover:bg-blue-700 text-center"
                  onClick={() => setIsMenuOpen(false)}
                >
                  G\u00e9n\u00e9rer mon code
                </Link>
              </>
            )}
          </nav>
        )}
      </div>
    </header>
  );
}
