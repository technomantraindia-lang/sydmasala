<?php

use Illuminate\Support\Facades\Route;

Route::get('/debug-status', function () {
    $out = [];
    try {
        $out['database_name'] = \Illuminate\Support\Facades\DB::connection()->getDatabaseName();
        $out['has_admins_table'] = \Illuminate\Support\Facades\Schema::hasTable('admins');
        if ($out['has_admins_table']) {
            $out['admins_count'] = \Illuminate\Support\Facades\DB::table('admins')->count();
            $out['admins'] = \Illuminate\Support\Facades\DB::table('admins')->select('id', 'name', 'email')->get();
        }
        $out['has_channels_table'] = \Illuminate\Support\Facades\Schema::hasTable('channels');
        $out['has_locales_table'] = \Illuminate\Support\Facades\Schema::hasTable('locales');
        $out['has_currencies_table'] = \Illuminate\Support\Facades\Schema::hasTable('currencies');
        $out['installed_file_exists'] = file_exists(storage_path('installed'));
    } catch (\Throwable $e) {
        $out['db_error'] = $e->getMessage();
    }

    try {
        $out['test_view'] = 'trying...';
        $v = view('admin::users.sessions.create')->render();
        $out['test_view'] = 'rendered ok, length: ' . strlen($v);
    } catch (\Throwable $e) {
        $out['view_error'] = $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
    }

    $logFile = storage_path('logs/laravel.log');
    if (file_exists($logFile)) {
        $lines = file($logFile);
        $out['recent_logs'] = array_slice($lines, -40);
    } else {
        $out['recent_logs'] = 'No log file found';
    }

    return response()->json($out, 200, [], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
});

Route::get('/test-dash', function () {
    try {
        $admin = \Webkul\User\Models\Admin::first();
        auth()->guard('admin')->login($admin);
        $controller = app(\Webkul\Admin\Http\Controllers\DashboardController::class);
        $v = $controller->index()->render();
        return response('Dashboard render SUCCESS! Length: ' . strlen($v));
    } catch (\Throwable $e) {
        return response('Dashboard render ERROR: ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine());
    }
});

Route::get('/setup-db', function () {
    try {
        $sqlPath = base_path('database_backup.sql');
        if (!file_exists($sqlPath)) {
            return response()->json(['error' => 'database_backup.sql not found at ' . $sqlPath], 404);
        }
        $sql = file_get_contents($sqlPath);
        \Illuminate\Support\Facades\DB::unprepared($sql);
        touch(storage_path('installed'));
        return response()->json([
            'status' => 'success',
            'message' => 'database_backup.sql executed successfully!',
            'admins_count' => \Illuminate\Support\Facades\DB::table('admins')->count(),
            'admins' => \Illuminate\Support\Facades\DB::table('admins')->select('id', 'name', 'email')->get()
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'status' => 'error',
            'message' => $e->getMessage()
        ], 500);
    }
});

Route::get('/update-passwords', function () {
    $hash = password_hash('admin123', PASSWORD_BCRYPT);
    \Illuminate\Support\Facades\DB::table('admins')
        ->where('email', 'admin@admin.com')
        ->update(['password' => $hash, 'status' => 1]);
    
    \Illuminate\Support\Facades\DB::table('admins')
        ->where('email', 'admin@example.com')
        ->update(['password' => $hash, 'status' => 1]);

    return response()->json([
        'status' => 'success',
        'message' => 'Passwords updated to admin123 for all admins!',
        'accounts' => [
            'admin@admin.com' => 'admin123',
            'admin@example.com' => 'admin123'
        ]
    ]);
});

Route::get('/quick-admin', function () {
    $admin = \Webkul\User\Models\Admin::where('email', 'admin@admin.com')->first() 
          ?: \Webkul\User\Models\Admin::first();
    if ($admin) {
        auth()->guard('admin')->login($admin, true);
        return redirect()->route('admin.dashboard.index');
    }
    return response('No admin found in database. Please run /setup-db first.', 404);
});

Route::get('/reset-session', function () {
    auth()->guard('admin')->logout();
    auth()->guard('customer')->logout();
    session()->flush();
    session()->regenerate();
    return redirect()->route('admin.session.create');
});

Route::get('/simulate-login', function () {
    try {
        $email = request('email', 'admin@admin.com');
        $password = request('password', 'admin123');
        $admin = \Illuminate\Support\Facades\DB::table('admins')->where('email', $email)->first();
        if (!$admin) {
            return response()->json(['error' => 'Admin not found: ' . $email], 404);
        }
        $pwdMatch = password_verify($password, $admin->password);
        $attempt = auth()->guard('admin')->attempt(['email' => $email, 'password' => $password]);
        return response()->json([
            'email' => $email,
            'password_verify' => $pwdMatch,
            'auth_attempt' => $attempt,
            'user' => auth()->guard('admin')->user(),
            'status' => $admin->status
        ]);
    } catch (\Throwable $e) {
        return response()->json(['error' => $e->getMessage(), 'trace' => $e->getTraceAsString()], 500);
    }
});

Route::get('/test-login-and-dashboard', function () {
    $admin = \Webkul\User\Models\Admin::where('email', 'admin@admin.com')->first();
    if (!$admin) {
        return response()->json(['error' => 'No admin found'], 404);
    }
    
    $roles = \Illuminate\Support\Facades\DB::table('roles')->get();
    auth()->guard('admin')->login($admin, true);
    
    return response()->json([
        'admin' => [
            'id' => $admin->id,
            'name' => $admin->name,
            'email' => $admin->email,
            'status' => $admin->status,
            'role_id' => $admin->role_id,
        ],
        'admin_role' => $admin->role,
        'all_roles' => $roles,
        'auth_check' => auth()->guard('admin')->check(),
        'session_id' => session()->getId(),
        'cookie_name' => config('session.cookie'),
        'cookie_secure' => config('session.secure'),
        'cookie_same_site' => config('session.same_site'),
    ]);
});

Route::get('/', fn () => redirect()->route('admin.session.create'));

Route::get('/manager', fn () => view('manager'))->name('syd.manager');

Route::get('/storefront', fn () => redirect('/'))->name('shop.home.index');
Route::get('/storefront/item/{slug?}', fn ($slug = null) => redirect('/products.html'))->name('shop.product_or_category.index');
Route::get('/storefront/page/{slug?}', fn ($slug = null) => redirect('/'))->name('shop.cms.page');
Route::get('/storefront/checkout/success', fn () => redirect()->route('admin.sales.orders.index'))->name('shop.checkout.onepage.success');

Route::prefix('shop-api')->group(function () {
    Route::get('/countries', function () {
        return response()->json(core()->countries());
    })->name('shop.api.core.countries');

    Route::get('/states', function () {
        return response()->json(core()->groupedStatesByCountries());
    })->name('shop.api.core.states');
});

Route::get('/fix-category-tree', function () {
    try {
        \Illuminate\Support\Facades\DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        \Illuminate\Support\Facades\DB::table('categories')->where('id', '>', 1)->delete();
        \Illuminate\Support\Facades\DB::table('category_translations')->where('category_id', '>', 1)->delete();

        $categories = [
            ['name' => 'Signature Blends', 'slug' => 'signature-blends', 'desc' => 'Master kitchen king secret formulas, royal garam masala, and artisan slow-ground blends.'],
            ['name' => 'Pure Ground Powders', 'slug' => 'pure-ground-powders', 'desc' => 'Cold-pulverized single-origin turmeric, stemless red chilli, and aromatic coriander powders.'],
            ['name' => 'India Whole Spices', 'slug' => 'india-whole-spices', 'desc' => 'Handpicked APMC mandi whole spices with maximum volatile oil concentration.'],
            ['name' => 'Gift Sets & Bundles', 'slug' => 'gift-sets-bundles', 'desc' => 'Festive curated collector boxes, spice trios, and heritage culinary gift sets.'],
        ];

        foreach ($categories as $index => $cat) {
            $catId = $index + 2;
            \Illuminate\Support\Facades\DB::table('categories')->insert([
                'id'         => $catId,
                'position'   => $index + 1,
                'status'     => 1,
                'parent_id'  => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            \Illuminate\Support\Facades\DB::table('category_translations')->insert([
                'category_id'      => $catId,
                'locale'           => 'en',
                'name'             => $cat['name'],
                'slug'             => $cat['slug'],
                'description'      => $cat['desc'],
                'meta_title'       => $cat['name'] . ' - SYD Spices',
                'meta_description' => $cat['desc'],
            ]);
        }

        if (class_exists(\Webkul\Category\Models\Category::class)) {
            \Webkul\Category\Models\Category::fixTree();
        }

        \Illuminate\Support\Facades\DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        return response()->json([
            'status'     => 'success',
            'message'    => 'SYD Spices categories synced and tree repaired successfully!',
            'categories' => $categories,
            'count'      => \Webkul\Category\Models\Category::count()
        ]);
    } catch (\Throwable $e) {
        return response()->json(['status' => 'error', 'message' => $e->getMessage()], 500);
    }
});

// Serve public assets (images, logos, icons)
Route::get('/{path}', function ($path) {
    $candidates = [
        public_path($path),
        base_path('../assets/' . $path),
        base_path('public/' . $path),
    ];
    foreach ($candidates as $cand) {
        if (file_exists($cand) && is_file($cand)) {
            $mime = mime_content_type($cand) ?: 'application/octet-stream';
            return response()->file($cand, [
                'Content-Type' => $mime,
                'Access-Control-Allow-Origin' => '*',
            ]);
        }
    }
    abort(404);
})->where('path', '.*\.(png|jpg|jpeg|gif|webp|svg|mp4|pdf|ico)$');







