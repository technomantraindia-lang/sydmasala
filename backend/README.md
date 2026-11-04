# Universal E-Commerce Backend & Admin API

A robust, enterprise-grade **Laravel 12** headless e-commerce backend with an integrated **Admin Dashboard** and full **JSON REST API** suite.

Designed to be connected to any custom web storefront (e.g. Next.js, React, Vue) or mobile applications (Flutter, React Native, Swift, Kotlin).

---

## 🚀 Key Features

* **Complete Administrative Dashboard (`/admin`)**:
  * **Catalog Management**: Simple, Configurable (variant swatches), Bundle, Grouped, Downloadable, and Booking products.
  * **Dynamic EAV Attributes**: Custom fields, color/image swatches, file attachments.
  * **Order & Fulfillment Flow**: Orders, Invoices, Multi-package Shipments, Refunds, and Returns (RMA).
  * **Multi-Source Inventory (MSI)**: Warehouse allocation and real-time salable stock tracking.
  * **Marketing & Discounts**: Cart discount rules (coupons), automated catalog rules, customer group pricing.
  * **Customer Portal Data**: Addresses, wishlists, product reviews, customer groups.
  * **Payment & Shipping Drivers**: Stripe, PayPal, Razorpay, PhonePe, PayU, COD, Flat Rate, Free Shipping, Table Rate.
  * **Role-Based ACL (Access Control)**: Granular permissions for administrative staff and 2-Factor Authentication (2FA).
  * **Magic AI**: Built-in AI tools for product descriptions and SEO metadata.

* **Headless REST API (`/api/*`)**:
  * Complete endpoints for categories, products, search, customer carts, one-page checkout, wishlists, and reviews.

---

## 🛠️ Requirements

* **PHP**: >= 8.3 < 8.5
* **Extensions**: `curl`, `intl`, `mbstring`, `openssl`, `pdo_mysql`, `tokenizer`, `calendar`
* **Database**: MySQL 8.0+ / MariaDB 10.4+
* **Composer**: 2.x

---

## ⚡ Quick Start & Installation

### 1. Configure Environment
Copy `.env.example` to `.env` (or update existing `.env`):
```bash
cp .env.example .env
```
Ensure your database credentials in `.env` are configured:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=syd_spices_backend
DB_USERNAME=root
DB_PASSWORD=
```

### 2. Install & Seed Database
Run the installer command to run migrations, seed default administrative roles, and initialize system configuration:
```bash
php artisan bagisto:install
```
*(Or manually: `php artisan migrate --seed`)*

### 3. Clear & Optimize Caches
```bash
php artisan optimize:clear
```

### 4. Start Local Development Server
```bash
php artisan serve
```

---

## 🔐 Admin Dashboard Access

* **URL**: `http://localhost:8000/admin` (or `http://localhost:8000/`)
* **Default Credentials**:
  * **Email**: `admin@example.com`
  * **Password**: `admin123`

---

## 📡 REST API Documentation

All frontend applications and mobile apps can communicate directly with the backend using the following REST endpoints:

### Catalog & Categories
* `GET /api/categories` — Retrieve full category hierarchy
* `GET /api/categories/attributes` — Retrieve filterable faceted attributes
* `GET /api/products` — Browse products (supports pagination, filtering by attributes/price, sorting)
* `GET /api/products/{id}/related` — Fetch cross-sell and related products

### Cart & Checkout
* `GET /api/checkout/cart` — Get active cart items, taxes, and totals
* `POST /api/checkout/cart` — Add product to cart with variants/options
* `PUT /api/checkout/cart/update` — Update item quantities or remove items
* `POST /api/checkout/onepage/save-order` — Complete checkout and place order

### Customer & Reviews
* `GET /api/product/{id}/reviews` — Fetch customer reviews
* `POST /api/product/{id}/review` — Submit customer review
* `GET /api/wishlist` & `POST /api/wishlist` — Manage customer wishlist items

---

## 📁 Repository Structure

```
├── app/                    # Laravel application shell
├── bootstrap/              # Core application bootstrap & provider registry
├── config/                 # Application & Concord module configs
├── database/               # Root migrations & seeders
├── packages/Webkul/        # 40 Backend packages
│   ├── Admin/              # Admin dashboard views & controllers
│   ├── Attribute/          # EAV attribute engine
│   ├── Product/            # Product catalog models & types
│   ├── Checkout/           # Cart calculation & checkout pipeline
│   ├── Sales/              # Orders, Invoices, Shipments, Refunds
│   ├── Inventory/          # Multi-Source Inventory management
│   ├── Payment/            # Payment gateway registry & drivers
│   ├── Shipping/           # Shipping carriers & rate calculations
│   └── ...                 # Core, Marketing, Tax, Customer, etc.
├── public/                 # Public entrypoint (index.php) & admin assets
├── routes/web.php          # Root redirect to Admin Panel
└── tests/                  # Unit and Feature test suites
```

---

## 📄 License
This project is licensed under the MIT License.
