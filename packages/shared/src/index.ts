// Shared types and utilities for Mipets

export interface Pet {
  id: string;
  name: string;
  species: "dog" | "cat" | "bird" | "rabbit" | "other";
  breed?: string;
  age?: number;
  weight?: number;
  dietNotes?: string;
  healthNotes?: string;
  photoUrl?: string;
  ownerId: string;
}

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: string;
  category: string;
  imageUrl?: string;
  inStock: boolean;
  stockCount?: number;
  petSpecies?: string[];
}

export interface VetClinic {
  id: string;
  name: string;
  address: string;
  phone: string;
  email?: string;
  website?: string;
  latitude: number;
  longitude: number;
  hours?: Record<string, string>;
  rating?: number;
}

export interface Order {
  id: string;
  userId: string;
  items: OrderItem[];
  totalAmount: number;
  currency: string;
  status: "pending" | "paid" | "shipped" | "delivered" | "cancelled";
  createdAt: string;
}

export interface OrderItem {
  productId: string;
  quantity: number;
  priceAtPurchase: number;
}
