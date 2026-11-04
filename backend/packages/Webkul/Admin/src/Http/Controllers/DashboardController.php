<?php

namespace Webkul\Admin\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\View\View;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Webkul\Admin\Helpers\Dashboard;

class DashboardController extends Controller
{
    /**
     * Request param functions
     *
     * @var array
     */
    protected $typeFunctions = [
        'over-all'                 => 'getOverAllStats',
        'today'                    => 'getTodayStats',
        'stock-threshold-products' => 'getStockThresholdProducts',
        'total-sales'              => 'getSalesStats',
        'top-selling-products'     => 'getTopSellingProducts',
        'top-customers'            => 'getTopCustomers',
    ];

    /**
     * Create a controller instance.
     *
     * @return void
     */
    public function __construct(protected Dashboard $dashboardHelper) {}

    /**
     * Dashboard page for SYD Spices.
     *
     * @return View|JsonResponse
     */
    public function index()
    {
        $stats = [
            'total_products'   => Schema::hasTable('products') ? DB::table('products')->count() : 0,
            'total_categories' => Schema::hasTable('categories') ? DB::table('categories')->where('parent_id', '>', 0)->count() : 0,
            'total_orders'     => Schema::hasTable('orders') ? DB::table('orders')->count() : 0,
            'total_customers'  => Schema::hasTable('customers') ? DB::table('customers')->count() : 0,
            'total_revenue'    => Schema::hasTable('orders') ? (float) DB::table('orders')->sum('grand_total') : 0.0,
        ];

        $recentOrders = collect();
        if (Schema::hasTable('orders')) {
            $recentOrders = DB::table('orders')
                ->orderBy('created_at', 'desc')
                ->limit(6)
                ->get();
        }

        $recentCustomers = collect();
        if (Schema::hasTable('customers')) {
            $recentCustomers = DB::table('customers')
                ->orderBy('created_at', 'desc')
                ->limit(6)
                ->get();
        }

        return view('admin::dashboard.index')->with([
            'startDate'       => $this->dashboardHelper->getStartDate(),
            'endDate'         => $this->dashboardHelper->getEndDate(),
            'stats'           => $stats,
            'recentOrders'    => $recentOrders,
            'recentCustomers' => $recentCustomers,
        ]);
    }

    /**
     * Display a listing of the resource.
     *
     * @return JsonResponse
     */
    public function stats()
    {
        $stats = $this->dashboardHelper->{$this->resolveTypeFunction()}();

        return response()->json([
            'statistics' => $stats,
            'date_range' => $this->dashboardHelper->getDateRange(),
        ]);
    }

    /**
     * Resolve the requested type into a valid function name.
     *
     * @return string
     */
    protected function resolveTypeFunction()
    {
        $type = request()->query('type');

        if (
            ! is_string($type)
            || ! array_key_exists($type, $this->typeFunctions)
        ) {
            abort(404);
        }

        return $this->typeFunctions[$type];
    }
}
