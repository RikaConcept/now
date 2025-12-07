export interface CurrencyInfo {
  code: string;
  symbol: string;
  name: string;
  rate: number;
}

export const CURRENCIES: Record<string, CurrencyInfo> = {
  EUR: { code: 'EUR', symbol: '€', name: 'Euro', rate: 1 },
  USD: { code: 'USD', symbol: '$', name: 'US Dollar', rate: 1.09 },
  CAD: { code: 'CAD', symbol: 'C$', name: 'Canadian Dollar', rate: 1.48 },
  GBP: { code: 'GBP', symbol: '£', name: 'British Pound', rate: 0.86 },
  XOF: { code: 'XOF', symbol: 'CFA', name: 'West African CFA Franc', rate: 655.96 },
  XAF: { code: 'XAF', symbol: 'FCFA', name: 'Central African CFA Franc', rate: 655.96 },
  NGN: { code: 'NGN', symbol: '₦', name: 'Nigerian Naira', rate: 1680.50 },
  GHS: { code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi', rate: 16.85 },
  KES: { code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling', rate: 141.50 },
  ZAR: { code: 'ZAR', symbol: 'R', name: 'South African Rand', rate: 19.85 },
  CDF: { code: 'CDF', symbol: 'FC', name: 'Congolese Franc', rate: 2850.00 },
  BRL: { code: 'BRL', symbol: 'R$', name: 'Brazilian Real', rate: 5.32 },
  MXN: { code: 'MXN', symbol: 'MX$', name: 'Mexican Peso', rate: 18.65 },
  ARS: { code: 'ARS', symbol: 'AR$', name: 'Argentine Peso', rate: 1015.50 },
};

export function convertPrice(amount: number, fromCurrency: string, toCurrency: string): number {
  if (fromCurrency === toCurrency) return amount;

  const fromRate = CURRENCIES[fromCurrency]?.rate || 1;
  const toRate = CURRENCIES[toCurrency]?.rate || 1;

  const euroAmount = amount / fromRate;
  const convertedAmount = euroAmount * toRate;

  return convertedAmount;
}

export function formatPrice(amount: number, currencyCode: string): string {
  const currency = CURRENCIES[currencyCode] || CURRENCIES.EUR;

  if (['XOF', 'XAF', 'CDF', 'NGN', 'KES'].includes(currencyCode)) {
    return `${Math.round(amount).toLocaleString('fr-FR')} ${currency.symbol}`;
  }

  return `${amount.toFixed(2)} ${currency.symbol}`;
}

export function getCurrencySymbol(currencyCode: string): string {
  return CURRENCIES[currencyCode]?.symbol || '€';
}
