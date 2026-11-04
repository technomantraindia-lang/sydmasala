<x-admin::layouts>
    <x-slot:title>
        SYD Spices — Admin Command Center
    </x-slot>

    <!-- Top Hero Header -->
    <div class="flex items-center justify-between gap-4 mb-6 max-sm:flex-wrap">
        <div class="grid gap-1">
            <div class="flex items-center gap-3">
                <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">
                    SYD Spices Command Center
                </h1>
                <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-bold bg-amber-100 text-amber-800 dark:bg-amber-950/60 dark:text-amber-400 border border-amber-200 dark:border-amber-800">
                    <span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                    Gujarat Heritage &bull; Live Store
                </span>
            </div>
            <p class="text-xs text-gray-500 dark:text-gray-400">
                Logged in as <strong class="text-gray-700 dark:text-gray-200">{{ auth()->guard('admin')->user()->name }}</strong> &bull; SYD Spices Pvt. Ltd. Official E-Commerce Storefront
            </p>
        </div>

        <!-- Quick Storefront Link -->
        <div class="flex items-center gap-2 max-sm:w-full max-sm:justify-between">
            <a
                href="/"
                target="_blank"
                class="inline-flex items-center gap-2 px-3.5 py-2 rounded-lg bg-amber-700 hover:bg-amber-800 text-white text-xs font-semibold shadow-sm transition-all"
                title="View customer storefront"
            >
                <span>View Storefront</span>
                <span class="text-xs">&nearr;</span>
            </a>
        </div>
    </div>

    <!-- ⚡ Quick Actions Bar -->
    <div
        class="mb-6 p-4 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs"
        style="background-color: #ffffff; border: 1px solid #e5e7eb; border-radius: 12px; padding: 14px 18px; margin-bottom: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);"
    >
        <div class="flex items-center justify-between gap-4 flex-wrap" style="display: flex; align-items: center; justify-content: space-between; gap: 16px; flex-wrap: wrap;">
            <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300">
                <span style="color: #d97706; font-size: 16px; font-weight: 900;">&bull;</span>
                <span>Store Quick Actions</span>
            </div>

            <div class="flex items-center gap-2 flex-wrap">
                <a
                    href="{{ route('admin.catalog.products.index') }}"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-amber-50 hover:bg-amber-100 text-amber-900 border border-amber-200 transition"
                    style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; background-color: #fef3c7; color: #92400e; border: 1px solid #fde68a; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none;"
                >
                    <span>+</span> Add Spice Product
                </a>

                <a
                    href="{{ route('admin.catalog.categories.index') }}"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-200 transition"
                    style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; background-color: #f3f4f6; color: #1f2937; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none;"
                >
                    <span>📁</span> Categories
                </a>

                <a
                    href="{{ route('admin.sales.orders.index') }}"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-200 transition"
                    style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; background-color: #f3f4f6; color: #1f2937; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none;"
                >
                    <span>🛒</span> Orders
                </a>

                <a
                    href="{{ route('admin.customers.customers.index') }}"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-200 transition"
                    style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; background-color: #f3f4f6; color: #1f2937; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none;"
                >
                    <span>👥</span> Customers
                </a>

                <a
                    href="{{ route('admin.marketing.promotions.cart_rules.index') }}"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-200 transition"
                    style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; background-color: #f3f4f6; color: #1f2937; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none;"
                >
                    <span>🏷️</span> Discounts &amp; Coupons
                </a>
            </div>
        </div>
    </div>

    <!-- 📊 4 Key Metrics Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        
        <!-- Total Products -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between mb-2">
                <span class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">Spice Catalog</span>
                <span class="p-2 rounded-lg bg-amber-50 text-amber-700 text-sm">🌶️</span>
            </div>
            <div class="text-2xl font-black text-gray-900 dark:text-white">
                {{ $stats['total_products'] }}
            </div>
            <a href="{{ route('admin.catalog.products.index') }}" class="inline-block mt-2 text-xs font-medium text-amber-700 hover:text-amber-800">
                Manage Products &rarr;
            </a>
        </div>

        <!-- Categories -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between mb-2">
                <span class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">Categories</span>
                <span class="p-2 rounded-lg bg-orange-50 text-orange-700 text-sm">📦</span>
            </div>
            <div class="text-2xl font-black text-gray-900 dark:text-white">
                {{ $stats['total_categories'] }}
            </div>
            <a href="{{ route('admin.catalog.categories.index') }}" class="inline-block mt-2 text-xs font-medium text-orange-700 hover:text-orange-800">
                Manage Categories &rarr;
            </a>
        </div>

        <!-- Orders -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between mb-2">
                <span class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">Total Orders</span>
                <span class="p-2 rounded-lg bg-emerald-50 text-emerald-700 text-sm">🛍️</span>
            </div>
            <div class="text-2xl font-black text-gray-900 dark:text-white">
                {{ $stats['total_orders'] }}
            </div>
            <a href="{{ route('admin.sales.orders.index') }}" class="inline-block mt-2 text-xs font-medium text-emerald-700 hover:text-emerald-800">
                View All Orders &rarr;
            </a>
        </div>

        <!-- Customers -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between mb-2">
                <span class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">Registered Customers</span>
                <span class="p-2 rounded-lg bg-blue-50 text-blue-700 text-sm">👥</span>
            </div>
            <div class="text-2xl font-black text-gray-900 dark:text-white">
                {{ $stats['total_customers'] }}
            </div>
            <a href="{{ route('admin.customers.customers.index') }}" class="inline-block mt-2 text-xs font-medium text-blue-700 hover:text-blue-800">
                View Customer Base &rarr;
            </a>
        </div>

    </div>

    <!-- 📦 Recent Orders and Information -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        <!-- Recent Orders Card -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between pb-3 mb-4 border-b border-gray-100 dark:border-gray-800">
                <h2 class="text-sm font-bold text-gray-900 dark:text-white uppercase tracking-wider">
                    Recent Customer Orders
                </h2>
                <a href="{{ route('admin.sales.orders.index') }}" class="text-xs font-semibold text-amber-700 hover:underline">
                    View All
                </a>
            </div>

            @if($recentOrders->isNotEmpty())
                <div class="divide-y divide-gray-100 dark:divide-gray-800">
                    @foreach($recentOrders as $order)
                        <div class="py-3 flex items-center justify-between">
                            <div>
                                <div class="font-bold text-sm text-gray-900 dark:text-white">#{{ $order->increment_id }}</div>
                                <div class="text-xs text-gray-500">{{ $order->customer_email }} &bull; {{ $order->created_at }}</div>
                            </div>
                            <div class="text-right">
                                <div class="font-bold text-sm text-gray-900 dark:text-white">₹{{ number_format($order->grand_total, 2) }}</div>
                                <span class="inline-block text-[11px] font-semibold px-2 py-0.5 rounded bg-gray-100 text-gray-700">
                                    {{ ucfirst($order->status) }}
                                </span>
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <div class="py-10 text-center">
                    <p class="text-sm text-gray-500 dark:text-gray-400">No customer orders placed yet.</p>
                    <p class="text-xs text-gray-400 mt-1">Orders placed via the SYD Spices checkout will appear here automatically.</p>
                </div>
            @endif
        </div>

        <!-- Brand & Storefront Summary -->
        <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 shadow-xs">
            <div class="flex items-center justify-between pb-3 mb-4 border-b border-gray-100 dark:border-gray-800">
                <h2 class="text-sm font-bold text-gray-900 dark:text-white uppercase tracking-wider">
                    Store Identity &amp; Quality Commitments
                </h2>
                <span class="text-xs text-amber-700 font-bold">100% Pure</span>
            </div>

            <div class="space-y-3 text-xs text-gray-600 dark:text-gray-300">
                <div class="flex items-start gap-2">
                    <span class="font-bold text-gray-800 dark:text-gray-100">🌿 Sourcing:</span>
                    <span>India APMC Mandi Whole Spices, Gujarat - 384170</span>
                </div>
                <div class="flex items-start gap-2">
                    <span class="font-bold text-gray-800 dark:text-gray-100">❄️ Milling:</span>
                    <span>Cold-Pulverized below 40°C to preserve natural volatile terpenes &amp; aromas</span>
                </div>
                <div class="flex items-start gap-2">
                    <span class="font-bold text-gray-800 dark:text-gray-100">🚫 Purity:</span>
                    <span>Zero artificial dyes (No Sudan dyes), zero preservatives, zero starch fillers</span>
                </div>
                <div class="flex items-start gap-2">
                    <span class="font-bold text-gray-800 dark:text-gray-100">📞 Support Hotline:</span>
                    <span>+91 98765 43210 &bull; info@sydspices.com</span>
                </div>
            </div>

            <div class="mt-6 pt-4 border-t border-gray-100 dark:border-gray-800 flex items-center justify-between">
                <span class="text-xs text-gray-500">Channel: <strong>SYD Spices Official Store</strong></span>
                <span class="text-xs text-gray-500">Currency: <strong>INR (₹)</strong></span>
            </div>
        </div>

    </div>
</x-admin::layouts>
