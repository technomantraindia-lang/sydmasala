<?php

namespace Webkul\Core\Exceptions;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Exceptions\Handler as BaseHandler;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Throwable;

class Handler extends BaseHandler
{
    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        $this->handleAuthenticationException();

        $this->handleValidationException();

        $this->handleServerException();
    }

    /**
     * Handle the authentication exception.
     */
    protected function handleAuthenticationException(): void
    {
        $this->renderable(function (AuthenticationException $exception, Request $request) {
            $namespace = $request->is(config('app.admin_url').'/*') ? 'admin' : 'shop';

            if ($request->wantsJson()) {
                return response()->json(['error' => trans("{$namespace}::app.errors.401.description")], 401);
            }

            if ($namespace !== 'admin') {
                return redirect()->guest(route('shop.customer.session.index'));
            }

            return redirect()->guest(route('admin.session.create'));
        });
    }

    /**
     * Handle validation exceptions.
     */
    protected function handleValidationException(): void
    {
        $this->renderable(function (ValidationException $exception, Request $request) {
            return parent::convertValidationExceptionToResponse($exception, $request);
        });
    }

    /**
     * Handle the server exceptions - SHOW RAW CODE ERRORS.
     */
    protected function handleServerException(): void
    {
        $this->renderable(function (\Symfony\Component\HttpKernel\Exception\NotFoundHttpException $e, Request $request) {
            if ($request->wantsJson()) {
                return response()->json(['error' => 'Not Found', 'message' => $e->getMessage() ?: 'Resource not found.'], 404);
            }
            return response('404 Not Found', 404);
        });

        $this->renderable(function (Throwable $throwable, Request $request) {
            if ($throwable instanceof \Symfony\Component\HttpKernel\Exception\NotFoundHttpException) {
                return response('404 Not Found', 404);
            }

            \Illuminate\Support\Facades\Log::error('Server Exception: ' . $throwable->getMessage() . ' in ' . $throwable->getFile() . ':' . $throwable->getLine() . "\n" . $throwable->getTraceAsString());

            if ($request->wantsJson()) {
                return response()->json([
                    'error' => get_class($throwable),
                    'message' => $throwable->getMessage(),
                    'file' => $throwable->getFile(),
                    'line' => $throwable->getLine(),
                    'trace' => explode("\n", $throwable->getTraceAsString()),
                ], 500);
            }

            $codeSnippet = '';
            if (file_exists($throwable->getFile())) {
                $fileLines = file($throwable->getFile());
                $start = max(0, $throwable->getLine() - 7);
                $end = min(count($fileLines), $throwable->getLine() + 6);
                for ($i = $start; $i < $end; $i++) {
                    $num = $i + 1;
                    $isError = ($num === $throwable->getLine());
                    $codeSnippet .= sprintf("%s %4d | %s", $isError ? '>>>' : '   ', $num, $fileLines[$i]);
                }
            }

            return response(
                '<!DOCTYPE html>'
                . '<html style="background:#0f172a;color:#e2e8f0;font-family:ui-monospace,Menlo,Monaco,Consolas,monospace;padding:32px;font-size:14px;line-height:1.6;">'
                . '<head><title>500 - Raw Server Error</title></head>'
                . '<body>'
                . '<div style="max-width:1100px;margin:0 auto;">'
                . '<div style="border-bottom:2px solid #334155;padding-bottom:16px;margin-bottom:24px;">'
                . '<span style="background:#ef4444;color:white;padding:4px 10px;border-radius:4px;font-weight:bold;font-size:13px;letter-spacing:0.05em;">HTTP 500 ERROR</span>'
                . '<h1 style="color:#f87171;font-size:24px;margin:12px 0 6px 0;word-break:break-all;">' . htmlspecialchars($throwable->getMessage() ?: get_class($throwable)) . '</h1>'
                . '<p style="color:#94a3b8;margin:0;">Exception: <span style="color:#cbd5e1;">' . htmlspecialchars(get_class($throwable)) . '</span></p>'
                . '<p style="color:#94a3b8;margin:4px 0 0 0;">File: <span style="color:#38bdf8;">' . htmlspecialchars($throwable->getFile()) . ':' . $throwable->getLine() . '</span></p>'
                . '</div>'
                . ($codeSnippet ? '<h3 style="color:#38bdf8;margin:20px 0 8px 0;">Source Code:</h3><pre style="background:#020617;border:1px solid #1e293b;padding:16px;border-radius:8px;overflow:auto;line-height:1.5;color:#e2e8f0;">' . htmlspecialchars($codeSnippet) . '</pre>' : '')
                . '<h3 style="color:#38bdf8;margin:20px 0 8px 0;">Stack Trace:</h3>'
                . '<pre style="background:#020617;border:1px solid #1e293b;padding:16px;border-radius:8px;overflow:auto;max-height:500px;font-size:12px;line-height:1.5;color:#cbd5e1;">' . htmlspecialchars($throwable->getTraceAsString()) . '</pre>'
                . '</div>'
                . '</body>'
                . '</html>',
                500
            );
        });
    }
}
