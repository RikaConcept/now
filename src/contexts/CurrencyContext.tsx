import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import { CURRENCIES, CurrencyInfo } from '../lib/currency';

interface CurrencyContextType {
  currency: string;
  currencyInfo: CurrencyInfo;
  setCurrency: (currency: string) => void;
  loading: boolean;
}

const CurrencyContext = createContext<CurrencyContextType | undefined>(undefined);

export function CurrencyProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth();
  const [currency, setCurrencyState] = useState<string>('EUR');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadUserCurrency();
  }, [user]);

  const loadUserCurrency = async () => {
    setLoading(true);

    if (user) {
      try {
        const response = await api.getMember();
        if (response.success && response.data) {
          // For now, use EUR as default
          // TODO: Add currency detection based on locality/country
          setCurrencyState('EUR');
        }
      } catch (error) {
        console.error('Error loading currency:', error);
      }
    } else {
      const savedCurrency = localStorage.getItem('preferred_currency');
      if (savedCurrency && CURRENCIES[savedCurrency]) {
        setCurrencyState(savedCurrency);
      }
    }

    setLoading(false);
  };

  const setCurrency = (newCurrency: string) => {
    if (CURRENCIES[newCurrency]) {
      setCurrencyState(newCurrency);
      localStorage.setItem('preferred_currency', newCurrency);
    }
  };

  const currencyInfo = CURRENCIES[currency] || CURRENCIES.EUR;

  return (
    <CurrencyContext.Provider value={{ currency, currencyInfo, setCurrency, loading }}>
      {children}
    </CurrencyContext.Provider>
  );
}

export function useCurrency() {
  const context = useContext(CurrencyContext);
  if (context === undefined) {
    throw new Error('useCurrency must be used within a CurrencyProvider');
  }
  return context;
}
