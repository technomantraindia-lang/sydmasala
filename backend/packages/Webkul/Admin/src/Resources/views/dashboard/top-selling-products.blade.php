<!-- Top Selling Products Vue Component -->
<v-dashboard-top-selling-products>
    <!-- Shimmer -->
    <x-admin::shimmer.dashboard.top-selling-products />
</v-dashboard-top-selling-products>

@pushOnce('scripts')
    <script
        type="text/x-template"
        id="v-dashboard-top-selling-products-template"
    >
        <!-- Shimmer -->
        <template v-if="isLoading">
            <x-admin::shimmer.dashboard.top-selling-products />
        </template>

        <!-- Total Sales Section -->
        <template v-else>
            <div>
                <div class="flex items-center justify-between p-4 border-b dark:border-gray-800">
                    <div>
                        <p class="text-sm font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <span>📦 Top Ordered Products</span>
                        </p>
                        <p class="text-[11px] text-gray-400 mt-0.5">Units sold &amp; customer order volume</p>
                    </div>

                    <a href="{{ route('admin.reporting.products.index') }}" class="text-xs font-bold text-blue-600 hover:text-blue-700">
                        Detailed Reports &rarr;
                    </a>
                </div>

                <!-- Top Selling Products Details -->
                <div
                    class="flex flex-col divide-y divide-gray-100 dark:divide-gray-800"
                    v-if="report.statistics.length"
                >
                    <a
                        :href="'{{ route('admin.catalog.products.edit', ':id') }}'.replace(':id', item.id)"
                        class="flex gap-3 p-3.5 transition-all hover:bg-gray-50 dark:hover:bg-gray-800/40"
                        v-for="item in report.statistics"
                    >
                        <!-- Product Item -->
                        <img
                            v-if="item.images?.length"
                            class="relative h-[56px] max-h-[56px] w-[56px] max-w-[56px] object-cover rounded-lg border border-gray-100 dark:border-gray-800 shrink-0"
                            :src="item.images[0]?.url"
                        />

                        <div
                            v-else
                            class="relative h-[56px] max-h-[56px] w-[56px] max-w-[56px] flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200 dark:bg-gray-800 dark:border-gray-700 shrink-0"
                        >
                            <span class="text-xl">🧴</span>
                        </div>

                        <!-- Product Details -->
                        <div class="flex w-full flex-col justify-center gap-1 min-w-0">
                            <div class="flex items-center justify-between gap-2">
                                <p
                                    class="text-xs font-bold text-gray-900 dark:text-white truncate"
                                    v-text="item.name"
                                >
                                </p>

                                <p class="text-xs font-black text-emerald-600 dark:text-emerald-400 shrink-0">
                                    @{{ item.formatted_revenue }}
                                </p>
                            </div>

                            <div class="flex items-center justify-between text-[11px] text-gray-500">
                                <div class="flex items-center gap-1.5 flex-wrap">
                                    <span class="inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold bg-blue-50 text-blue-700 dark:bg-blue-950/70 dark:text-blue-300">
                                        @{{ item.total_qty_ordered || 0 }} ordered
                                    </span>

                                    <span class="inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold bg-purple-50 text-purple-700 dark:bg-purple-950/70 dark:text-purple-300" v-if="item.total_customers">
                                        @{{ item.total_customers }} @{{ item.total_customers == 1 ? 'buyer' : 'buyers' }}
                                    </span>
                                </div>

                                <span class="font-medium text-gray-400">
                                    @{{ item.formatted_price }}
                                </span>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Empty Product Design -->
                <div
                    class="p-6 text-center"
                    v-else
                >
                    <div class="grid justify-center justify-items-center gap-2 py-2">
                        <span class="text-3xl mb-1">📦</span>

                        <div class="flex flex-col items-center">
                            <p class="text-xs font-bold text-gray-700 dark:text-gray-300">
                                No Product Orders Yet
                            </p>

                            <p class="text-[11px] text-gray-400 mt-1 max-w-[260px]">
                                When customers place online cart orders, units sold and individual buyer counts will be tracked here live.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </script>

    <script type="module">
        app.component('v-dashboard-top-selling-products', {
            template: '#v-dashboard-top-selling-products-template',

            data() {
                return {
                    report: [],

                    isLoading: true,
                }
            },

            mounted() {
                this.getStats({});

                this.$emitter.on('reporting-filter-updated', this.getStats);
            },

            methods: {
                getStats(filters) {
                    this.isLoading = true;

                    var filters = Object.assign({}, filters);

                    filters.type = 'top-selling-products';

                    this.$axios.get("{{ route('admin.dashboard.stats') }}", {
                            params: filters
                        })
                        .then(response => {
                            this.report = response.data;

                            this.isLoading = false;
                        })
                        .catch(error => {});
                }
            }
        });
    </script>
@endPushOnce