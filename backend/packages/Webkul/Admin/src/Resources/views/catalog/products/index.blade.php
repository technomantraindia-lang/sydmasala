@php
    $types = collect(config('product_types'))->map(fn ($type) => app($type['class']));

    // A composite keeps its stock on its children, so it has no count of its own to show.
    $stockOnChildrenTypes = $types->filter->isComposite()->keys()->all();

    // A type that keeps stock at all is left to the per-record `manage_stock` instead.
    $stockDisabledTypes = $types
        ->reject->isComposite()
        ->reject->isInventoryManageable()
        ->keys()
        ->all();

    /**
     * Render type keys as a JavaScript array literal.
     */
    $asJsArray = fn (array $types) => "['".implode("', '", $types)."']";
@endphp

<x-admin::layouts>
    <x-slot:title>
        @lang('admin::app.catalog.products.index.title')
    </x-slot>

    <div class="flex items-center justify-between gap-4 max-sm:flex-wrap">
        <p class="text-xl font-bold text-gray-800 dark:text-white">
            @lang('admin::app.catalog.products.index.title')
        </p>

        <div class="flex items-center gap-x-2.5">
            <!-- Export Modal -->
            <x-admin::datagrid.export :src="route('admin.catalog.products.index')" />

            {!! view_render_event('bagisto.admin.catalog.products.create.before') !!}

            @if (bouncer()->hasPermission('catalog.products.create'))
                <v-create-product-form>
                    <button
                        type="button"
                        class="primary-button"
                    >
                        @lang('admin::app.catalog.products.index.create-btn')
                    </button>
                </v-create-product-form>
            @endif

            {!! view_render_event('bagisto.admin.catalog.products.create.after') !!}
        </div>
    </div>

    {!! view_render_event('bagisto.admin.catalog.products.list.before') !!}

    <!-- Datagrid -->
    <x-admin::datagrid
        :src="route('admin.catalog.products.index')"
        :isMultiRow="true"
    >
        <!-- Datagrid Header -->
        @php
            $hasPermission = bouncer()->hasPermission('catalog.products.edit') || bouncer()->hasPermission('catalog.products.delete');
        @endphp

        <template #header="{
            isLoading,
            available,
            applied,
            selectAll,
            sort,
            performAction
        }">
            <template v-if="isLoading">
                <x-admin::shimmer.datagrid.table.head
                    :isMultiRow="true"
                    template="minmax(0, 2fr) minmax(0, 1fr) minmax(0, 1fr)"
                    :groups="[3, 3, 3]"
                    :imageGroup="1"
                />
            </template>

            <template v-else>
                <div class="row datagrid-head datagrid-head-cards grid grid-cols-[2fr_1fr_1fr] grid-rows-1">
                    <div
                        class="flex select-none items-center gap-2.5"
                        v-for="(columnGroup, index) in [['name'], ['base_image', 'price', 'quantity'], ['status', 'category_name']]"
                    >
                        @if ($hasPermission)
                            <label
                                class="flex w-max cursor-pointer select-none items-center gap-1"
                                for="mass_action_select_all_records"
                                v-if="! index"
                            >
                                <input
                                    type="checkbox"
                                    name="mass_action_select_all_records"
                                    id="mass_action_select_all_records"
                                    class="peer hidden"
                                    :checked="['all', 'partial'].includes(applied.massActions.meta.mode)"
                                    @change="selectAll"
                                >

                                <span
                                    class="icon-uncheckbox cursor-pointer rounded-md text-2xl"
                                    :class="[
                                        applied.massActions.meta.mode === 'all' ? 'peer-checked:icon-checked peer-checked:text-blue-600' : (
                                            applied.massActions.meta.mode === 'partial' ? 'peer-checked:icon-checkbox-partial peer-checked:text-blue-600' : ''
                                        ),
                                    ]"
                                >
                                </span>
                            </label>
                        @endif

                        <p class="text-gray-600 dark:text-gray-300">
                            <span class="[&>*]:after:content-['_/_']">
                                <template v-for="column in columnGroup">
                                    <span
                                        class="after:content-['/'] last:after:content-['']"
                                        :class="{
                                            'font-medium text-gray-800 dark:text-white': applied.sort.column == column,
                                            'cursor-pointer hover:text-gray-800 dark:hover:text-white': available.columns.find(columnTemp => columnTemp.index === column)?.sortable,
                                        }"
                                        @click="
                                            available.columns.find(columnTemp => columnTemp.index === column)?.sortable ? sort(available.columns.find(columnTemp => columnTemp.index === column)): {}
                                        "
                                    >
                                        @{{ available.columns.find(columnTemp => columnTemp.index === column)?.label }}
                                    </span>
                                </template>
                            </span>

                            <i
                                class="align-text-bottom text-base text-gray-800 dark:text-white ltr:ml-1.5 rtl:mr-1.5"
                                :class="[applied.sort.order === 'asc' ? 'icon-down-stat': 'icon-up-stat']"
                                v-if="columnGroup.includes(applied.sort.column)"
                            ></i>
                        </p>
                    </div>
                </div>
            </template>
        </template>

        <template #body="{
            isLoading,
            available,
            applied,
            selectAll,
            sort,
            performAction
        }">
            <template v-if="isLoading">
                <x-admin::shimmer.datagrid.table.body
                    :isMultiRow="true"
                    template="minmax(0, 2fr) minmax(0, 1fr) minmax(0, 1fr)"
                    :groups="[3, 3, 3]"
                    :imageGroup="1"
                    :mobileLines="9"
                    :mobileImage="true"
                />
            </template>

            <template v-else>
                <div
                    class="row border-b px-2 py-2.5 transition-all hover:bg-gray-50 dark:border-gray-800 dark:hover:bg-gray-950 sm:px-4 md:grid md:grid-cols-[2fr_1fr_1fr] md:grid-rows-1 md:gap-1.5"
                    v-for="record in available.records"
                >
                    <!-- Mobile Layout -->
                    <div class="block space-y-3 md:hidden">
                        <!-- Header Row with Checkbox, Name and Actions -->
                        <div class="flex items-start justify-between gap-3">
                            <div class="flex items-start gap-2.5">
                                @if ($hasPermission)
                                    <input
                                        type="checkbox"
                                        :name="`mass_action_select_record_${record.product_id}`"
                                        :id="`mass_action_select_record_${record.product_id}`"
                                        :value="record.product_id"
                                        class="peer hidden"
                                        v-model="applied.massActions.indices"
                                    >

                                    <label
                                        class="icon-uncheckbox peer-checked:icon-checked cursor-pointer rounded-md text-2xl peer-checked:text-blue-600"
                                        :for="`mass_action_select_record_${record.product_id}`"
                                    ></label>
                                @endif

                                <div class="relative flex-shrink-0">
                                    <template v-if="record.base_image">
                                        <img
                                            class="h-12 w-12 rounded object-cover sm:h-16 sm:w-16"
                                            :src='record.base_image'
                                        />

                                        <span class="absolute -bottom-1 -right-1 rounded-full bg-darkPink px-1 text-xs font-bold leading-normal text-white">
                                            @{{ record.images_count }}
                                        </span>
                                    </template>

                                    <template v-else>
                                        <div class="relative h-12 w-12 rounded border border-dashed border-gray-300 dark:border-gray-800 dark:mix-blend-exclusion dark:invert sm:h-16 sm:w-16">
                                            <img src="{{ bagisto_asset('images/product-placeholders/front.svg')}}" class="h-full w-full object-cover">

                                            <p class="absolute bottom-0 w-full text-center text-[6px] font-semibold text-gray-400">
                                                @lang('admin::app.catalog.products.index.datagrid.product-image')
                                            </p>
                                        </div>
                                    </template>
                                </div>

                                <div class="flex flex-col gap-1 flex-1">
                                    <p class="break-all text-sm font-semibold text-gray-800 dark:text-white sm:text-base">
                                        @{{ record.name }}
                                    </p>

                                    <p class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm">
                                        @{{ "@lang('admin::app.catalog.products.index.datagrid.id-value')".replace(':id', record.product_id) }}
                                    </p>

                                    <p class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm">
                                        @{{ record.category_name ?? 'N/A' }}
                                    </p>

                                    <p class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm">
                                        @{{ record.type }}
                                    </p>

                                    <p class="text-sm font-semibold text-gray-800 dark:text-white sm:text-base">
                                        @{{ $admin.formatPrice(record.price) }}
                                    </p>

                                    <div>
                                        <div v-if="{!! $asJsArray($stockOnChildrenTypes) !!}.includes(record.type)">
                                            <p class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm">
                                                <span class="text-red-600">N/A</span>
                                            </p>
                                        </div>

                                        <div v-else-if="{!! $asJsArray($stockDisabledTypes) !!}.includes(record.type) || ! Number(record.manage_stock)">
                                            <p class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm">
                                                <span class="text-gray-500 dark:text-gray-400">
                                                    @lang('admin::app.catalog.products.index.datagrid.stock-disabled')
                                                </span>
                                            </p>
                                        </div>

                                        <div v-else>
                                            <p
                                                class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm"
                                                v-if="record.quantity > 0"
                                            >
                                                <span class="text-green-600">
                                                    @{{ "@lang('admin::app.catalog.products.index.datagrid.qty-value')".replace(':qty', record.quantity) }}
                                                </span>
                                            </p>

                                            <p
                                                class="text-xs text-gray-600 dark:text-gray-300 sm:text-sm"
                                                v-else
                                            >
                                                <span class="text-red-600">
                                                    @lang('admin::app.catalog.products.index.datagrid.out-of-stock')
                                                </span>
                                            </p>
                                        </div>
                                    </div>

                                    <p :class="[record.status ? 'label-active': 'label-info']">
                                        @{{ record.status ? "@lang('admin::app.catalog.products.index.datagrid.active')" : "@lang('admin::app.catalog.products.index.datagrid.disable')" }}
                                    </p>
                                </div>
                            </div>

                            <div class="flex items-center gap-1">
                                <span
                                    class="cursor-pointer rounded-md p-1.5 text-xl transition-all hover:bg-gray-200 dark:hover:bg-gray-800"
                                    :class="action.icon"
                                    v-text="! action.icon ? action.title : ''"
                                    v-for="action in record.actions"
                                    @click="performAction(action)"
                                >
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Desktop Layout (Hidden on Mobile) -->
                    <div class="hidden md:contents">
                        <!-- Name, SKU, Attribute Family Columns -->
                        <div class="flex gap-2.5">
                            @if ($hasPermission)
                                <input
                                    type="checkbox"
                                    :name="`mass_action_select_record_${record.product_id}`"
                                    :id="`mass_action_select_record_${record.product_id}`"
                                    :value="record.product_id"
                                    class="peer hidden"
                                    v-model="applied.massActions.indices"
                                >

                                <label
                                    class="icon-uncheckbox peer-checked:icon-checked cursor-pointer rounded-md text-2xl peer-checked:text-blue-600"
                                    :for="`mass_action_select_record_${record.product_id}`"
                                ></label>
                            @endif

                            <div class="flex flex-col gap-1.5">
                                <p class="break-all text-base font-semibold text-gray-800 dark:text-white">
                                    @{{ record.name }}
                                </p>

                                <p class="text-xs text-gray-500 dark:text-gray-400" v-if="record.category_name">
                                    @{{ record.category_name }}
                                </p>
                            </div>
                        </div>

                        <!-- Image, Price, Id, Stock Columns -->
                        <div class="flex gap-1.5">
                            <div class="relative">
                                <template v-if="record.base_image">
                                    <img
                                        class="max-h-[65px] min-h-[65px] min-w-[65px] max-w-[65px] rounded"
                                        :src='record.base_image'
                                    />

                                    <span class="absolute bottom-px rounded-full bg-darkPink px-1.5 text-xs font-bold leading-normal text-white ltr:left-px rtl:right-px">
                                        @{{ record.images_count }}
                                    </span>
                                </template>

                                <template v-else>
                                    <div class="relative h-[60px] max-h-[60px] w-full max-w-[60px] rounded border border-dashed border-gray-300 dark:border-gray-800 dark:mix-blend-exclusion dark:invert">
                                        <img src="{{ bagisto_asset('images/product-placeholders/front.svg')}}">

                                        <p class="absolute bottom-1.5 w-full text-center text-[6px] font-semibold text-gray-400">
                                            @lang('admin::app.catalog.products.index.datagrid.product-image')
                                        </p>
                                    </div>
                                </template>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <p class="text-base font-semibold text-gray-800 dark:text-white">
                                    @{{ $admin.formatPrice(record.price) }}
                                </p>

                                <!-- Parent Product Quantity -->
                                <div v-if="{!! $asJsArray($stockOnChildrenTypes) !!}.includes(record.type)">
                                    <p class="text-gray-600 dark:text-gray-300">
                                        <span class="text-red-600">N/A</span>
                                    </p>
                                </div>

                                <div v-else-if="{!! $asJsArray($stockDisabledTypes) !!}.includes(record.type) || ! Number(record.manage_stock)">
                                    <p class="text-gray-600 dark:text-gray-300">
                                        <span class="text-gray-500 dark:text-gray-400">
                                            @lang('admin::app.catalog.products.index.datagrid.stock-disabled')
                                        </span>
                                    </p>
                                </div>

                                <div v-else>
                                    <p
                                        class="text-gray-600 dark:text-gray-300"
                                        v-if="record.quantity > 0"
                                    >
                                        <span class="text-green-600">
                                            @{{ "@lang('admin::app.catalog.products.index.datagrid.qty-value')".replace(':qty', record.quantity) }}
                                        </span>
                                    </p>

                                    <p
                                        class="text-gray-600 dark:text-gray-300"
                                        v-else
                                    >
                                        <span class="text-red-600">
                                            @lang('admin::app.catalog.products.index.datagrid.out-of-stock')
                                        </span>
                                    </p>
                                </div>

                                <p class="text-gray-600 dark:text-gray-300">
                                    @{{ "@lang('admin::app.catalog.products.index.datagrid.id-value')".replace(':id', record.product_id) }}
                                </p>
                            </div>
                        </div>

                        <!-- Status, Category, Type Columns -->
                        <div class="flex items-center justify-between gap-x-4">
                            <div class="flex flex-col gap-1.5">
                                <p :class="[record.status ? 'label-active': 'label-info']">
                                    @{{ record.status ? "@lang('admin::app.catalog.products.index.datagrid.active')" : "@lang('admin::app.catalog.products.index.datagrid.disable')" }}
                                </p>

                                <p class="text-gray-600 dark:text-gray-300">
                                    @{{ record.category_name ?? 'N/A' }}
                                </p>

                                <p class="text-gray-600 dark:text-gray-300">
                                    @{{ record.type }}
                                </p>
                            </div>

                            <p
                                class="flex items-center gap-1.5"
                                v-if="available.actions.length"
                            >
                                <span
                                    class="cursor-pointer rounded-md p-1.5 text-2xl transition-all hover:bg-gray-200 dark:hover:bg-gray-800 max-sm:place-self-center"
                                    :class="action.icon"
                                    v-text="! action.icon ? action.title : ''"
                                    v-for="action in record.actions"
                                    @click="performAction(action)"
                                >
                                </span>
                            </p>
                        </div>
                    </div>
                </div>
            </template>
        </template>
    </x-admin::datagrid>

    {!! view_render_event('bagisto.admin.catalog.products.list.after') !!}

    @pushOnce('scripts')
        <script
            type="text/x-template"
            id="v-create-product-form-template"
        >
            <div>
                <!-- Product Create Button -->
                @if (bouncer()->hasPermission('catalog.products.create'))
                    <button
                        type="button"
                        class="primary-button"
                        @click="$refs.productCreateModal.toggle()"
                    >
                        @lang('admin::app.catalog.products.index.create-btn')
                    </button>
                @endif

                <x-admin::form
                    v-slot="{ meta, errors, handleSubmit }"
                    as="div"
                >
                    <form @submit="handleSubmit($event, create)">
                        <!-- Direct Product Create Modal -->
                        <x-admin::modal ref="productCreateModal" panel-class="max-w-[720px]">
                            <!-- Modal Header -->
                            <x-slot:header>
                                <div>
                                    <p class="text-lg font-bold text-gray-800 dark:text-white">
                                        Add New Spice Product
                                    </p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                                        Directly create a product for the SYD Spices catalog and storefront
                                    </p>
                                </div>
                            </x-slot>

                            <!-- Modal Content -->
                            <x-slot:content>
                                <div class="space-y-4 max-h-[70vh] overflow-y-auto pr-1">
                                    {!! view_render_event('bagisto.admin.catalog.products.create_form.general.controls.before') !!}

                                    <!-- Hidden Type & Family for Simple Spice Products -->
                                    <input type="hidden" name="type" value="simple">
                                    <input type="hidden" name="attribute_family_id" value="1">

                                    <!-- Product Name -->
                                    <x-admin::form.control-group class="mb-3">
                                        <x-admin::form.control-group.label class="required font-semibold text-gray-700 dark:text-gray-200">
                                            Spice Product Name
                                        </x-admin::form.control-group.label>

                                        <x-admin::form.control-group.control
                                            type="text"
                                            name="name"
                                            rules="required"
                                            label="Product Name"
                                            placeholder="e.g. Royal Kashmiri Chilli Powder, Malabar Black Pepper"
                                        />

                                        <x-admin::form.control-group.error control-name="name" />
                                    </x-admin::form.control-group>

                                    <!-- Category & Stock Grid -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <!-- Spice Category -->
                                        <x-admin::form.control-group class="mb-3">
                                            <x-admin::form.control-group.label class="required font-semibold text-gray-700 dark:text-gray-200">
                                                Spice Category
                                            </x-admin::form.control-group.label>

                                            <x-admin::form.control-group.control
                                                type="select"
                                                name="category_id"
                                                rules="required"
                                                label="Category"
                                                value="2"
                                            >
                                                <option value="2">Whole Spices</option>
                                                <option value="3">Blended Spices</option>
                                                <option value="4">Grinded Spices</option>
                                            </x-admin::form.control-group.control>

                                            <x-admin::form.control-group.error control-name="category_id" />
                                        </x-admin::form.control-group>

                                        <!-- Stock Quantity -->
                                        <x-admin::form.control-group class="mb-3">
                                            <x-admin::form.control-group.label class="font-semibold text-gray-700 dark:text-gray-200">
                                                Total Stock Quantity
                                            </x-admin::form.control-group.label>

                                            <x-admin::form.control-group.control
                                                type="number"
                                                name="quantity"
                                                label="Quantity"
                                                placeholder="100"
                                                value="100"
                                            />

                                            <x-admin::form.control-group.error control-name="quantity" />
                                        </x-admin::form.control-group>
                                    </div>

                                    <!-- Weight & Price Options Builder (Select Weight and Set Price Differently) -->
                                    <div class="mb-4 rounded-lg border border-amber-300 bg-amber-50/40 p-3.5 dark:border-gray-700 dark:bg-gray-800/40">
                                        <div class="flex items-center justify-between mb-3 flex-wrap gap-2">
                                            <div>
                                                <p class="text-sm font-bold text-gray-800 dark:text-gray-100 flex items-center gap-1.5">
                                                    <span>⚖️</span> Select Weights & Prices
                                                </p>
                                                <p class="text-xs text-gray-500 dark:text-gray-400">
                                                    Select pack sizes and specify individual selling prices for each.
                                                </p>
                                            </div>
                                            <button
                                                type="button"
                                                @click="addWeightOption"
                                                class="text-xs font-bold text-amber-800 bg-amber-100 hover:bg-amber-200 border border-amber-300 rounded px-2.5 py-1.5 transition-all flex items-center gap-1 shadow-sm dark:bg-gray-700 dark:text-amber-300 dark:border-gray-600"
                                            >
                                                <span>+</span> Add Another Pack Size
                                            </button>
                                        </div>

                                        <div class="space-y-2">
                                            <div
                                                v-for="(item, index) in weightOptions"
                                                :key="index"
                                                class="flex items-center gap-2 rounded-md border p-2 bg-white dark:border-gray-700 dark:bg-gray-900 transition-all"
                                                :class="{'border-amber-400 ring-1 ring-amber-400 bg-amber-50/20': item.isDefault}"
                                            >
                                                <!-- Weight Selector -->
                                                <div class="w-2/5">
                                                    <label class="block text-[10px] font-bold text-gray-500 dark:text-gray-400 mb-0.5">
                                                        Select Weight
                                                    </label>
                                                    <select
                                                        v-model="item.weight"
                                                        class="w-full rounded border border-gray-300 bg-white p-1.5 text-xs font-semibold text-gray-800 dark:border-gray-600 dark:bg-gray-800 dark:text-white"
                                                    >
                                                        <option value="100g">100g (100 Gram Pack)</option>
                                                        <option value="250g">250g (250 Gram Pack)</option>
                                                        <option value="500g">500g (500 Gram Pack)</option>
                                                        <option value="1kg">1kg (1 Kilogram Pack)</option>
                                                        <option value="50g">50g (Sample Pack)</option>
                                                        <option value="200g">200g Pack</option>
                                                        <option value="1.5kg">1.5kg Box</option>
                                                    </select>
                                                </div>

                                                <!-- Price Input -->
                                                <div class="w-2/5">
                                                    <label class="block text-[10px] font-bold text-gray-500 dark:text-gray-400 mb-0.5">
                                                        Price (₹)
                                                    </label>
                                                    <div class="flex items-center rounded border border-gray-300 dark:border-gray-600 overflow-hidden bg-white dark:bg-gray-800">
                                                        <span class="px-2 text-xs font-bold text-gray-400">₹</span>
                                                        <input
                                                            type="number"
                                                            v-model="item.price"
                                                            placeholder="e.g. 195"
                                                            class="w-full p-1.5 text-xs font-bold text-gray-800 dark:text-white dark:bg-gray-800 focus:outline-none"
                                                        />
                                                    </div>
                                                </div>

                                                <!-- Default Pack Button -->
                                                <div class="flex-1 flex items-center justify-center pt-3">
                                                    <button
                                                        type="button"
                                                        @click="setDefaultWeight(index)"
                                                        class="text-[11px] px-2 py-1 rounded font-semibold transition-all border whitespace-nowrap"
                                                        :class="item.isDefault ? 'bg-amber-600 text-white border-amber-600 shadow-sm' : 'bg-gray-100 text-gray-600 border-gray-200 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700'"
                                                    >
                                                        @{{ item.isDefault ? '★ Default' : 'Set Default' }}
                                                    </button>
                                                </div>

                                                <!-- Remove Button -->
                                                <div class="pt-3">
                                                    <button
                                                        type="button"
                                                        @click="removeWeightOption(index)"
                                                        v-if="weightOptions.length > 1"
                                                        class="text-xs text-red-500 hover:text-red-700 p-1.5 rounded hover:bg-red-50 dark:hover:bg-gray-800 font-bold"
                                                        title="Remove this pack size"
                                                    >
                                                        ✕
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Multiple Images Section -->
                                    <div class="mb-4 rounded-lg border border-gray-200 bg-gray-50/70 p-3.5 dark:border-gray-700 dark:bg-gray-800/40">
                                        <div class="flex items-center justify-between mb-2.5 flex-wrap gap-2">
                                            <div>
                                                <p class="text-sm font-bold text-gray-800 dark:text-gray-100 flex items-center gap-1.5">
                                                    <span>🖼️</span> Product Images (@{{ images.length }} Added)
                                                </p>
                                                <p class="text-xs text-gray-500 dark:text-gray-400">
                                                    Add multiple images (front pouch, back, ingredients, raw seeds bowl). First image is cover.
                                                </p>
                                            </div>
                                        </div>

                                        <!-- Controls to Add Multiple Images -->
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-3">
                                            <!-- Multi File Upload from Computer -->
                                            <div class="rounded-md border border-dashed border-amber-300 bg-amber-50/40 p-2.5 dark:border-gray-600 dark:bg-gray-800/40">
                                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-200 mb-1">
                                                    📁 Upload Multiple Images from Device
                                                </label>
                                                <input
                                                    type="file"
                                                    ref="fileInput"
                                                    multiple
                                                    @change="handleMultipleFileUpload($event)"
                                                    accept="image/*"
                                                    class="block w-full text-xs text-gray-500 file:mr-2 file:py-1 file:px-2.5 file:rounded file:border-0 file:text-xs file:font-bold file:bg-amber-600 file:text-white hover:file:bg-amber-700 cursor-pointer"
                                                />
                                                <span v-if="isUploading" class="inline-block mt-1 text-xs text-amber-600 font-bold animate-pulse">
                                                    Uploading photos...
                                                </span>
                                            </div>

                                            <!-- Add from Presets -->
                                            <div class="rounded-md border border-gray-200 bg-white p-2.5 dark:border-gray-700 dark:bg-gray-800">
                                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-200 mb-1">
                                                    🎨 Add from Signature Presets
                                                </label>
                                                <div class="flex gap-2">
                                                    <select
                                                        v-model="presetToAdd"
                                                        class="flex-1 rounded border border-gray-300 bg-white px-2 py-1 text-xs text-gray-700 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-200"
                                                    >
                                                        <option value="assets/magicbland.png">Magic Blend Pouch (Gold)</option>
                                                        <option value="assets/chilli.png">Red Chilli Powder Pouch (Red)</option>
                                                        <option value="assets/garammasala.png">Garam Masala Pouch (Brown)</option>
                                                        <option value="assets/step_01_sourced.png">Whole Spices / Bowl</option>
                                                        <option value="assets/spices.png">Mortar & Pestle Raw Spices</option>
                                                        <option value="assets/craft.png">Artisanal Roasted Blend Pouch</option>
                                                    </select>
                                                    <button
                                                        type="button"
                                                        @click="addPresetImage"
                                                        class="text-xs bg-gray-800 text-white hover:bg-black px-2.5 py-1 rounded font-bold transition-all dark:bg-gray-700 dark:hover:bg-gray-600"
                                                    >
                                                        + Add
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Multi-Image Gallery Grid with Cover selector & Delete -->
                                        <div v-if="images.length > 0">
                                            <p class="text-[11px] font-bold text-gray-500 dark:text-gray-400 mb-1.5 uppercase tracking-wider">
                                                Added Product Photos (@{{ images.length }}) &bull; Click any photo to make it the Main Cover:
                                            </p>

                                            <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 gap-2.5">
                                                <div
                                                    v-for="(imgSrc, idx) in images"
                                                    :key="idx"
                                                    class="group relative rounded-md border p-1 bg-white dark:border-gray-700 dark:bg-gray-900 transition-all cursor-pointer hover:shadow-md"
                                                    :class="idx === 0 ? 'border-amber-500 ring-2 ring-amber-500 bg-amber-50/20' : 'hover:border-gray-400'"
                                                    @click="setPrimaryImage(idx)"
                                                    :title="idx === 0 ? 'Primary Cover Photo' : 'Click to set as Main Cover Photo'"
                                                >
                                                    <img :src="imgSrc.startsWith('http') || imgSrc.startsWith('/') ? imgSrc : '/' + imgSrc" class="h-16 w-full rounded object-contain bg-gray-50 dark:bg-gray-800" alt="Product photo">
                                                    
                                                    <!-- Primary Cover Badge -->
                                                    <span
                                                        v-if="idx === 0"
                                                        class="absolute bottom-1 left-1 right-1 text-center bg-amber-600 text-white text-[9px] font-extrabold rounded py-0.5 tracking-wide shadow"
                                                    >
                                                        ★ COVER
                                                    </span>

                                                    <!-- Remove Button -->
                                                    <button
                                                        type="button"
                                                        @click.stop="removeImage(idx)"
                                                        class="absolute -top-1.5 -right-1.5 bg-red-600 hover:bg-red-700 text-white rounded-full w-4 h-4 flex items-center justify-center text-[10px] font-bold shadow"
                                                        title="Delete photo"
                                                    >
                                                        ✕
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div v-else class="rounded border border-dashed border-gray-300 p-3 text-center text-xs text-gray-500 bg-white dark:bg-gray-900 dark:border-gray-700">
                                            📷 No photos added yet. Upload photos from your device or add a preset above.
                                        </div>
                                    </div>

                                    <!-- Tagline / Short Description -->
                                    <x-admin::form.control-group class="mb-3">
                                        <x-admin::form.control-group.label class="font-semibold text-gray-700 dark:text-gray-200">
                                            Short Tagline
                                        </x-admin::form.control-group.label>

                                        <x-admin::form.control-group.control
                                            type="text"
                                            name="short_description"
                                            label="Short Description"
                                            placeholder="e.g. Handcrafted royal blend crafted for rich aroma and depth"
                                        />

                                        <x-admin::form.control-group.error control-name="short_description" />
                                    </x-admin::form.control-group>

                                    <!-- Full Description -->
                                    <x-admin::form.control-group class="mb-3">
                                        <x-admin::form.control-group.label class="font-semibold text-gray-700 dark:text-gray-200">
                                            Full Product Description
                                        </x-admin::form.control-group.label>

                                        <x-admin::form.control-group.control
                                            type="textarea"
                                            name="description"
                                            label="Description"
                                            rows="3"
                                            placeholder="100% pure single-origin Indian spices. Sealed to preserve natural essential oils and authentic fragrance."
                                        />

                                        <x-admin::form.control-group.error control-name="description" />
                                    </x-admin::form.control-group>


                                    {!! view_render_event('bagisto.admin.catalog.products.create_form.general.controls.after') !!}
                                </div>
                            </x-slot>

                            <!-- Modal Footer -->
                            <x-slot:footer>
                                <div class="flex items-center gap-x-2.5">
                                    <button
                                        type="button"
                                        class="transparent-button hover:bg-gray-200 dark:text-white dark:hover:bg-gray-800"
                                        @click="$refs.productCreateModal.close()"
                                    >
                                        Cancel
                                    </button>

                                    <!-- Save Button -->
                                    <x-admin::button
                                        button-type="submit"
                                        class="primary-button"
                                        title="Save & Add Product"
                                        ::loading="isLoading"
                                        ::disabled="isLoading"
                                    />
                                </div>
                            </x-slot>
                        </x-admin::modal>
                    </form>
                </x-admin::form>
            </div>
        </script>

        <script type="module">
            app.component('v-create-product-form', {
                template: '#v-create-product-form-template',

                data() {
                    return {
                        attributes: [],
                        superAttributes: {},
                        isLoading: false,

                        // Dynamic Weights & Prices
                        weightOptions: [
                            { weight: '100g', price: 95, isDefault: false },
                            { weight: '250g', price: 195, isDefault: true },
                            { weight: '500g', price: 360, isDefault: false }
                        ],

                        // Multiple Images
                        images: [],
                        presetToAdd: 'assets/magicbland.png',
                        isUploading: false,
                    };
                },

                methods: {
                    addWeightOption() {
                        const known = ['100g', '250g', '500g', '1kg', '50g', '200g', '1.5kg'];
                        const used = this.weightOptions.map(w => w.weight);
                        const next = known.find(k => !used.includes(k)) || '1kg';
                        this.weightOptions.push({
                            weight: next,
                            price: 195,
                            isDefault: false
                        });
                    },

                    removeWeightOption(index) {
                        if (this.weightOptions.length <= 1) return;
                        const wasDefault = this.weightOptions[index].isDefault;
                        this.weightOptions.splice(index, 1);
                        if (wasDefault && this.weightOptions.length > 0) {
                            this.weightOptions[0].isDefault = true;
                        }
                    },

                    setDefaultWeight(index) {
                        this.weightOptions.forEach((w, i) => {
                            w.isDefault = (i === index);
                        });
                    },

                    handleMultipleFileUpload(event) {
                        const files = event.target.files;
                        if (!files || !files.length) return;

                        const formData = new FormData();
                        for (let i = 0; i < files.length; i++) {
                            formData.append('images[]', files[i]);
                        }
                        this.isUploading = true;

                        this.$axios.post('/api/upload-image', formData, {
                            headers: { 'Content-Type': 'multipart/form-data' }
                        })
                        .then(res => {
                            this.isUploading = false;
                            if (res.data && res.data.images && res.data.images.length > 0) {
                                res.data.images.forEach(img => {
                                    if (img.path && !this.images.includes(img.path)) {
                                        this.images.push(img.path);
                                    }
                                });
                            } else if (res.data && res.data.path) {
                                if (!this.images.includes(res.data.path)) {
                                    this.images.push(res.data.path);
                                }
                            }
                            if (this.$refs.fileInput) {
                                this.$refs.fileInput.value = '';
                            }
                        })
                        .catch(err => {
                            this.isUploading = false;
                            console.error('Multiple image upload failed:', err);
                            alert('Failed to upload image. Please try again.');
                        });
                    },

                    addPresetImage() {
                        if (this.presetToAdd && !this.images.includes(this.presetToAdd)) {
                            this.images.push(this.presetToAdd);
                        }
                    },

                    removeImage(index) {
                        this.images.splice(index, 1);
                    },

                    setPrimaryImage(index) {
                        if (index === 0) return;
                        const primary = this.images.splice(index, 1)[0];
                        this.images.unshift(primary);
                    },

                    create(params, { resetForm, resetField, setErrors }) {
                        this.isLoading = true;

                        params.type = params.type || 'simple';
                        params.attribute_family_id = params.attribute_family_id || 1;

                        // Dynamic pack prices serialization
                        const defaultPack = this.weightOptions.find(w => w.isDefault) || this.weightOptions[0];
                        params.pack_prices = JSON.stringify(this.weightOptions.map(w => ({
                            weight: w.weight,
                            price: parseFloat(w.price) || 0,
                            strike: Math.round((parseFloat(w.price) || 0) * 1.25),
                            active: !!w.isDefault
                        })));
                        params.default_weight = defaultPack ? defaultPack.weight : '250g';
                        params.weight = params.default_weight;
                        params.price = defaultPack ? (parseFloat(defaultPack.price) || 195) : 195;

                        // Pass Multiple Images array
                        params.images = this.images;
                        params.image = this.images.length > 0 ? this.images[0] : 'assets/magicbland.png';

                        this.attributes.forEach(attribute => {
                            params.super_attributes ||= {};

                            params.super_attributes[attribute.code] = this.superAttributes[attribute.code];
                        });

                        this.$axios.post("{{ route('admin.catalog.products.store') }}", params)
                            .then((response) => {
                                this.isLoading = false;

                                if (response.data.data.redirect_url) {
                                    window.location.href = response.data.data.redirect_url;
                                } else {
                                    this.attributes = response.data.data.attributes;

                                    this.setSuperAttributes();
                                }
                            })
                            .catch(error => {
                                this.isLoading = false;

                                if (error.response && error.response.status == 422) {
                                    setErrors(error.response.data.errors);
                                }
                            });
                    },

                    removeOption(option) {
                        this.attributes.forEach(attribute => {
                            attribute.options = attribute.options.filter(item => item.id != option.id);
                        });

                        this.attributes = this.attributes.filter(attribute => attribute.options.length > 0);

                        this.setSuperAttributes();
                    },

                    setSuperAttributes() {
                        this.superAttributes = {};

                        this.attributes.forEach(attribute => {
                            this.superAttributes[attribute.code] = [];

                            attribute.options.forEach(option => {
                                this.superAttributes[attribute.code].push(option.id);
                            });
                        });
                    }
                }
            })
        </script>
    @endPushOnce
</x-admin::layouts>
