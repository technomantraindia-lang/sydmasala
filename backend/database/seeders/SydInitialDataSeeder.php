<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class SydInitialDataSeeder extends Seeder
{
    /**
     * Run the database seeds for SYD Spices Catalog & Settings.
     */
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        // 1. Update Channel & Currency
        try {
            DB::table('channels')->where('id', 1)->update([
                'name' => 'SYD Spices Official Store',
            ]);
            DB::table('currencies')->where('code', 'INR')->update([
                'name'   => 'Indian Rupee',
                'symbol' => '₹',
            ]);
        } catch (\Exception $e) {
            // ignore
        }

        // 2. Synchronize Categories (Whole Spices, Blended Spices, Grinded Spices)
        DB::table('categories')->whereNotIn('id', [1, 2, 3, 4])->delete();
        DB::table('category_translations')->whereNotIn('category_id', [1, 2, 3, 4])->delete();

        // Root
        DB::table('categories')->updateOrInsert(
            ['id' => 1],
            ['position' => 1, 'status' => 1, '_lft' => 1, '_rgt' => 8, 'parent_id' => null, 'created_at' => now(), 'updated_at' => now()]
        );
        DB::table('category_translations')->updateOrInsert(
            ['category_id' => 1, 'locale' => 'en'],
            ['name' => 'Root', 'slug' => 'root', 'description' => 'SYD Spices Root Category', 'meta_title' => 'SYD Spices', 'meta_description' => 'Pure Indian Spices', 'meta_keywords' => 'spices, indian spices']
        );

        // Whole Spices (ID 2)
        DB::table('categories')->updateOrInsert(
            ['id' => 2],
            ['position' => 1, 'status' => 1, '_lft' => 2, '_rgt' => 3, 'parent_id' => 1, 'created_at' => now(), 'updated_at' => now()]
        );
        DB::table('category_translations')->updateOrInsert(
            ['category_id' => 2, 'locale' => 'en'],
            ['name' => 'Whole Spices', 'slug' => 'whole-spices', 'description' => 'Single-origin unpolished whole seeds handpicked from India APMC mandis. Rich in natural volatile oils.', 'meta_title' => 'Whole Spices | SYD Spices', 'meta_description' => '100% natural, bold, single-origin whole seeds with crisp crackle and natural aromatics.', 'meta_keywords' => 'whole spices, cumin seeds, fennel seeds, jeera, variyali, authentic spices']
        );

        // Blended Spices (ID 3)
        DB::table('categories')->updateOrInsert(
            ['id' => 3],
            ['position' => 2, 'status' => 1, '_lft' => 4, '_rgt' => 5, 'parent_id' => 1, 'created_at' => now(), 'updated_at' => now()]
        );
        DB::table('category_translations')->updateOrInsert(
            ['category_id' => 3, 'locale' => 'en'],
            ['name' => 'Blended Spices', 'slug' => 'blended-spices', 'description' => 'Royal court secret formulas and cast-iron roasted masalas crafted in small batches for everyday dishes and festive curries.', 'meta_title' => 'Blended Spices | SYD Spices', 'meta_description' => 'Master kitchen king secret formulas, royal garam masala, and artisan spice blends.', 'meta_keywords' => 'blended spices, magic blend, garam masala, curry powder, royal spices']
        );

        // Grinded Spices (ID 4)
        DB::table('categories')->updateOrInsert(
            ['id' => 4],
            ['position' => 3, 'status' => 1, '_lft' => 6, '_rgt' => 7, 'parent_id' => 1, 'created_at' => now(), 'updated_at' => now()]
        );
        DB::table('category_translations')->updateOrInsert(
            ['category_id' => 4, 'locale' => 'en'],
            ['name' => 'Grinded Spices', 'slug' => 'grinded-spices', 'description' => 'Single-origin sun-dried chillies and golden turmeric roots cold-pulverized below 40°C to lock in vivid color and vital terpenes.', 'meta_title' => 'Grinded Spices | SYD Spices', 'meta_description' => 'Cold-pulverized turmeric, stemless red chilli, and coriander powders with zero adulteration.', 'meta_keywords' => 'grinded spices, red chilli powder, turmeric powder, coriander powder, haldi, dhaniya']
        );

        // 3. Inventory Source
        DB::table('inventory_sources')->where('id', 1)->update([
            'name'           => 'SYD Spices Central Warehouse',
            'code'           => 'syd-central',
            'description'    => 'Gala No. 12, Spice Park, Gujarat - 384170, India',
            'contact_name'   => 'SYD Spices Logistics',
            'contact_email'  => 'care@sydspices.com',
            'contact_number' => '+91 98765 43210',
            'country'        => 'IN',
            'state'          => 'GJ',
            'city'           => 'Gujarat',
            'street'         => 'Spice Park Gala No. 12',
            'postcode'       => '384170',
            'status'         => 1,
        ]);

        // 4. Products definition
        $products = [
            [
                'id'                => 1,
                'sku'               => 'magic-blend-250g',
                'name'              => 'Magic Blend',
                'url_key'           => 'magic-blend',
                'price'             => 195.00,
                'weight'            => 0.25,
                'category_id'       => 3, // Blended Spices
                'category_name'     => 'Blended Spices',
                'short_description' => 'Our signature 16-spice balanced aromatic blend, master-crafted in small batches.',
                'description'       => 'Our signature 16-spice balanced aromatic blend, master-crafted in small batches to elevate everyday curries, dals, gravies, and paneer dishes with fragrant, warm sweetness. Zero fillers, 100% whole spices.',
                'base_image'        => 'assets/magicbland.png',
            ],
            [
                'id'                => 2,
                'sku'               => 'red-chilli-250g',
                'name'              => 'Red Chilli Powder',
                'url_key'           => 'red-chilli',
                'price'             => 185.00,
                'weight'            => 0.25,
                'category_id'       => 4, // Grinded Spices
                'category_name'     => 'Grinded Spices',
                'short_description' => 'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C.',
                'description'       => 'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C. Delivers rich, vibrant vermilion red color and warm, layered piquancy without harsh synthetic additives.',
                'base_image'        => 'assets/chilli.png',
            ],
            [
                'id'                => 3,
                'sku'               => 'garam-masala-100g',
                'name'              => 'Royal Garam Masala',
                'url_key'           => 'garam-masala',
                'price'             => 210.00,
                'weight'            => 0.10,
                'category_id'       => 3, // Blended Spices
                'category_name'     => 'Blended Spices',
                'short_description' => 'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon.',
                'description'       => 'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon. Roasted in cast iron and coarse-ground for deep fragrance.',
                'base_image'        => 'assets/garammasala.png',
            ],
            [
                'id'                => 4,
                'sku'               => 'cumin-seeds-250g',
                'name'              => 'India Cumin Seeds',
                'url_key'           => 'cumin-seeds',
                'price'             => 160.00,
                'weight'            => 0.25,
                'category_id'       => 2, // Whole Spices
                'category_name'     => 'Whole Spices',
                'short_description' => 'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration.',
                'description'       => 'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration. Crackles with crisp earthy sweetness.',
                'base_image'        => 'assets/step_01_sourced.png',
            ],
            [
                'id'                => 5,
                'sku'               => 'fennel-seeds-250g',
                'name'              => 'Royal Fennel Seeds',
                'url_key'           => 'fennel-seeds',
                'price'             => 150.00,
                'weight'            => 0.25,
                'category_id'       => 2, // Whole Spices
                'category_name'     => 'Whole Spices',
                'short_description' => 'Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds.',
                'description'       => 'Natural sun-dried green fennel from Gujarat\'s Saurashtra belt. Unpolished, chemical-free plump seeds offering refreshing sweet anethole flavor.',
                'base_image'        => 'assets/step_02_handpicked.png',
            ],
            [
                'id'                => 6,
                'sku'               => 'turmeric-powder-250g',
                'name'              => 'Golden Turmeric Powder',
                'url_key'           => 'turmeric-powder',
                'price'             => 140.00,
                'weight'            => 0.25,
                'category_id'       => 4, // Grinded Spices
                'category_name'     => 'Grinded Spices',
                'short_description' => 'Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation.',
                'description'       => 'Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation to retain its healing potency.',
                'base_image'        => 'assets/step_04_ground.png',
            ],
            [
                'id'                => 7,
                'sku'               => 'coriander-powder-250g',
                'name'              => 'Coriander Powder',
                'url_key'           => 'coriander-powder',
                'price'             => 130.00,
                'weight'            => 0.25,
                'category_id'       => 4, // Grinded Spices
                'category_name'     => 'Grinded Spices',
                'short_description' => 'Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes.',
                'description'       => 'Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes. Imparts cooling fragrant body and thick richness to home-cooked gravies.',
                'base_image'        => 'assets/syd_pouch.jpg',
            ],
            [
                'id'                => 8,
                'sku'               => 'heritage-gift-box-1kg',
                'name'              => 'Heritage Grand Gift Box',
                'url_key'           => 'heritage-gift-box',
                'price'             => 1199.00,
                'weight'            => 1.00,
                'category_id'       => 3, // Blended Spices
                'category_name'     => 'Blended Spices',
                'short_description' => 'Collector\'s presentation wooden box with 5 luxury airtight glass jars.',
                'description'       => 'Collector\'s presentation wooden box with 5 luxury airtight glass jars: Magic Blend, Garam Masala, India Jeera, Salem Turmeric, and Red Chilli, plus an authentic brass measuring spoon.',
                'base_image'        => 'assets/card_magic_blend.png',
            ],
        ];

        // Clean product tables
        $productTables = [
            'product_attribute_values',
            'product_categories',
            'product_channels',
            'product_inventories',
            'product_inventory_indices',
            'product_price_indices',
            'product_images',
            'product_image_translations',
            'product_flat',
            'products',
        ];

        foreach ($productTables as $tbl) {
            if (Schema::hasTable($tbl)) {
                DB::table($tbl)->truncate();
            }
        }

        foreach ($products as $p) {
            DB::table('products')->insert([
                'id'                  => $p['id'],
                'sku'                 => $p['sku'],
                'type'                => 'simple',
                'parent_id'           => null,
                'attribute_family_id' => 1,
                'additional'          => null,
                'created_at'          => now(),
                'updated_at'          => now(),
            ]);

            DB::table('product_channels')->insert([
                'product_id' => $p['id'],
                'channel_id' => 1,
            ]);

            DB::table('product_categories')->insert([
                'product_id'  => $p['id'],
                'category_id' => $p['category_id'],
            ]);

            DB::table('product_inventories')->insert([
                'qty'                 => 100,
                'product_id'          => $p['id'],
                'vendor_id'           => 0,
                'inventory_source_id' => 1,
            ]);

            DB::table('product_inventory_indices')->insert([
                'qty'        => 100,
                'product_id' => $p['id'],
                'channel_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            DB::table('product_price_indices')->insert([
                'product_id'        => $p['id'],
                'customer_group_id' => 1,
                'channel_id'        => 1,
                'min_price'         => $p['price'],
                'regular_min_price' => $p['price'],
                'max_price'         => $p['price'],
                'regular_max_price' => $p['price'],
                'created_at'        => now(),
                'updated_at'        => now(),
            ]);

            DB::table('product_images')->insert([
                'type'       => 'images',
                'path'       => $p['base_image'],
                'product_id' => $p['id'],
                'position'   => 1,
            ]);

            $attrs = [
                ['attribute_id' => 1,  'channel' => null,      'locale' => null, 'text_value' => $p['sku'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 2,  'channel' => null,      'locale' => 'en', 'text_value' => $p['name'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 3,  'channel' => null,      'locale' => 'en', 'text_value' => $p['url_key'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 9,  'channel' => null,      'locale' => 'en', 'text_value' => $p['short_description'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 10, 'channel' => null,      'locale' => 'en', 'text_value' => $p['description'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 11, 'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => $p['price'], 'boolean_value' => null],
                ['attribute_id' => 22, 'channel' => null,      'locale' => null, 'text_value' => (string) $p['weight'], 'float_value' => null, 'boolean_value' => null],
                ['attribute_id' => 8,  'channel' => 'default', 'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                ['attribute_id' => 7,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                ['attribute_id' => 5,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                ['attribute_id' => 6,  'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                ['attribute_id' => 28, 'channel' => 'default', 'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
                ['attribute_id' => 26, 'channel' => null,      'locale' => null, 'text_value' => null, 'float_value' => null, 'boolean_value' => 1],
            ];

            foreach ($attrs as $a) {
                DB::table('product_attribute_values')->insert([
                    'product_id'    => $p['id'],
                    'attribute_id'  => $a['attribute_id'],
                    'channel'       => $a['channel'],
                    'locale'        => $a['locale'],
                    'text_value'    => $a['text_value'],
                    'float_value'   => $a['float_value'],
                    'boolean_value' => $a['boolean_value'],
                    'integer_value' => null,
                    'datetime_value'=> null,
                    'date_value'    => null,
                    'json_value'    => null,
                ]);
            }

            DB::table('product_flat')->insert([
                'product_id'            => $p['id'],
                'sku'                   => $p['sku'],
                'type'                  => 'simple',
                'name'                  => $p['name'],
                'short_description'     => $p['short_description'],
                'description'           => $p['description'],
                'url_key'               => $p['url_key'],
                'new'                   => 1,
                'featured'              => 1,
                'status'                => 1,
                'meta_title'            => $p['name'] . ' | Pure Indian Spices',
                'meta_keywords'         => strtolower($p['name']) . ', pure indian spices, syd spices',
                'meta_description'      => $p['short_description'],
                'price'                 => $p['price'],
                'weight'                => $p['weight'],
                'quantity'              => 100,
                'images_count'          => 1,
                'manage_stock'          => 1,
                'base_image'            => $p['base_image'],
                'category_name'         => $p['category_name'],
                'attribute_family_name' => 'Default',
                'attribute_family_id'   => 1,
                'created_at'            => now(),
                'updated_at'            => now(),
                'locale'                => 'en',
                'channel'               => 'default',
                'parent_id'             => null,
                'visible_individually'  => 1,
            ]);
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        try {
            app(\Webkul\Product\Helpers\Indexers\Flat::class)->reindexFull();
        } catch (\Exception $e) {
            // ignore
        }
    }
}
