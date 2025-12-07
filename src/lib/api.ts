// API Service for Nowlover
// Replaces Supabase client with custom REST API

const API_URL = import.meta.env.VITE_API_URL || 'https://arnowconcept.com/api';

class ApiService {
  constructor() {
    this.token = localStorage.getItem('auth_token');
  }

  setToken(token: string) {
    this.token = token;
    localStorage.setItem('auth_token', token);
  }

  clearToken() {
    this.token = null;
    localStorage.removeItem('auth_token');
  }

  getHeaders(includeAuth = true) {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };

    if (includeAuth && this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }

    return headers;
  }

  async request(endpoint: string, options: RequestInit = {}) {
    const url = `${API_URL}${endpoint}`;
    
    const config: RequestInit = {
      ...options,
      headers: {
        ...this.getHeaders(options.headers?.['Authorization'] !== 'skip'),
        ...options.headers,
      },
    };

    // Remove the skip marker if present
    if (config.headers?.['Authorization'] === 'skip') {
      delete config.headers['Authorization'];
    }

    try {
      const response = await fetch(url, config);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Request failed');
      }

      return data;
    } catch (error) {
      console.error('API request error:', error);
      throw error;
    }
  }

  // Auth endpoints
  async register(email: string, password: string, phone?: string, localityId?: string) {
    const response = await this.request('/auth/register', {
      method: 'POST',
      headers: { 'Authorization': 'skip' },
      body: JSON.stringify({ email, password, phone, locality_id: localityId }),
    });

    if (response.success && response.data.token) {
      this.setToken(response.data.token);
    }

    return response;
  }

  async login(email: string, password: string) {
    const response = await this.request('/auth/login', {
      method: 'POST',
      headers: { 'Authorization': 'skip' },
      body: JSON.stringify({ email, password }),
    });

    if (response.success && response.data.token) {
      this.setToken(response.data.token);
    }

    return response;
  }

  async logout() {
    this.clearToken();
  }

  async getCurrentUser() {
    return this.request('/auth/user');
  }

  // Members
  async getMember() {
    return this.request('/members');
  }

  async getMemberByCode(code: string) {
    return this.request(`/members?action=by-code&code=${code}`);
  }

  async updateMember(data: any) {
    return this.request('/members', {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  // Products
  async getProducts(category?: string) {
    const query = category ? `?category=${category}` : '';
    return this.request(`/products${query}`);
  }

  async getProduct(id: string) {
    return this.request(`/products?id=${id}`);
  }

  async createProduct(data: any) {
    return this.request('/products', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async updateProduct(id: string, data: any) {
    return this.request(`/products?id=${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async deleteProduct(id: string) {
    return this.request(`/products?id=${id}`, {
      method: 'DELETE',
    });
  }

  // Orders
  async getOrders() {
    return this.request('/orders');
  }

  async getOrder(id: string) {
    return this.request(`/orders?action=single&id=${id}`);
  }

  async createOrder(amount: number, paymentMethod?: string) {
    return this.request('/orders', {
      method: 'POST',
      body: JSON.stringify({ amount, payment_method: paymentMethod }),
    });
  }

  async updateOrderStatus(id: string, status: string) {
    return this.request(`/orders?id=${id}`, {
      method: 'PUT',
      body: JSON.stringify({ status }),
    });
  }

  // Localities
  async getLocalities() {
    return this.request('/localities');
  }

  // Membership Levels
  async getMembershipLevels() {
    return this.request('/membership-levels');
  }

  // Partner Shops
  async getPartnerShops() {
    return this.request('/partner-shops');
  }

  // Product Requests
  async createProductRequest(data: any) {
    return this.request('/product-requests', {
      method: 'POST',
      headers: data.anonymous ? { 'Authorization': 'skip' } : {},
      body: JSON.stringify(data),
    });
  }

  async getProductRequests() {
    return this.request('/product-requests');
  }

  async updateProductRequest(id: string, status: string) {
    return this.request(`/product-requests?id=${id}`, {
      method: 'PUT',
      body: JSON.stringify({ status }),
    });
  }

  // Admin
  async getAdminStats() {
    return this.request('/admin?action=stats');
  }

  async getAllMembers(params?: { status?: string; search?: string; limit?: number; offset?: number }) {
    const query = new URLSearchParams({ action: 'members', ...params as any }).toString();
    return this.request(`/admin?${query}`);
  }

  async getAllOrders(params?: { limit?: number; offset?: number }) {
    const query = new URLSearchParams({ action: 'orders', ...params as any }).toString();
    return this.request(`/admin?${query}`);
  }

  async getAdminProductRequests(params?: { status?: string; limit?: number; offset?: number }) {
    const query = new URLSearchParams({ action: 'product-requests', ...params as any }).toString();
    return this.request(`/admin?${query}`);
  }

  // Countries
  async getCountries() {
    return this.request('/countries');
  }

  // Site Settings
  async getSiteSettings() {
    return this.request('/site-settings');
  }

  async updateSiteSettings(settings: Record<string, any>) {
    return this.request('/site-settings', {
      method: 'POST',
      body: JSON.stringify(settings),
    });
  }

  // File Upload
  async uploadFile(file: File) {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_URL}/upload`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
      },
      body: formData,
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message || 'Upload failed');
    }

    return data;
  }
}

export const api = new ApiService();
export default api;
