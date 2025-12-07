import { useState, useRef, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useCartStore } from '../lib/cartStore';
import { Link, useLocation } from 'react-router-dom';
import { Home, ShoppingCart, Package, LayoutDashboard, LogIn, Store, User, LogOut, ChevronDown } from 'lucide-react';
import CurrencySelector from './CurrencySelector';

export default function Navigation() {
  const { user, signOut } = useAuth();
  const { getTotalItems } = useCartStore();
  const location = useLocation();
  const cartItemCount = getTotalItems();
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSignOut = async () => {
    await signOut();
    setDropdownOpen(false);
  };

  if (location.pathname === '/dashboard' || location.pathname === '/admin' || location.pathname === '/admin/login' || location.pathname === '/login') {
    return null;
  }

  const links = [
    { path: '/', label: 'Accueil', icon: Home },
    { path: '/catalog', label: 'Produits', icon: Store },
    { path: '/partners', label: 'Partenaires', icon: Store },
    { path: '/product-request', label: 'Demander un produit', icon: Package },
  ];

  if (!user) {
    links.push({ path: '/login', label: 'Connexion', icon: LogIn });
  }

  return (
    <nav className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          <Link to="/" className="text-2xl font-bold text-blue-600">
            NOW!
          </Link>

          <div className="flex items-center gap-1">
            <CurrencySelector />
            <div className="w-px h-6 bg-gray-300 mx-2"></div>
            {links.map((link) => {
              const Icon = link.icon;
              const isActive = location.pathname === link.path;
              return (
                <Link
                  key={link.path}
                  to={link.path}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                    isActive
                      ? 'bg-blue-50 text-blue-600 font-medium'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  <span className="hidden sm:inline">{link.label}</span>
                </Link>
              );
            })}
            {user && (
              <>
                <div className="w-px h-6 bg-gray-300 mx-2"></div>
                <div className="relative" ref={dropdownRef}>
                  <button
                    onClick={() => setDropdownOpen(!dropdownOpen)}
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                      location.pathname === '/dashboard'
                        ? 'bg-blue-50 text-blue-600 font-medium'
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    }`}
                  >
                    <LayoutDashboard className="w-4 h-4" />
                    <span className="hidden sm:inline">Mon espace</span>
                    <ChevronDown className={`w-4 h-4 transition-transform ${dropdownOpen ? 'rotate-180' : ''}`} />
                  </button>
                  {dropdownOpen && (
                    <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                      <Link
                        to="/dashboard"
                        onClick={() => setDropdownOpen(false)}
                        className="block px-4 py-2 text-gray-700 hover:bg-gray-50 transition-colors"
                      >
                        <div className="flex items-center gap-2">
                          <LayoutDashboard className="w-4 h-4" />
                          <span>Mon tableau de bord</span>
                        </div>
                      </Link>
                      <div className="border-t border-gray-200 my-2"></div>
                      <div className="px-4 py-2 text-sm text-gray-500">
                        <div className="flex items-center gap-2">
                          <User className="w-4 h-4" />
                          <span className="truncate">{user.email}</span>
                        </div>
                      </div>
                      <div className="border-t border-gray-200 my-2"></div>
                      <button
                        onClick={handleSignOut}
                        className="w-full text-left px-4 py-2 text-red-600 hover:bg-red-50 transition-colors flex items-center gap-2"
                      >
                        <LogOut className="w-4 h-4" />
                        <span>Déconnexion</span>
                      </button>
                    </div>
                  )}
                </div>
              </>
            )}
            <div className="w-px h-6 bg-gray-300 mx-2"></div>
            <Link
              to="/cart"
              className="relative p-2 text-gray-600 hover:text-blue-600 transition-colors"
            >
              <ShoppingCart className="w-6 h-6" />
              {cartItemCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-blue-600 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center">
                  {cartItemCount}
                </span>
              )}
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
}
