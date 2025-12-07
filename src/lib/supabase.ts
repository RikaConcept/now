import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Database = {
  public: {
    Tables: {
      localities: {
        Row: {
          id: string;
          name: string;
          code_prefix: string;
          member_count: number;
          created_at: string;
        };
      };
      members: {
        Row: {
          id: string;
          email: string;
          phone: string | null;
          locality_id: string | null;
          code: string;
          status: 'pending' | 'active' | 'inactive';
          activated_at: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          phone?: string | null;
          locality_id?: string | null;
          code: string;
          status?: 'pending' | 'active' | 'inactive';
        };
      };
      partner_shops: {
        Row: {
          id: string;
          name: string;
          category: string;
          description: string | null;
          discount_percentage: number;
          address: string | null;
          is_active: boolean;
          created_at: string;
        };
      };
      orders: {
        Row: {
          id: string;
          member_id: string;
          amount: number;
          status: 'pending' | 'paid' | 'cancelled';
          payment_method: string | null;
          created_at: string;
          paid_at: string | null;
        };
        Insert: {
          member_id: string;
          amount: number;
          status?: 'pending' | 'paid' | 'cancelled';
          payment_method?: string | null;
        };
      };
      product_requests: {
        Row: {
          id: string;
          user_id: string | null;
          email: string;
          phone: string | null;
          product_name: string;
          best_price_found: number;
          price_source: string;
          user_budget: number;
          is_member: boolean;
          status: 'pending' | 'processing' | 'completed' | 'cancelled';
          margin_donation: number | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          user_id?: string | null;
          email: string;
          phone?: string | null;
          product_name: string;
          best_price_found: number;
          price_source: string;
          user_budget: number;
          is_member?: boolean;
          margin_donation?: number | null;
        };
      };
    };
  };
};
