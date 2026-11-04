<?php

namespace Webkul\Admin\Http\Controllers\User;

use Illuminate\Foundation\Auth\ThrottlesLogins;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Route;
use Illuminate\View\View;
use Webkul\Admin\Http\Controllers\Controller;

class SessionController extends Controller
{
    use ThrottlesLogins;

    /**
     * The failed login attempts an email address and caller may make before waiting.
     */
    protected $maxAttempts = 5;

    /**
     * How many minutes those failed attempts are remembered for.
     */
    protected $decayMinutes = 1;

    /**
     * The request field holding the identifier login attempts are counted against.
     */
    public function username(): string
    {
        return 'email';
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return View
     */
    public function create()
    {
        if (auth()->guard('admin')->check()) {
            return redirect()->route('admin.dashboard.index');
        }

        if (strpos(url()->previous(), 'admin') !== false && strpos(url()->previous(), 'login') === false) {
            $intendedUrl = url()->previous();
        } else {
            $intendedUrl = route('admin.dashboard.index');
        }

        session()->put('url.intended', $intendedUrl);

        return view('admin::users.sessions.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return Response
     */
    public function store()
    {
        try {
            $email = request('email');
            $password = request('password');
            $remember = (bool) request('remember');

            $this->validate(request(), [
                'email' => 'required|email',
                'password' => 'required',
            ]);

            if ($this->hasTooManyLoginAttempts(request())) {
                $this->fireLockoutEvent(request());

                return $this->sendLockoutResponse(request());
            }

            if (! auth()->guard('admin')->attempt(['email' => $email, 'password' => $password], $remember)) {
                $this->incrementLoginAttempts(request());

                session()->flash('error', 'Invalid email or password.');

                return redirect()->back()->withInput(request()->except('password'));
            }

            $this->clearLoginAttempts(request());

            $admin = auth()->guard('admin')->user();
            if (! $admin->status) {
                session()->flash('warning', 'Your account is deactivated. Please contact administrator.');

                auth()->guard('admin')->logout();

                return redirect()->route('admin.session.create');
            }

            session()->regenerate();
            session()->forget('url.intended');

            return redirect()->route('admin.dashboard.index');
        } catch (\Illuminate\Validation\ValidationException $ve) {
            throw $ve;
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error('SessionController::store error: ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine());

            session()->flash('error', 'Login error: ' . $e->getMessage());

            return redirect()->back()->withInput(request()->except('password'));
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @return Response
     */
    public function destroy()
    {
        auth()->guard('admin')->logout();

        session()->forget('two_factor_passed_for');

        return redirect()->route('admin.session.create');
    }

    /**
     * Redirect to the first accessible route based on user permissions.
     *
     * @return RedirectResponse
     */
    private function redirectToFirstAccessibleRoute()
    {
        try {
            $allPermissions = collect(config('acl'));
            $user = auth()->guard('admin')->user();
            if (! $user || ! $user->role) {
                return redirect()->route('admin.dashboard.index');
            }

            if ($user->role->permission_type === 'all' || ! is_iterable($user->role->permissions)) {
                return redirect()->route('admin.dashboard.index');
            }

            $userPermissions = $user->role->permissions ?: [];

            foreach ($userPermissions as $permission) {
                if (! bouncer()->hasPermission($permission)) {
                    continue;
                }

                $permissionDetails = $allPermissions->firstWhere('key', $permission);

                if (! $permissionDetails) {
                    continue;
                }

                if ($route = $this->navigableRoute($permissionDetails)) {
                    return redirect()->route($route);
                }

                $childPermission = $this->findFirstAccessibleChildPermission($allPermissions, $permission);

                if (
                    $childPermission
                    && $route = $this->navigableRoute($childPermission)
                ) {
                    return redirect()->route($route);
                }
            }
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::warning('redirectToFirstAccessibleRoute fallback: ' . $e->getMessage());
        }

        return redirect()->intended(route('admin.dashboard.index'));
    }

    /**
     * The route a permission can land an admin on, or null when it has none: a GET route with no
     * required parameter, guarded by a permission the admin holds, as a parent's route is a child's.
     */
    private function navigableRoute($permission): ?string
    {
        $guards = acl()->getRoles();

        foreach ((array) ($permission['route'] ?? []) as $name) {
            $route = Route::getRoutes()->getByName($name);

            if (
                ! $route
                || ! in_array('GET', $route->methods())
                || (
                    isset($guards[$name])
                    && ! bouncer()->hasPermission($guards[$name])
                )
            ) {
                continue;
            }

            if (preg_match('/\{[^}?]+\}/', $route->uri())) {
                continue;
            }

            return $name;
        }

        return null;
    }

    /**
     * Recursively find the first accessible child permission.
     *
     * @param  Collection  $allPermissions
     * @param  string  $parentKey
     * @return array|null
     */
    private function findFirstAccessibleChildPermission($allPermissions, $parentKey)
    {
        $children = $allPermissions->filter(function ($item) use ($parentKey) {
            return str_starts_with($item['key'], $parentKey.'.')
                && substr_count($item['key'], '.') === substr_count($parentKey, '.') + 1
                && bouncer()->hasPermission($item['key']);
        })->values();

        if ($children->isEmpty()) {
            return null;
        }

        foreach ($children as $child) {
            if ($this->hasAllRequiredPermissionsForRoute($allPermissions, $child['route'])) {
                return $child;
            }

            $descendant = $this->findFirstAccessibleChildPermission($allPermissions, $child['key']);

            if ($descendant) {
                return $descendant;
            }
        }

        return null;
    }

    /**
     * Check if user has all required permissions for a given route.
     *
     * @param  Collection  $allPermissions
     * @param  string  $route
     * @return bool
     */
    private function hasAllRequiredPermissionsForRoute($allPermissions, $route)
    {
        $requiredPermissions = $allPermissions->where('route', $route);

        foreach ($requiredPermissions as $permission) {
            if (! bouncer()->hasPermission($permission['key'])) {
                return false;
            }
        }

        return true;
    }
}
