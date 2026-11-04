<?php

return [
    /**
     * 1. Dashboard.
     */
    [
        'key'        => 'dashboard',
        'name'       => 'admin::app.components.layouts.sidebar.dashboard',
        'route'      => 'admin.dashboard.index',
        'sort'       => 1,
        'icon'       => 'icon-dashboard',
    ],

    /**
     * 2. Sales.
     */
    [
        'key'        => 'sales',
        'name'       => 'admin::app.components.layouts.sidebar.sales',
        'route'      => 'admin.sales.orders.index',
        'sort'       => 2,
        'icon'       => 'icon-sales',
    ], [
        'key'        => 'sales.orders',
        'name'       => 'admin::app.components.layouts.sidebar.orders',
        'route'      => 'admin.sales.orders.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'sales.shipments',
        'name'       => 'admin::app.components.layouts.sidebar.shipments',
        'route'      => 'admin.sales.shipments.index',
        'sort'       => 2,
        'icon'       => '',
    ], [
        'key'        => 'sales.invoices',
        'name'       => 'admin::app.components.layouts.sidebar.invoices',
        'route'      => 'admin.sales.invoices.index',
        'sort'       => 3,
        'icon'       => '',
    ], [
        'key'        => 'sales.refunds',
        'name'       => 'admin::app.components.layouts.sidebar.refunds',
        'route'      => 'admin.sales.refunds.index',
        'sort'       => 4,
        'icon'       => '',
    ], [
        'key'        => 'sales.transactions',
        'name'       => 'admin::app.components.layouts.sidebar.transactions',
        'route'      => 'admin.sales.transactions.index',
        'sort'       => 5,
        'icon'       => '',
    ],

    /**
     * 3. Catalog (Spices, Blends & Powders).
     */
    [
        'key'        => 'catalog',
        'name'       => 'admin::app.components.layouts.sidebar.catalog',
        'route'      => 'admin.catalog.products.index',
        'sort'       => 3,
        'icon'       => 'icon-product',
    ], [
        'key'        => 'catalog.products',
        'name'       => 'admin::app.components.layouts.sidebar.products',
        'route'      => 'admin.catalog.products.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'catalog.categories',
        'name'       => 'admin::app.components.layouts.sidebar.categories',
        'route'      => 'admin.catalog.categories.index',
        'sort'       => 2,
        'icon'       => '',
    ],

    /**
     * 4. Customers.
     */
    [
        'key'        => 'customers',
        'name'       => 'admin::app.components.layouts.sidebar.customers',
        'route'      => 'admin.customers.customers.index',
        'sort'       => 4,
        'icon'       => 'icon-customer',
    ], [
        'key'        => 'customers.customers',
        'name'       => 'admin::app.components.layouts.sidebar.customers',
        'route'      => 'admin.customers.customers.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'customers.groups',
        'name'       => 'admin::app.components.layouts.sidebar.groups',
        'route'      => 'admin.customers.groups.index',
        'sort'       => 2,
        'icon'       => '',
    ], [
        'key'        => 'customers.reviews',
        'name'       => 'admin::app.components.layouts.sidebar.reviews',
        'route'      => 'admin.customers.customers.review.index',
        'sort'       => 3,
        'icon'       => '',
    ],

    /**
     * 5. Marketing & Promotions.
     */
    [
        'key'        => 'marketing',
        'name'       => 'admin::app.components.layouts.sidebar.marketing',
        'route'      => 'admin.marketing.promotions.cart_rules.index',
        'sort'       => 5,
        'icon'       => 'icon-promotion',
    ], [
        'key'        => 'marketing.promotions',
        'name'       => 'admin::app.components.layouts.sidebar.promotions',
        'route'      => 'admin.marketing.promotions.cart_rules.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'marketing.communications',
        'name'       => 'admin::app.components.layouts.sidebar.communications',
        'route'      => 'admin.marketing.communications.campaigns.index',
        'sort'       => 2,
        'icon'       => '',
    ], [
        'key'        => 'marketing.search_seo',
        'name'       => 'admin::app.components.layouts.sidebar.search-seo',
        'route'      => 'admin.marketing.search_seo.url_rewrites.index',
        'sort'       => 3,
        'icon'       => '',
    ],

    /**
     * 6. Analytics & Reports.
     */
    [
        'key'        => 'reporting',
        'name'       => 'admin::app.components.layouts.sidebar.reporting',
        'route'      => 'admin.reporting.sales.index',
        'sort'       => 6,
        'icon'       => 'icon-report',
        'icon-class' => 'report-icon',
    ], [
        'key'        => 'reporting.sales',
        'name'       => 'admin::app.components.layouts.sidebar.sales',
        'route'      => 'admin.reporting.sales.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'reporting.customers',
        'name'       => 'admin::app.components.layouts.sidebar.customers',
        'route'      => 'admin.reporting.customers.index',
        'sort'       => 2,
        'icon'       => '',
    ], [
        'key'        => 'reporting.products',
        'name'       => 'admin::app.components.layouts.sidebar.products',
        'route'      => 'admin.reporting.products.index',
        'sort'       => 3,
        'icon'       => '',
    ],

    /**
     * 7. Settings.
     */
    [
        'key'        => 'settings',
        'name'       => 'admin::app.components.layouts.sidebar.settings',
        'route'      => 'admin.settings.locales.index',
        'sort'       => 7,
        'icon'       => 'icon-settings',
        'icon-class' => 'settings-icon',
    ], [
        'key'        => 'settings.locales',
        'name'       => 'admin::app.components.layouts.sidebar.locales',
        'route'      => 'admin.settings.locales.index',
        'sort'       => 1,
        'icon'       => '',
    ], [
        'key'        => 'settings.currencies',
        'name'       => 'admin::app.components.layouts.sidebar.currencies',
        'route'      => 'admin.settings.currencies.index',
        'sort'       => 2,
        'icon'       => '',
    ], [
        'key'        => 'settings.exchange_rates',
        'name'       => 'admin::app.components.layouts.sidebar.exchange-rates',
        'route'      => 'admin.settings.exchange_rates.index',
        'sort'       => 3,
        'icon'       => '',
    ], [
        'key'        => 'settings.inventory_sources',
        'name'       => 'admin::app.components.layouts.sidebar.inventory-sources',
        'route'      => 'admin.settings.inventory_sources.index',
        'sort'       => 4,
        'icon'       => '',
    ], [
        'key'        => 'settings.channels',
        'name'       => 'admin::app.components.layouts.sidebar.channels',
        'route'      => 'admin.settings.channels.index',
        'sort'       => 5,
        'icon'       => '',
    ], [
        'key'        => 'settings.users',
        'name'       => 'admin::app.components.layouts.sidebar.users',
        'route'      => 'admin.settings.users.index',
        'sort'       => 6,
        'icon'       => '',
    ], [
        'key'        => 'settings.roles',
        'name'       => 'admin::app.components.layouts.sidebar.roles',
        'route'      => 'admin.settings.roles.index',
        'sort'       => 7,
        'icon'       => '',
    ], [
        'key'        => 'settings.themes',
        'name'       => 'admin::app.components.layouts.sidebar.themes',
        'route'      => 'admin.appearance.themes.index',
        'sort'       => 8,
        'icon'       => '',
    ], [
        'key'        => 'settings.taxes',
        'name'       => 'admin::app.components.layouts.sidebar.taxes',
        'route'      => 'admin.settings.taxes.categories.index',
        'sort'       => 9,
        'icon'       => '',
    ],

    /**
     * 8. Configuration.
     */
    [
        'key'        => 'configuration',
        'name'       => 'admin::app.components.layouts.sidebar.configure',
        'route'      => 'admin.configuration.index',
        'sort'       => 8,
        'icon'       => 'icon-configuration',
    ],
];
