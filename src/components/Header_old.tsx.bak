import { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import { Menu, X, User, LogOut, Settings } from 'lucide-react';

export default function Header() {
  const { user, signOut } = useAuth();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [subscriptionStatus, setSubscriptionStatus] = useState<string | null>(null);
  const location = useLocation();

  useEffect(() => {
    if (user) {
      loadSubscriptionStatus();
    }
  }, [user]);

  const loadSubscriptionStatus = async () => {
    try {
      const { data } = await supabase
        .from('stripe_user_subscriptions')
        .select('subscription_status')
        .maybeSingle();
      
      if (data?.subscription_status) {
        setSubscriptionStatus(data.subscription_status);
      }
    } catch (error) {
      console.error('Error loading subscription:', error);
    }
  };

  const handleSignOut = async () => {
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">
                {user.email}
                {subscriptionStatus && (
                  <span className="ml-2 px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">
                    {subscriptionStatus}
                  </span>
                )}
              </span>
              <div className="relative">
                <div className="px-4 py-2 border-b border-gray-200">
                  <p className="text-sm font-medium text-gray-900">{user.email}</p>
                  <p className="text-xs text-gray-500">Membre connecté</p>
                  {subscriptionStatus && (
                    <p className="text-xs text-green-600 mt-1">Plan: {subscriptionStatus}</p>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  };
}