import { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { Crown, AlertCircle } from 'lucide-react';

export default function SubscriptionStatus() {
  const { user } = useAuth();
  const [subscription, setSubscription] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadSubscription();
    }
  }, [user]);

  const loadSubscription = async () => {
    try {
      // TODO: Implement subscription API if needed
      // For now, skip subscription status
      setSubscription(null);
    } catch (error) {
      console.error('Error loading subscription:', error);
    } finally {
      setLoading(false);
    }
  };

  // Skip rendering subscription status for now
  return null;
}