import { createContext, useContext, useEffect, useState } from 'react';
import { api } from '../lib/api';

interface User {
  id: string;
  email: string;
  is_admin?: boolean;
}

interface Session {
  user: User;
  token: string;
}

interface AuthContextType {
  user: User | null;
  session: Session | null;
  loading: boolean;
  signUp: (email: string, password: string, phone?: string, localityId?: string) => Promise<{ error: any }>;
  signIn: (email: string, password: string) => Promise<{ error: any }>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if token exists and get user info
    const token = localStorage.getItem('auth_token');
    
    if (token) {
      api.getCurrentUser()
        .then((response) => {
          if (response.success && response.data.user) {
            setUser(response.data.user);
            setSession({
              user: response.data.user,
              token,
            });
          }
        })
        .catch(() => {
          // Token invalid, clear it
          api.clearToken();
        })
        .finally(() => {
          setLoading(false);
        });
    } else {
      setLoading(false);
    }
  }, []);

  const signUp = async (email: string, password: string, phone?: string, localityId?: string) => {
    try {
      const response = await api.register(email, password, phone, localityId);
      
      if (response.success && response.data.user) {
        const userData = response.data.user;
        setUser(userData);
        setSession({
          user: userData,
          token: response.data.token,
        });
        return { error: null };
      }
      
      return { error: { message: response.message || 'Registration failed' } };
    } catch (error: any) {
      return { error: { message: error.message || 'Registration failed' } };
    }
  };

  const signIn = async (email: string, password: string) => {
    try {
      const response = await api.login(email, password);
      
      if (response.success && response.data.user) {
        const userData = response.data.user;
        setUser(userData);
        setSession({
          user: userData,
          token: response.data.token,
        });
        return { error: null };
      }
      
      return { error: { message: response.message || 'Login failed' } };
    } catch (error: any) {
      return { error: { message: error.message || 'Login failed' } };
    }
  };

  const signOut = async () => {
    await api.logout();
    setUser(null);
    setSession(null);
  };

  const value = {
    user,
    session,
    loading,
    signUp,
    signIn,
    signOut,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}