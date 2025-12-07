import { useCurrency } from '../contexts/CurrencyContext';
import { CURRENCIES } from '../lib/currency';
import { Globe } from 'lucide-react';

export default function CurrencySelector() {
  const { currency, setCurrency } = useCurrency();

  const popularCurrencies = ['EUR', 'USD', 'CAD', 'GBP', 'XOF', 'XAF', 'NGN', 'ZAR'];

  return (
    <div className="relative group">
      <button className="flex items-center gap-2 px-3 py-2 text-gray-700 hover:text-blue-600 transition-colors">
        <Globe className="w-5 h-5" />
        <span className="text-sm font-medium">{currency}</span>
      </button>

      <div className="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
        <div className="p-2">
          <p className="text-xs font-medium text-gray-500 px-2 py-1 mb-1">Devise</p>
          <div className="max-h-64 overflow-y-auto">
            {popularCurrencies.map((code) => {
              const curr = CURRENCIES[code];
              return (
                <button
                  key={code}
                  onClick={() => setCurrency(code)}
                  className={`w-full text-left px-3 py-2 rounded hover:bg-blue-50 transition-colors flex items-center justify-between ${
                    currency === code ? 'bg-blue-50 text-blue-600 font-medium' : 'text-gray-700'
                  }`}
                >
                  <span className="text-sm">{curr.name}</span>
                  <span className="text-sm font-medium">{curr.symbol}</span>
                </button>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
