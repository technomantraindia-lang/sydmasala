<!DOCTYPE html>
<html lang="en" style="background:#0f172a;color:#e2e8f0;font-family:ui-monospace,Menlo,Monaco,Consolas,monospace;padding:32px;font-size:14px;line-height:1.6;">
<head>
    <meta charset="UTF-8">
    <title>Error {{ $errorCode ?? 500 }} - Raw Server Details</title>
</head>
<body>
    <div style="max-width:1100px;margin:0 auto;">
        <div style="border-bottom:2px solid #334155;padding-bottom:16px;margin-bottom:24px;">
            <span style="background:#ef4444;color:white;padding:4px 10px;border-radius:4px;font-weight:bold;font-size:13px;letter-spacing:0.05em;">HTTP {{ $errorCode ?? 500 }} ERROR</span>
            <h1 style="color:#f87171;font-size:24px;margin:12px 0 6px 0;word-break:break-all;">
                {{ $errorMessage ?? (isset($throwable) ? $throwable->getMessage() : 'An unexpected server error occurred.') }}
            </h1>
            @if(isset($throwable))
                <p style="color:#94a3b8;margin:0;">Exception: <span style="color:#cbd5e1;">{{ get_class($throwable) }}</span></p>
                <p style="color:#94a3b8;margin:4px 0 0 0;">Location: <span style="color:#38bdf8;">{{ $throwable->getFile() }}:{{ $throwable->getLine() }}</span></p>
            @elseif(!empty($errorFile))
                <p style="color:#94a3b8;margin:4px 0 0 0;">Location: <span style="color:#38bdf8;">{{ $errorFile }}</span></p>
            @endif
        </div>

        @if(isset($throwable) && file_exists($throwable->getFile()))
            @php
                $fileLines = file($throwable->getFile());
                $start = max(0, $throwable->getLine() - 7);
                $end = min(count($fileLines), $throwable->getLine() + 6);
                $snippet = '';
                for ($i = $start; $i < $end; $i++) {
                    $num = $i + 1;
                    $isError = ($num === $throwable->getLine());
                    $snippet .= sprintf("%s %4d | %s", $isError ? '>>>' : '   ', $num, $fileLines[$i]);
                }
            @endphp
            <h3 style="color:#38bdf8;margin:20px 0 8px 0;">Source Code:</h3>
            <pre style="background:#020617;border:1px solid #1e293b;padding:16px;border-radius:8px;overflow:auto;line-height:1.5;color:#e2e8f0;">{{ $snippet }}</pre>
        @endif

        @if(isset($throwable))
            <h3 style="color:#38bdf8;margin:20px 0 8px 0;">Stack Trace:</h3>
            <pre style="background:#020617;border:1px solid #1e293b;padding:16px;border-radius:8px;overflow:auto;max-height:500px;font-size:12px;line-height:1.5;color:#cbd5e1;">{{ $throwable->getTraceAsString() }}</pre>
        @endif

        <div style="margin-top:24px;padding-top:16px;border-top:1px solid #334155;">
            <a href="{{ url('/admin/login') }}" style="color:#60a5fa;margin-right:16px;text-decoration:none;">&larr; Admin Login</a>
            <a href="{{ url('/reset-session') }}" style="color:#fbbf24;margin-right:16px;text-decoration:none;">&circlearrowright; Reset Session</a>
            <a href="{{ url('/quick-admin') }}" style="color:#4ade80;text-decoration:none;">&check; Quick Admin</a>
        </div>
    </div>
</body>
</html>