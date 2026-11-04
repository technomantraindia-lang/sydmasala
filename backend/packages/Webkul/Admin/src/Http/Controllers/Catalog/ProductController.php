<?php

namespace Webkul\Admin\Http\Controllers\Catalog;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\View\View;
use Webkul\Admin\DataGrids\Catalog\ProductDataGrid;
use Webkul\Admin\Http\Controllers\Controller;
use Webkul\Admin\Http\Requests\InventoryRequest;
use Webkul\Admin\Http\Requests\MassDestroyRequest;
use Webkul\Admin\Http\Requests\MassUpdateRequest;
use Webkul\Admin\Http\Requests\ProductForm;
use Webkul\Admin\Http\Resources\AttributeResource;
use Webkul\Admin\Http\Resources\ProductResource;
use Webkul\Attribute\Repositories\AttributeFamilyRepository;
use Webkul\Core\Rules\Slug;
use Webkul\Customer\Repositories\CustomerRepository;
use Webkul\Product\Helpers\Product;
use Webkul\Product\Helpers\ProductType;
use Webkul\Product\Repositories\ProductAttributeValueRepository;
use Webkul\Product\Repositories\ProductDownloadableLinkRepository;
use Webkul\Product\Repositories\ProductDownloadableSampleRepository;
use Webkul\Product\Repositories\ProductInventoryRepository;
use Webkul\Product\Repositories\ProductRepository;

class ProductController extends Controller
{
    /**
     * Using const variable for status.
     */
    const ACTIVE_STATUS = 1;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct(
        protected AttributeFamilyRepository $attributeFamilyRepository,
        protected ProductAttributeValueRepository $productAttributeValueRepository,
        protected ProductDownloadableLinkRepository $productDownloadableLinkRepository,
        protected ProductDownloadableSampleRepository $productDownloadableSampleRepository,
        protected ProductInventoryRepository $productInventoryRepository,
        protected ProductRepository $productRepository,
        protected CustomerRepository $customerRepository,
    ) {}

    /**
     * Display a listing of the resource.
     *
     * @return View
     */
    public function index()
    {
        if (request()->ajax()) {
            return datagrid(ProductDataGrid::class)->process();
        }

        $families = $this->attributeFamilyRepository->all();

        return view('admin::catalog.products.index', compact('families'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return View
     */
    public function create()
    {
        $families = $this->attributeFamilyRepository->all();

        $configurableFamily = null;

        if ($familyId = request()->get('family')) {
            $configurableFamily = $this->attributeFamilyRepository->find($familyId);
        }

        return view('admin::catalog.products.create', compact('families', 'configurableFamily'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return JsonResponse
     */
    public function store()
    {
        // 1. Direct Spice Product Creation (One-Step Admin Creation)
        if (request()->has('name') && ! empty(request()->input('name'))) {
            $this->validate(request(), [
                'name'        => 'required|string|max:200',
                'price'       => 'required|numeric|min:1',
                'category_id' => 'nullable|integer',
                'sku'         => 'nullable|string|max:100',
            ]);

            $name = trim(request()->input('name'));

            // 1. Pack sizes and pricing options (Dynamic weight selection & prices)
            $packPricesJson = request()->input('pack_prices', '');
            if (! empty($packPricesJson)) {
                if (is_array($packPricesJson)) {
                    $decodedPacks = $packPricesJson;
                    $packPricesJson = json_encode($packPricesJson);
                } else {
                    $decodedPacks = json_decode($packPricesJson, true);
                }

                if (is_array($decodedPacks) && count($decodedPacks) > 0) {
                    $normalizedPacks = [];
                    foreach ($decodedPacks as $pack) {
                        $pPrice = (float) ($pack['price'] ?? 195);
                        $isAct = !empty($pack['active']) || !empty($pack['isDefault']);
                        $normalizedPacks[] = [
                            'weight' => (string) ($pack['weight'] ?? '250g'),
                            'price'  => $pPrice,
                            'strike' => (float) round($pPrice * 1.25),
                            'active' => $isAct,
                        ];
                    }
                    if (! collect($normalizedPacks)->contains('active', true) && count($normalizedPacks) > 0) {
                        $normalizedPacks[0]['active'] = true;
                    }
                    $defaultPack = collect($normalizedPacks)->firstWhere('active', true) ?: $normalizedPacks[0];
                    $price = (float) ($defaultPack['price'] ?? 195);
                    $weight = (string) ($defaultPack['weight'] ?? '250g');
                    $packPricesJson = json_encode($normalizedPacks);
                }
            } else {
                $p250 = request()->filled('price_250g') ? (float) request()->input('price_250g') : (float) request()->input('price', 195);
                $p100 = request()->filled('price_100g') ? (float) request()->input('price_100g') : (float) round($p250 * 0.50);
                $p500 = request()->filled('price_500g') ? (float) request()->input('price_500g') : (float) round($p250 * 1.85);

                $defaultWeight = trim(request()->input('default_weight', request()->input('weight', '250g')));
                $price = ($defaultWeight === '100g') ? $p100 : (($defaultWeight === '500g') ? $p500 : $p250);
                $weight = $defaultWeight;

                $packPricesJson = json_encode([
                    ['weight' => '100g', 'price' => $p100, 'strike' => (float) round($p100 * 1.25), 'active' => ($defaultWeight === '100g')],
                    ['weight' => '250g', 'price' => $p250, 'strike' => (float) round($p250 * 1.25), 'active' => ($defaultWeight === '250g')],
                    ['weight' => '500g', 'price' => $p500, 'strike' => (float) round($p500 * 1.25), 'active' => ($defaultWeight === '500g')],
                ]);
            }

            $sku = trim(request()->input('sku', ''));
            if (empty($sku)) {
                $sku = Str::slug($name) . '-' . rand(100, 999);
            }
            if (DB::table('products')->where('sku', $sku)->exists()) {
                $sku = $sku . '-' . rand(10, 99);
            }
            $urlKey = Str::slug($name);

            $catId = (int) request()->input('category_id', 2);
            if (! in_array($catId, [2, 3, 4])) {
                $catId = 2;
            }
            $catNames = [2 => 'Whole Spices', 3 => 'Blended Spices', 4 => 'Grinded Spices'];
            $catName = $catNames[$catId] ?? 'Whole Spices';

            $desc = trim(request()->input('description', "100% pure single-origin {$name}."));
            $shortDesc = trim(request()->input('short_description', "Handpicked unpolished {$name}."));

            // 2. Multiple Images Handling (Array of images, uploads, presets)
            $images = request()->input('images', []);
            if (is_string($images)) {
                $decodedImgs = json_decode($images, true);
                if (is_array($decodedImgs)) {
                    $images = $decodedImgs;
                } else {
                    $images = array_filter(array_map('trim', explode(',', $images)));
                }
            }
            if (! is_array($images)) {
                $images = [];
            }

            $singleImage = trim(request()->input('image', ''));
            if (! empty($singleImage) && ! in_array($singleImage, $images)) {
                array_unshift($images, $singleImage);
            }

            if (request()->hasFile('image_files')) {
                $files = request()->file('image_files');
                if (! is_array($files)) $files = [$files];
                foreach ($files as $imgFile) {
                    $ext = strtolower($imgFile->getClientOriginalExtension() ?: 'png');
                    $fn = 'syd_' . time() . '_' . Str::random(6) . '.' . $ext;
                    $backendDir = public_path('storage/products');
                    if (! File::exists($backendDir)) {
                        File::makeDirectory($backendDir, 0755, true);
                    }
                    $imgFile->move($backendDir, $fn);
                    $frontendDir = base_path('../assets/products');
                    if (! File::exists($frontendDir)) {
                        File::makeDirectory($frontendDir, 0755, true);
                    }
                    try {
                        File::copy($backendDir . '/' . $fn, $frontendDir . '/' . $fn);
                    } catch (\Exception $e) {}
                    $images[] = 'assets/products/' . $fn;
                }
            } elseif (request()->hasFile('image_file')) {
                $imgFile = request()->file('image_file');
                $ext = strtolower($imgFile->getClientOriginalExtension() ?: 'png');
                $fn = 'syd_' . time() . '_' . Str::random(6) . '.' . $ext;
                $backendDir = public_path('storage/products');
                if (! File::exists($backendDir)) {
                    File::makeDirectory($backendDir, 0755, true);
                }
                $imgFile->move($backendDir, $fn);
                $frontendDir = base_path('../assets/products');
                if (! File::exists($frontendDir)) {
                    File::makeDirectory($frontendDir, 0755, true);
                }
                try {
                    File::copy($backendDir . '/' . $fn, $frontendDir . '/' . $fn);
                } catch (\Exception $e) {}
                $images[] = 'assets/products/' . $fn;
            }

            if (empty($images)) {
                $imageMap = [
                    2 => 'assets/step_01_sourced.png',
                    3 => 'assets/magicbland.png',
                    4 => 'assets/chilli.png',
                ];
                $images = [$imageMap[$catId] ?? 'assets/step_01_sourced.png'];
            }
            $image = $images[0];
            $qty = (int) request()->input('quantity', 100);

            DB::beginTransaction();
            try {
                $prodId = DB::table('products')->insertGetId([
                    'sku'                 => $sku,
                    'type'                => 'simple',
                    'attribute_family_id' => 1,
                    'created_at'          => now(),
                    'updated_at'          => now(),
                ]);

                DB::table('product_channels')->insert([
                    'product_id' => $prodId,
                    'channel_id' => 1,
                ]);

                DB::table('product_categories')->insert([
                    'product_id'  => $prodId,
                    'category_id' => $catId,
                ]);

                DB::table('product_inventories')->insert([
                    'qty'                 => $qty,
                    'product_id'          => $prodId,
                    'vendor_id'           => 0,
                    'inventory_source_id' => 1,
                ]);

                DB::table('product_inventory_indices')->insert([
                    'qty'        => $qty,
                    'product_id' => $prodId,
                    'channel_id' => 1,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                DB::table('product_price_indices')->insert([
                    'product_id'        => $prodId,
                    'customer_group_id' => 1,
                    'channel_id'        => 1,
                    'min_price'         => $price,
                    'regular_min_price' => $price,
                    'max_price'         => $price,
                    'regular_max_price' => $price,
                    'created_at'        => now(),
                    'updated_at'        => now(),
                ]);

                foreach ($images as $pos => $imgPath) {
                    if (! empty($imgPath)) {
                        DB::table('product_images')->insert([
                            'type'       => 'images',
                            'path'       => $imgPath,
                            'product_id' => $prodId,
                            'position'   => $pos + 1,
                        ]);
                    }
                }

                $attrs = [
                    ['attribute_id' => 1,  'channel' => null,      'locale' => null, 'text_value' => $sku, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 2,  'channel' => null,      'locale' => 'en', 'text_value' => $name, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 3,  'channel' => null,      'locale' => 'en', 'text_value' => $urlKey, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 9,  'channel' => null,      'locale' => 'en', 'text_value' => $shortDesc, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 10, 'channel' => null,      'locale' => 'en', 'text_value' => $desc, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 11, 'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => $price, 'boolean_value' => null],
                    ['attribute_id' => 22, 'channel' => null,      'locale' => null, 'text_value' => (string) $weight, 'float_value' => null, 'boolean_value' => null],
                    ['attribute_id' => 8,  'channel' => 'default', 'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                    ['attribute_id' => 7,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                    ['attribute_id' => 5,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                    ['attribute_id' => 6,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 0],
                    ['attribute_id' => 28, 'channel' => 'default', 'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                    ['attribute_id' => 26, 'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                    ['attribute_id' => 18, 'channel' => null,      'locale' => 'en', 'text_value' => $packPricesJson, 'float_value' => null, 'boolean_value' => null],
                ];

                foreach ($attrs as $a) {
                    DB::table('product_attribute_values')->insert([
                        'product_id'    => $prodId,
                        'attribute_id'  => $a['attribute_id'],
                        'channel'       => $a['channel'],
                        'locale'        => $a['locale'],
                        'text_value'    => $a['text_value'],
                        'float_value'   => $a['float_value'],
                        'boolean_value' => $a['boolean_value'],
                    ]);
                }

                DB::table('product_flat')->insert([
                    'product_id'            => $prodId,
                    'sku'                   => $sku,
                    'type'                  => 'simple',
                    'name'                  => $name,
                    'short_description'     => $shortDesc,
                    'description'           => $desc,
                    'url_key'               => $urlKey,
                    'new'                   => 1,
                    'featured'              => 0,
                    'status'                => 1,
                    'meta_title'            => $name . ' | SYD Spices',
                    'meta_keywords'         => strtolower($name) . ', pure indian spices',
                    'meta_description'      => $packPricesJson,
                    'price'                 => $price,
                    'weight'                => is_numeric($weight) ? (float) $weight : 0.25,
                    'quantity'              => $qty,
                    'images_count'          => count($images),
                    'manage_stock'          => 1,
                    'base_image'            => $images[0] ?? $image,
                    'category_name'         => $catName,
                    'attribute_family_name' => 'Default',
                    'attribute_family_id'   => 1,
                    'created_at'            => now(),
                    'updated_at'            => now(),
                    'locale'                => 'en',
                    'channel'               => 'default',
                    'parent_id'             => null,
                    'visible_individually'  => 1,
                ]);

                DB::commit();

                try {
                    app(\Webkul\Product\Helpers\Indexers\Flat::class)->reindexFull();
                } catch (\Exception $e) {}

                session()->flash('success', "Spice Product '{$name}' added directly to catalog!");

                return new JsonResponse([
                    'data' => [
                        'redirect_url' => route('admin.catalog.products.index'),
                    ],
                ]);

            } catch (\Exception $e) {
                DB::rollBack();
                return new JsonResponse(['message' => $e->getMessage()], 500);
            }
        }

        // 2. Legacy two-step creation fallback
        $this->validate(request(), [
            'type' => 'required',
            'attribute_family_id' => 'required',
            'sku' => ['required', 'unique:products,sku', new Slug],
            'super_attributes' => 'array|min:1',
            'super_attributes.*' => 'array|min:1',
        ]);

        if (
            ProductType::hasVariants(request()->input('type'))
            && ! request()->has('super_attributes')
        ) {
            $configurableFamily = $this->attributeFamilyRepository
                ->find(request()->input('attribute_family_id'));

            return new JsonResponse([
                'data' => [
                    'attributes' => AttributeResource::collection($configurableFamily->configurable_attributes),
                ],
            ]);
        }

        Event::dispatch('catalog.product.create.before');

        $product = $this->productRepository->create(request()->only([
            'type',
            'attribute_family_id',
            'sku',
            'super_attributes',
            'family',
        ]));

        Event::dispatch('catalog.product.create.after', $product);

        session()->flash('success', trans('admin::app.catalog.products.create-success'));

        return new JsonResponse([
            'data' => [
                'redirect_url' => route('admin.catalog.products.edit', $product->id),
            ],
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @return View
     */
    public function edit(int $id)
    {
        $product = $this->productRepository->findOrFail($id);

        $flat = DB::table('product_flat')->where('product_id', $id)->first();
        $catId = (int) (DB::table('product_categories')->where('product_id', $id)->value('category_id') ?? 2);
        $qty = (int) (DB::table('product_inventories')->where('product_id', $id)->value('qty') ?? 100);

        // Images
        $images = DB::table('product_images')->where('product_id', $id)->orderBy('position')->pluck('path')->toArray();
        if (empty($images) && $flat && ! empty($flat->base_image)) {
            $images = [$flat->base_image];
        }

        // Pack weights & prices
        $weightOptions = [];
        if ($flat && ! empty($flat->meta_description)) {
            $decoded = json_decode($flat->meta_description, true);
            if (is_array($decoded) && count($decoded) > 0) {
                foreach ($decoded as $item) {
                    $weightOptions[] = [
                        'weight'    => (string) ($item['weight'] ?? '250g'),
                        'price'     => (float) ($item['price'] ?? 195),
                        'isDefault' => ! empty($item['active']) || ! empty($item['isDefault']),
                    ];
                }
            }
        }
        if (empty($weightOptions)) {
            $pPrice = $flat ? (float) $flat->price : 195;
            $weightOptions = [
                ['weight' => '100g', 'price' => round($pPrice * 0.5), 'isDefault' => false],
                ['weight' => '250g', 'price' => $pPrice, 'isDefault' => true],
                ['weight' => '500g', 'price' => round($pPrice * 1.85), 'isDefault' => false],
            ];
        }

        $prodData = [
            'id'                => $id,
            'name'              => $flat ? $flat->name : ($product->name ?? ''),
            'sku'               => $product->sku ?? '',
            'category_id'       => $catId,
            'quantity'          => $qty,
            'short_description' => $flat ? $flat->short_description : ($product->short_description ?? ''),
            'description'       => $flat ? $flat->description : ($product->description ?? ''),
            'weightOptions'     => $weightOptions,
            'images'            => $images,
        ];

        return view('admin::catalog.products.edit', compact('product', 'prodData'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @return Response
     */
    public function update(\Illuminate\Http\Request $request, int $id)
    {
        Event::dispatch('catalog.product.update.before', $id);

        $name = trim($request->input('name'));
        if (empty($name)) {
            session()->flash('error', 'Product name is required.');
            return redirect()->back();
        }

        // 1. Pack sizes and pricing options (Dynamic weight selection & prices)
        $packPricesJson = $request->input('pack_prices', '');
        $price = 195.0;
        $weight = '250g';
        if (! empty($packPricesJson)) {
            $decodedPacks = is_array($packPricesJson) ? $packPricesJson : json_decode($packPricesJson, true);
            if (is_array($decodedPacks) && count($decodedPacks) > 0) {
                $normalizedPacks = [];
                foreach ($decodedPacks as $pack) {
                    $pPrice = (float) ($pack['price'] ?? 195);
                    $isAct = ! empty($pack['active']) || ! empty($pack['isDefault']);
                    $normalizedPacks[] = [
                        'weight' => (string) ($pack['weight'] ?? '250g'),
                        'price'  => $pPrice,
                        'strike' => (float) round($pPrice * 1.25),
                        'active' => $isAct,
                    ];
                }
                if (! collect($normalizedPacks)->contains('active', true) && count($normalizedPacks) > 0) {
                    $normalizedPacks[0]['active'] = true;
                }
                $defaultPack = collect($normalizedPacks)->firstWhere('active', true) ?: $normalizedPacks[0];
                $price = (float) ($defaultPack['price'] ?? 195);
                $weight = (string) ($defaultPack['weight'] ?? '250g');
                $packPricesJson = json_encode($normalizedPacks);
            }
        }

        $catId = (int) $request->input('category_id', 2);
        if (! in_array($catId, [2, 3, 4])) {
            $catId = 2;
        }
        $catNames = [2 => 'Whole Spices', 3 => 'Blended Spices', 4 => 'Grinded Spices'];
        $catName = $catNames[$catId] ?? 'Whole Spices';

        $desc = trim($request->input('description', "100% pure single-origin {$name}."));
        $shortDesc = trim($request->input('short_description', "Handpicked unpolished {$name}."));

        // 2. Multiple Images Handling
        $images = $request->input('images', []);
        if (is_string($images)) {
            $decodedImgs = json_decode($images, true);
            $images = is_array($decodedImgs) ? $decodedImgs : array_filter(array_map('trim', explode(',', $images)));
        }
        if (! is_array($images)) {
            $images = [];
        }
        $singleImage = trim($request->input('image', ''));
        if (! empty($singleImage) && ! in_array($singleImage, $images)) {
            array_unshift($images, $singleImage);
        }
        if (empty($images)) {
            $imageMap = [
                2 => 'assets/step_01_sourced.png',
                3 => 'assets/magicbland.png',
                4 => 'assets/chilli.png',
            ];
            $images = [$imageMap[$catId] ?? 'assets/step_01_sourced.png'];
        }
        $primaryImage = $images[0];
        $qty = (int) $request->input('quantity', 100);

        DB::beginTransaction();
        try {
            // Update product category
            DB::table('product_categories')->where('product_id', $id)->delete();
            DB::table('product_categories')->insert([
                'product_id'  => $id,
                'category_id' => $catId,
            ]);

            // Update inventories
            DB::table('product_inventories')->updateOrInsert(
                ['product_id' => $id, 'inventory_source_id' => 1],
                ['qty' => $qty, 'vendor_id' => 0]
            );
            DB::table('product_inventory_indices')->updateOrInsert(
                ['product_id' => $id, 'channel_id' => 1],
                ['qty' => $qty, 'updated_at' => now()]
            );

            // Update price indices
            DB::table('product_price_indices')->updateOrInsert(
                ['product_id' => $id, 'customer_group_id' => 1, 'channel_id' => 1],
                [
                    'min_price'         => $price,
                    'regular_min_price' => $price,
                    'max_price'         => $price,
                    'regular_max_price' => $price,
                    'updated_at'        => now(),
                ]
            );

            // Update images
            DB::table('product_images')->where('product_id', $id)->delete();
            foreach ($images as $pos => $imgPath) {
                DB::table('product_images')->insert([
                    'type'       => 'images',
                    'path'       => $imgPath,
                    'product_id' => $id,
                    'position'   => $pos + 1,
                ]);
            }

            // Update attribute values
            $attrUpdates = [
                2  => ['text_value' => $name, 'float_value' => null],
                9  => ['text_value' => $shortDesc, 'float_value' => null],
                10 => ['text_value' => $desc, 'float_value' => null],
                11 => ['text_value' => null, 'float_value' => $price],
                18 => ['text_value' => $packPricesJson, 'float_value' => null],
                22 => ['text_value' => (string) $weight, 'float_value' => null],
            ];
            foreach ($attrUpdates as $attrId => $vals) {
                DB::table('product_attribute_values')->updateOrInsert(
                    ['product_id' => $id, 'attribute_id' => $attrId],
                    array_merge($vals, [
                        'channel' => in_array($attrId, [8, 28]) ? 'default' : null,
                        'locale'  => in_array($attrId, [2, 3, 9, 10, 18]) ? 'en' : null,
                    ])
                );
            }

            // Update product_flat
            DB::table('product_flat')->where('product_id', $id)->update([
                'name'                  => $name,
                'short_description'     => $shortDesc,
                'description'           => $desc,
                'meta_description'      => $packPricesJson,
                'price'                 => $price,
                'weight'                => is_numeric($weight) ? (float) $weight : 0.25,
                'quantity'              => $qty,
                'images_count'          => count($images),
                'base_image'            => $primaryImage,
                'category_name'         => $catName,
                'updated_at'            => now(),
            ]);

            DB::commit();

            try {
                app(\Webkul\Product\Helpers\Indexers\Flat::class)->reindexFull();
            } catch (\Exception $e) {}

            $product = $this->productRepository->find($id);
            if ($product) {
                Event::dispatch('catalog.product.update.after', $product);
            }

            if ($request->ajax() || $request->wantsJson()) {
                return response()->json([
                    'message'      => 'Product updated successfully.',
                    'redirect_url' => route('admin.catalog.products.index'),
                ]);
            }

            session()->flash('success', 'Product updated successfully.');

            return redirect()->route('admin.catalog.products.index');
        } catch (\Exception $e) {
            DB::rollBack();
            report($e);

            if ($request->ajax() || $request->wantsJson()) {
                return response()->json(['message' => 'Failed to update product: ' . $e->getMessage()], 422);
            }

            session()->flash('error', 'Failed to update product: ' . $e->getMessage());
            return redirect()->back()->withInput();
        }
    }

    /**
     * Update inventories.
     *
     * @return Response
     */
    public function updateInventories(InventoryRequest $inventoryRequest, int $id)
    {
        $product = $this->productRepository->findOrFail($id);

        Event::dispatch('catalog.product.update.before', $id);

        $this->productInventoryRepository->saveInventories(request()->all(), $product);

        Event::dispatch('catalog.product.update.after', $product);

        return response()->json([
            'message' => trans('admin::app.catalog.products.saved-inventory-message'),
            'updatedTotal' => $this->productInventoryRepository->where('product_id', $product->id)->sum('qty'),
        ]);
    }

    /**
     * Uploads downloadable file.
     *
     * @return Response
     */
    public function uploadLink(int $id)
    {
        return response()->json(
            $this->productDownloadableLinkRepository->upload(request()->all(), $id)
        );
    }

    /**
     * Copy a given Product.
     *
     * @return Response
     */
    public function copy(int $id)
    {
        try {
            Event::dispatch('catalog.product.create.before');

            $product = $this->productRepository->copy($id);

            Event::dispatch('catalog.product.create.after', $product);
        } catch (\Exception $e) {
            session()->flash('error', $e->getMessage());

            return redirect()->to(route('admin.catalog.products.index'));
        }

        return response()->json([
            'message' => trans('admin::app.catalog.products.product-copied'),
        ]);
    }

    /**
     * Uploads downloadable sample file.
     *
     * @return Response
     */
    public function uploadSample(int $id)
    {
        return response()->json(
            $this->productDownloadableSampleRepository->upload(request()->all(), $id)
        );
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(int $id): JsonResponse
    {
        try {
            Event::dispatch('catalog.product.delete.before', $id);

            $this->productRepository->delete($id);

            Event::dispatch('catalog.product.delete.after', $id);

            return new JsonResponse([
                'message' => trans('admin::app.catalog.products.delete-success'),
            ]);
        } catch (\Exception $e) {
            report($e);
        }

        return new JsonResponse([
            'message' => trans('admin::app.catalog.products.delete-failed'),
        ], 500);
    }

    /**
     * Mass delete the products.
     */
    public function massDestroy(MassDestroyRequest $massDestroyRequest): JsonResponse
    {
        $productIds = $massDestroyRequest->input('indices');

        try {
            foreach ($productIds as $productId) {
                $product = $this->productRepository->find($productId);

                if (isset($product)) {
                    Event::dispatch('catalog.product.delete.before', $productId);

                    $this->productRepository->delete($productId);

                    Event::dispatch('catalog.product.delete.after', $productId);
                }
            }

            return new JsonResponse([
                'message' => trans('admin::app.catalog.products.index.datagrid.mass-delete-success'),
            ]);
        } catch (\Exception $e) {
            return new JsonResponse([
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Mass update the products.
     */
    public function massUpdate(MassUpdateRequest $massUpdateRequest): JsonResponse
    {
        $productIds = $massUpdateRequest->input('indices');

        foreach ($productIds as $productId) {
            Event::dispatch('catalog.product.update.before', $productId);

            $product = $this->productRepository->update([
                'status' => $massUpdateRequest->input('value'),
            ], $productId, ['status']);

            Event::dispatch('catalog.product.update.after', $product);
        }

        return new JsonResponse([
            'message' => trans('admin::app.catalog.products.index.datagrid.mass-update-success'),
        ], 200);
    }

    /**
     * To be manually invoked when data is seeded into products.
     *
     * @return Response
     */
    public function sync()
    {
        Event::dispatch('products.datagrid.sync', true);

        return redirect()->route('admin.catalog.products.index');
    }

    /**
     * Result of search product.
     *
     * @return JsonResponse
     */
    public function search()
    {
        $query = trim(request('query'));

        if (empty($query)) {
            return response()->json([
                'data' => [],
            ]);
        }

        $searchEngine = 'database';

        if (
            core()->getConfigData('catalog.products.search.engine') == 'elastic'
            && core()->getConfigData('catalog.products.search.admin_mode') == 'elastic'
        ) {
            $searchEngine = 'elastic';

            $indexNames = core()->getAllChannels()->map(function ($channel) {
                return Product::formatElasticSearchIndexName($channel->code, app()->getLocale());
            })->toArray();
        }

        $channelId = $this->customerRepository->find(request('customer_id'))->channel_id ?? null;

        $params = [
            'index' => $indexNames ?? null,
            'name' => request('query'),
            'sort' => 'created_at',
            'order' => 'desc',
            'channel_id' => $channelId,
        ];

        if (request()->has('type')) {
            $params['type'] = request('type');
        }

        if (request()->has('exclude_customizable_products')) {
            $params['exclude_customizable_products'] = request('exclude_customizable_products');
        }

        $products = $this->productRepository
            ->setSearchEngine($searchEngine)
            ->getAll($params);

        return ProductResource::collection($products);
    }

    /**
     * Download image or file.
     *
     * @param  int  $productId
     * @param  int  $attributeId
     * @return Response
     */
    public function download($productId, $attributeId)
    {
        $productAttribute = $this->productAttributeValueRepository->findOneWhere([
            'product_id' => $productId,
            'attribute_id' => $attributeId,
        ]);

        return Storage::download($productAttribute['text_value']);
    }
}
