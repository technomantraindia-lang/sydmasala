<?php

use Illuminate\Support\Facades\Route;

/**
 * Direct all storefront requests to the Admin Panel.
 */
Route::get('/', fn () => redirect()->route('admin.session.create'))->name('shop.home.index');

