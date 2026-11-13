<x-admin::layouts>
    <x-slot:title>
        Edit Product: {{ $prodData['name'] }}
    </x-slot>

    <div class="flex flex-col gap-4">
        <!-- Edit Product Vue Component -->
        <v-edit-product-form :initial-data="{{ json_encode($prodData) }}"></v-edit-product-form>
    </div>

    @pushOnce('scripts')
        <script type="text/x-template" id="v-edit-product-form-template">
            <div class="max-w-5xl mx-auto w-full">
                <!-- Page Header Bar -->
                <div class="flex items-center justify-between gap-4 mb-5 flex-wrap">
                    <div>
                        <!-- Breadcrumbs -->
                        <div class="flex items-center gap-1.5 text-xs text-gray-500 mb-1">
                            <a href="{{ route('admin.catalog.products.index') }}" class="hover:text-amber-700 transition-colors">Products</a>
                            <span>/</span>
                            <span class="text-gray-800 font-semibold dark:text-gray-200">Edit Product</span>
                        </div>

                        <div class="flex items-center gap-3">
                            <h1 class="text-2xl font-extrabold text-gray-900 dark:text-white">
                                Edit: @{{ form.name || 'Product' }}
                            </h1>
                            <span v-if="form.sku" class="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded font-mono border dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700">
                                SKU: @{{ form.sku }}
                            </span>
                        </div>
                    </div>

                    <!-- Header Action Buttons -->
                    <div class="flex items-center gap-2.5">
                        <a
                            href="{{ route('admin.catalog.products.index') }}"
                            class="transparent-button hover:bg-gray-200 dark:text-white dark:hover:bg-gray-800 px-4 py-2 text-sm font-semibold rounded border border-gray-300 dark:border-gray-600 transition-all inline-flex items-center gap-1"
                        >
                            <span>←</span> Back to Products
                        </a>

                        <button
                            type="button"
                            @click="save"
                            :disabled="isLoading || isUploading"
                            class="primary-button bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-2 text-sm rounded shadow transition-all flex items-center gap-2 disabled:opacity-60"
                        >
                            <span v-if="isLoading" class="animate-spin text-sm">⏳</span>
                            <span>@{{ isLoading ? 'Saving Changes...' : 'Save & Update Product' }}</span>
                        </button>
                    </div>
                </div>

                <!-- Main Form Card (Matches Create Product Form) -->
                <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6 dark:bg-gray-900 dark:border-gray-800">
                    <!-- Product Name Input -->
                    <div class="mb-4">
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">
                            Spice / Product Name <span class="text-red-500">*</span>
                        </label>
                        <input
                            type="text"
                            v-model="form.name"
                            placeholder="e.g. Royal Shahi Biryani Masala"
                            class="w-full rounded-lg border border-gray-300 bg-white p-2.5 text-sm font-medium text-gray-800 transition-all focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
                            required
                        />
                    </div>

                    <!-- Category & Stock Quantity (2-Column Grid) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <!-- Category Selection -->
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">
                                Category <span class="text-red-500">*</span>
                            </label>
                            <select
                                v-model="form.category_id"
                                class="w-full rounded-lg border border-gray-300 bg-white p-2.5 text-sm font-medium text-gray-800 transition-all focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
                            >
                                <option :value="2">Whole Spices (Seeds, Berries, Pods)</option>
                                <option :value="3">Blended Spices (Royal Masalas & Blends)</option>
                                <option :value="4">Grinded Spices (Cold-Pulverized Powders)</option>
                            </select>
                        </div>

                        <!-- Stock Quantity -->
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">
                                Stock Quantity (Available Units) <span class="text-red-500">*</span>
                            </label>
                            <input
                                type="number"
                                v-model.number="form.quantity"
                                placeholder="100"
                                class="w-full rounded-lg border border-gray-300 bg-white p-2.5 text-sm font-medium text-gray-800 transition-all focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
                            />
                        </div>
                    </div>

                    <!-- Weight & Price Options Builder (Select Weight and Set Price Differently) -->
                    <div class="mb-5 rounded-lg border border-amber-300 bg-amber-50/40 p-4 dark:border-gray-700 dark:bg-gray-800/40">
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
                                class="text-xs font-bold text-amber-800 bg-amber-100 hover:bg-amber-200 border border-amber-300 rounded px-3 py-1.5 transition-all flex items-center gap-1 shadow-sm dark:bg-gray-700 dark:text-amber-300 dark:border-gray-600"
                            >
                                <span>+</span> Add Another Pack Size
                            </button>
                        </div>

                        <div class="space-y-2.5">
                            <div
                                v-for="(item, index) in form.weightOptions"
                                :key="index"
                                class="flex items-center gap-2.5 rounded-md border p-2.5 bg-white dark:border-gray-700 dark:bg-gray-900 transition-all shadow-xs"
                                :class="{'border-amber-400 ring-1 ring-amber-400 bg-amber-50/20': item.isDefault}"
                            >
                                <!-- Weight Selector -->
                                <div class="w-2/5">
                                    <label class="block text-[10px] font-bold text-gray-500 dark:text-gray-400 mb-0.5">
                                        Select Weight
                                    </label>
                                    <select
                                        v-model="item.weight"
                                        class="w-full rounded border border-gray-300 bg-white p-2 text-xs font-semibold text-gray-800 dark:border-gray-600 dark:bg-gray-800 dark:text-white"
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
                                        <span class="px-2.5 text-xs font-bold text-gray-400">₹</span>
                                        <input
                                            type="number"
                                            v-model.number="item.price"
                                            placeholder="e.g. 195"
                                            class="w-full p-2 text-xs font-bold text-gray-800 dark:text-white dark:bg-gray-800 focus:outline-none"
                                        />
                                    </div>
                                </div>

                                <!-- Default Pack Button -->
                                <div class="flex-1 flex items-center justify-center pt-3">
                                    <button
                                        type="button"
                                        @click="setDefaultWeight(index)"
                                        class="text-[11px] px-2.5 py-1.5 rounded font-semibold transition-all border whitespace-nowrap"
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
                                        v-if="form.weightOptions.length > 1"
                                        class="text-xs text-red-500 hover:text-red-700 p-2 rounded hover:bg-red-50 dark:hover:bg-gray-800 font-bold"
                                        title="Remove this pack size"
                                    >
                                        ✕
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Multiple Images Section -->
                    <div class="mb-5 rounded-lg border border-gray-200 bg-gray-50/70 p-4 dark:border-gray-700 dark:bg-gray-800/40">
                        <div class="flex items-center justify-between mb-3 flex-wrap gap-2">
                            <div>
                                <p class="text-sm font-bold text-gray-800 dark:text-gray-100 flex items-center gap-1.5">
                                    <span>🖼️</span> Product Images (@{{ form.images.length }} Added)
                                </p>
                                <p class="text-xs text-gray-500 dark:text-gray-400">
                                    Add multiple images (front pouch, back, ingredients, raw seeds). The first image is the main cover.
                                </p>
                            </div>
                        </div>

                        <!-- Controls to Add Multiple Images -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-3">
                            <!-- Multi File Upload from Computer -->
                            <div class="rounded-md border border-dashed border-amber-300 bg-amber-50/40 p-3 dark:border-gray-600 dark:bg-gray-800/40">
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                    📁 Upload Multiple Images from Device
                                </label>
                                <input
                                    type="file"
                                    ref="fileInput"
                                    multiple
                                    @change="handleMultipleFileUpload($event)"
                                    accept="image/*"
                                    class="block w-full text-xs text-gray-500 file:mr-2.5 file:py-1.5 file:px-3 file:rounded file:border-0 file:text-xs file:font-bold file:bg-amber-600 file:text-white hover:file:bg-amber-700 cursor-pointer"
                                />
                                <span v-if="isUploading" class="inline-block mt-1 text-xs text-amber-600 font-bold animate-pulse">
                                    Uploading photos...
                                </span>
                            </div>

                            <!-- Add from Presets -->
                            <div class="rounded-md border border-gray-200 bg-white p-3 dark:border-gray-700 dark:bg-gray-800">
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                    🎨 Add from Signature Presets
                                </label>
                                <div class="flex gap-2">
                                    <select
                                        v-model="presetToAdd"
                                        class="flex-1 rounded border border-gray-300 bg-white px-2.5 py-1.5 text-xs text-gray-700 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-200"
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
                                        class="text-xs bg-gray-800 text-white hover:bg-black px-3 py-1.5 rounded font-bold transition-all dark:bg-gray-700 dark:hover:bg-gray-600"
                                    >
                                        + Add
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Multi-Image Gallery Grid with Cover selector & Delete -->
                        <div v-if="form.images.length > 0">
                            <p class="text-[11px] font-bold text-gray-500 dark:text-gray-400 mb-2 uppercase tracking-wider">
                                Added Photos (@{{ form.images.length }}) &bull; Click any photo to make it the Main Cover:
                            </p>

                            <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 gap-3">
                                <div
                                    v-for="(imgSrc, idx) in form.images"
                                    :key="idx"
                                    class="group relative rounded-lg border p-1 bg-white dark:border-gray-700 dark:bg-gray-900 transition-all cursor-pointer hover:shadow-md"
                                    :class="idx === 0 ? 'border-amber-500 ring-2 ring-amber-500 bg-amber-50/20' : 'hover:border-gray-400'"
                                    @click="setPrimaryImage(idx)"
                                    :title="idx === 0 ? 'Primary Cover Photo' : 'Click to set as Main Cover Photo'"
                                >
                                    <img :src="imgSrc.startsWith('http') ? imgSrc : (imgSrc.startsWith('assets/products/syd_') ? '/storage/products/' + imgSrc.replace('assets/products/', '') : (imgSrc.startsWith('/') ? imgSrc : '/' + imgSrc))" class="h-20 w-full rounded object-contain bg-gray-50 dark:bg-gray-800" alt="Product photo">
                                    
                                    <!-- Primary Cover Badge -->
                                    <span
                                        v-if="idx === 0"
                                        class="absolute bottom-1.5 left-1.5 right-1.5 text-center bg-amber-600 text-white text-[9px] font-extrabold rounded py-0.5 tracking-wide shadow"
                                    >
                                        ★ COVER
                                    </span>

                                    <!-- Remove Button -->
                                    <button
                                        type="button"
                                        @click.stop="removeImage(idx)"
                                        class="absolute -top-1.5 -right-1.5 bg-red-600 hover:bg-red-700 text-white rounded-full w-5 h-5 flex items-center justify-center text-[10px] font-bold shadow transition-all"
                                        title="Delete photo"
                                    >
                                        ✕
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div v-else class="rounded border border-dashed border-gray-300 p-4 text-center text-xs text-gray-500 bg-white dark:bg-gray-900 dark:border-gray-700">
                            📷 No photos added yet. Upload photos from your device or select a preset above.
                        </div>
                    </div>

                    <!-- Short Tagline -->
                    <div class="mb-4">
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">
                            Short Tagline
                        </label>
                        <input
                            type="text"
                            v-model="form.short_description"
                            placeholder="e.g. Handcrafted royal blend crafted for rich aroma and depth"
                            class="w-full rounded-lg border border-gray-300 bg-white p-2.5 text-sm font-medium text-gray-800 transition-all focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
                        />
                    </div>

                    <!-- Full Description -->
                    <div class="mb-6">
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">
                            Full Product Description
                        </label>
                        <textarea
                            v-model="form.description"
                            rows="4"
                            placeholder="100% pure single-origin Indian spices. Sealed to preserve natural essential oils and authentic fragrance."
                            class="w-full rounded-lg border border-gray-300 bg-white p-2.5 text-sm font-medium text-gray-800 transition-all focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
                        ></textarea>
                    </div>

                    <!-- Form Footer Buttons -->
                    <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
                        <a
                            href="{{ route('admin.catalog.products.index') }}"
                            class="transparent-button hover:bg-gray-200 dark:text-white dark:hover:bg-gray-800 px-5 py-2 text-sm font-semibold rounded border border-gray-300 dark:border-gray-600 transition-all"
                        >
                            Cancel
                        </a>

                        <button
                            type="button"
                            @click="save"
                            :disabled="isLoading || isUploading"
                            class="primary-button bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-2 text-sm rounded shadow transition-all flex items-center gap-2 disabled:opacity-60"
                        >
                            <span v-if="isLoading" class="animate-spin text-sm">⏳</span>
                            <span>@{{ isLoading ? 'Saving Changes...' : 'Save & Update Product' }}</span>
                        </button>
                    </div>
                </div>
            </div>
        </script>

        <script type="module">
            app.component('v-edit-product-form', {
                template: '#v-edit-product-form-template',

                props: ['initialData'],

                data() {
                    return {
                        isLoading: false,
                        isUploading: false,
                        presetToAdd: 'assets/magicbland.png',
                        form: {
                            id: this.initialData.id,
                            name: this.initialData.name || '',
                            sku: this.initialData.sku || '',
                            category_id: this.initialData.category_id || 2,
                            quantity: this.initialData.quantity || 100,
                            short_description: this.initialData.short_description || '',
                            description: this.initialData.description || '',
                            weightOptions: (this.initialData.weightOptions && this.initialData.weightOptions.length > 0)
                                ? this.initialData.weightOptions
                                : [
                                    { weight: '100g', price: 95, isDefault: false },
                                    { weight: '250g', price: 195, isDefault: true },
                                    { weight: '500g', price: 360, isDefault: false }
                                ],
                            images: (this.initialData.images && Array.isArray(this.initialData.images))
                                ? [...this.initialData.images]
                                : []
                        }
                    };
                },

                methods: {
                    addWeightOption() {
                        const known = ['100g', '250g', '500g', '1kg', '50g', '200g', '1.5kg'];
                        const used = this.form.weightOptions.map(w => w.weight);
                        const next = known.find(k => !used.includes(k)) || '1kg';
                        this.form.weightOptions.push({
                            weight: next,
                            price: 195,
                            isDefault: false
                        });
                    },

                    removeWeightOption(index) {
                        if (this.form.weightOptions.length <= 1) return;
                        const wasDefault = this.form.weightOptions[index].isDefault;
                        this.form.weightOptions.splice(index, 1);
                        if (wasDefault && this.form.weightOptions.length > 0) {
                            this.form.weightOptions[0].isDefault = true;
                        }
                    },

                    setDefaultWeight(index) {
                        this.form.weightOptions.forEach((w, i) => {
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
                                    if (img.path && !this.form.images.includes(img.path)) {
                                        this.form.images.push(img.path);
                                    }
                                });
                            } else if (res.data && res.data.path) {
                                if (!this.form.images.includes(res.data.path)) {
                                    this.form.images.push(res.data.path);
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
                        if (this.presetToAdd && !this.form.images.includes(this.presetToAdd)) {
                            this.form.images.push(this.presetToAdd);
                        }
                    },

                    removeImage(index) {
                        this.form.images.splice(index, 1);
                    },

                    setPrimaryImage(index) {
                        if (index === 0) return;
                        const primary = this.form.images.splice(index, 1)[0];
                        this.form.images.unshift(primary);
                    },

                    save() {
                        if (!this.form.name || !this.form.name.trim()) {
                            alert('Please enter a product name.');
                            return;
                        }

                        this.isLoading = true;

                        const defaultPack = this.form.weightOptions.find(w => w.isDefault) || this.form.weightOptions[0];
                        const packPricesJson = JSON.stringify(this.form.weightOptions.map(w => ({
                            weight: w.weight,
                            price: parseFloat(w.price) || 0,
                            strike: Math.round((parseFloat(w.price) || 0) * 1.25),
                            active: !!w.isDefault
                        })));

                        const payload = {
                            _token: "{{ csrf_token() }}",
                            _method: 'PUT',
                            name: this.form.name.trim(),
                            category_id: this.form.category_id,
                            quantity: this.form.quantity || 100,
                            pack_prices: packPricesJson,
                            default_weight: defaultPack ? defaultPack.weight : '250g',
                            weight: defaultPack ? defaultPack.weight : '250g',
                            price: defaultPack ? (parseFloat(defaultPack.price) || 195) : 195,
                            images: this.form.images,
                            image: this.form.images.length > 0 ? this.form.images[0] : '',
                            short_description: this.form.short_description || '',
                            description: this.form.description || ''
                        };

                        this.$axios.put("{{ route('admin.catalog.products.update', $product->id) }}", payload)
                            .then(response => {
                                this.isLoading = false;
                                window.location.href = "{{ route('admin.catalog.products.index') }}";
                            })
                            .catch(error => {
                                this.isLoading = false;
                                console.error('Product update failed:', error);
                                const msg = error.response && error.response.data && error.response.data.message
                                    ? error.response.data.message
                                    : 'Failed to update product. Please try again.';
                                alert(msg);
                            });
                    }
                }
            });
        </script>
    @endPushOnce
</x-admin::layouts>
