-- Mipets Database Schema

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────
-- PETS
-- ─────────────────────────────────────────
create table public.pets (
  id          uuid primary key default uuid_generate_v4(),
  owner_id    uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  species     text check (species in ('dog','cat','bird','rabbit','other')) not null,
  breed       text,
  age         numeric,
  weight      numeric,
  diet_notes  text,
  health_notes text,
  photo_url   text,
  created_at  timestamptz default now()
);
alter table public.pets enable row level security;
create policy "Users manage own pets" on public.pets
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- ─────────────────────────────────────────
-- PRODUCTS
-- ─────────────────────────────────────────
create table public.products (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null,
  description text,
  price       numeric(10,2) not null,
  currency    text default 'USD',
  category    text not null,
  image_url   text,
  in_stock    boolean default true,
  stock_count integer default 0,
  pet_species text[],
  created_at  timestamptz default now()
);
alter table public.products enable row level security;
create policy "Products are viewable by everyone" on public.products
  for select using (true);

-- ─────────────────────────────────────────
-- VET CLINICS
-- ─────────────────────────────────────────
create table public.vet_clinics (
  id        uuid primary key default uuid_generate_v4(),
  name      text not null,
  address   text not null,
  phone     text,
  email     text,
  website   text,
  latitude  numeric(9,6) not null,
  longitude numeric(9,6) not null,
  hours     jsonb,
  rating    numeric(2,1),
  created_at timestamptz default now()
);
alter table public.vet_clinics enable row level security;
create policy "Vet clinics are viewable by everyone" on public.vet_clinics
  for select using (true);

-- ─────────────────────────────────────────
-- ORDERS
-- ─────────────────────────────────────────
create table public.orders (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid references auth.users(id) on delete cascade not null,
  total_amount numeric(10,2) not null,
  currency     text default 'USD',
  status       text check (status in ('pending','paid','shipped','delivered','cancelled')) default 'pending',
  stripe_payment_intent_id text,
  created_at   timestamptz default now()
);
alter table public.orders enable row level security;
create policy "Users view own orders" on public.orders
  using (auth.uid() = user_id);

-- ─────────────────────────────────────────
-- ORDER ITEMS
-- ─────────────────────────────────────────
create table public.order_items (
  id                uuid primary key default uuid_generate_v4(),
  order_id          uuid references public.orders(id) on delete cascade not null,
  product_id        uuid references public.products(id) not null,
  quantity          integer not null,
  price_at_purchase numeric(10,2) not null
);
alter table public.order_items enable row level security;
create policy "Users view own order items" on public.order_items
  using (
    exists (
      select 1 from public.orders
      where orders.id = order_items.order_id
        and orders.user_id = auth.uid()
    )
  );
