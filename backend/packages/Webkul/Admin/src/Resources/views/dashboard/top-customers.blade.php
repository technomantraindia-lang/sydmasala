<!-- Top Selling Products Vue Component -->
<v-dashboard-top-customers>
    <!-- Shimmer -->
    <x-admin::shimmer.dashboard.top-customers />
</v-dashboard-top-customers>

@pushOnce('scripts')
    <script
        type="text/x-template"
        id="v-dashboard-top-customers-template"
    >
        <!-- Shimmer -->
        <template v-if="isLoading">
            <x-admin::shimmer.dashboard.top-customers />
        </template>

        <!-- Total Sales Section -->
        <template v-else>
            <div>
                <div class="flex items-center justify-between p-4 border-b dark:border-gray-800">
                    <div>
                        <p class="text-sm font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <span>👥 Top Customers by Sales</span>
                        </p>
                        <p class="text-[11px] text-gray-400 mt-0.5">Highest volume ordering clients</p>
                    </div>

                    <a href="{{ route('admin.customers.customers.index') }}" class="text-xs font-bold text-blue-600 hover:text-blue-700">
                        View All &rarr;
                    </a>
                </div>

                <div
                    class="flex flex-col divide-y divide-gray-100 dark:divide-gray-800"
                    v-if="report.statistics.length"
                >
                    <div
                        class="p-3.5 transition-all hover:bg-gray-50 dark:hover:bg-gray-800/40"
                        v-for="customer in report.statistics"
                    >
                        <a :href="customer.id ? '{{ route('admin.customers.customers.view', ':id') }}'.replace(':id', customer.id) : '#'">
                            <div class="flex justify-between items-center gap-2">
                                <div class="min-w-0 flex-1">
                                    <p class="text-xs font-bold text-gray-900 dark:text-white truncate">
                                        @{{ customer.full_name }}
                                    </p>

                                    <p class="text-[11px] text-gray-400 truncate mt-0.5">
                                        @{{ customer.email }}
                                    </p>
                                </div>

                                <div class="text-right shrink-0">
                                    <p class="text-xs font-black text-gray-900 dark:text-white">
                                        @{{ customer.formatted_total }}
                                    </p>

                                    <span class="inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold bg-emerald-50 text-emerald-700 dark:bg-emerald-950/70 dark:text-emerald-300 mt-0.5" v-if="customer.orders">
                                        @{{ customer.orders }} @{{ customer.orders == 1 ? 'order' : 'orders' }}
                                    </span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>

                <div
                    class="p-6 text-center"
                    v-else
                >
                    <div class="grid justify-center justify-items-center gap-2 py-2">
                        <span class="text-3xl mb-1">👥</span>

                        <div class="flex flex-col items-center">
                            <p class="text-xs font-bold text-gray-700 dark:text-gray-300">
                                No Customer Purchases Yet
                            </p>

                            <p class="text-[11px] text-gray-400 mt-1 max-w-[260px]">
                                Your most frequent buyers and their lifetime order spend will appear here.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </script>

    <script type="module">
        app.component('v-dashboard-top-customers', {
            template: '#v-dashboard-top-customers-template',

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

                    filters.type = 'top-customers';

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