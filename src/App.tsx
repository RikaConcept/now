import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { CurrencyProvider } from './contexts/CurrencyContext';
import GenerateCode from './pages/GenerateCode';
import Login from './pages/Login';
import Signup from './pages/Signup';
import Catalog from './pages/Catalog';
import Cart from './pages/Cart';
import ProductRequest from './pages/ProductRequest';
import CheckoutSuccess from './pages/CheckoutSuccess';
import Dashboard from './pages/Dashboard';
import AdminDashboard from './pages/AdminDashboard';
import Products from './pages/Products';
import Success from './pages/Success';
import AdminLogin from './pages/AdminLogin';
import CreateAdmin from './pages/CreateAdmin';
import Navigation from './components/Navigation';
import Home from './pages/Home';
import Shop from './pages/Shop';
import Partners from './pages/Partners';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();

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

  if (!user) {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
}

function App() {
  return (
    <AuthProvider>
      <CurrencyProvider>
        <Router>
          <div className="min-h-screen bg-gray-50">
            <Navigation />
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/shop" element={<Shop />} />
              <Route path="/generate-code" element={<GenerateCode />} />
              <Route path="/login" element={<Login />} />
              <Route path="/signup" element={<Signup />} />
              <Route path="/catalog" element={<Catalog />} />
              <Route path="/partners" element={<Partners />} />
              <Route path="/products" element={<Catalog />} />
              <Route path="/cart" element={<Cart />} />
              <Route path="/product-request" element={<ProductRequest />} />
              <Route path="/checkout/success" element={<CheckoutSuccess />} />
              <Route path="/success" element={<Success />} />
              <Route path="/admin/create" element={<CreateAdmin />} />
              <Route path="/admin/login" element={<AdminLogin />} />
              <Route
                path="/dashboard"
                element={
                  <ProtectedRoute>
                    <Dashboard />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/admin"
                element={
                  <ProtectedRoute>
                    <AdminDashboard />
                  </ProtectedRoute>
                }
              />
            </Routes>
          </div>
        </Router>
      </CurrencyProvider>
    </AuthProvider>
  );
}

export default App;