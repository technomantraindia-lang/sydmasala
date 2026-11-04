<?php

use App\Http\Middleware\EncryptCookies;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Cookie\Middleware\EncryptCookies as BaseEncryptCookies;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull;
use Illuminate\Foundation\Http\Middleware\PreventRequestsDuringMaintenance;
use Webkul\Core\Http\Middleware\SecureHeaders;
use Webkul\Installer\Http\Middleware\CanInstall;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        /**
         * Remove the default Laravel middleware that prevents requests during maintenance mode. There are three
         * middlewares in the shop that need to be loaded before this middleware. Therefore, we need to remove this
         * middleware from the list and add the overridden middleware at the end of the list.
         *
         * As of now, this has been added in the Admin and Shop providers. I will look for a better approach in Laravel 11 for this.
         */
        $middleware->remove(PreventRequestsDuringMaintenance::class);

        /**
         * Remove the default Laravel middleware that converts empty strings to null. First, handle all nullable cases,
         * then remove this line.
         */
        $middleware->remove(ConvertEmptyStringsToNull::class);

        $middleware->append(SecureHeaders::class);
        $middleware->append(CanInstall::class);

        /**
         * Add the overridden middleware at the end of the list.
         */
        $middleware->replaceInGroup('web', BaseEncryptCookies::class, EncryptCookies::class);

        $middleware->validateCsrfTokens(except: [
            'stripe/*',
            'admin/login',
            'admin/*',
        ]);

        $middleware->trustProxies(at: '*');
    })
    ->withSchedule(function (Schedule $schedule) {
        //
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->render(function (\Illuminate\Session\TokenMismatchException $e, $request) {
            session()->flash('warning', 'Your session expired. Please refresh and try again.');
            return redirect()->back();
        });

        $exceptions->render(function (\Illuminate\Http\Exceptions\PostTooLargeException $e, $request) {
            session()->flash('error', 'The uploaded photos exceeded the server upload limit. Please try selecting slightly smaller files or fewer photos at once.');
            return redirect()->back();
        });

        $exceptions->render(function (\Throwable $e, $request) {
            \Illuminate\Support\Facades\Log::error($e->getMessage() . "\n" . $e->getTraceAsString());
            if ($request->is('admin*') || $request->is('api*') || $request->is('debug*')) {
                return response('<div style="font-family:monospace;padding:30px;background:#181825;color:#cdd6f4;"><h2>VIZE Admin Exception</h2><p style="color:#f38ba8;font-size:16px;"><b>' . e($e->getMessage()) . '</b></p><p style="color:#a6adc8;">File: ' . e($e->getFile()) . ':' . e($e->getLine()) . '</p><details><summary style="cursor:pointer;color:#89b4fa;">Stack Trace</summary><pre style="white-space:pre-wrap;font-size:12px;color:#fab387;">' . e($e->getTraceAsString()) . '</pre></details></div>', 500);
            }
        });
    })->create();
