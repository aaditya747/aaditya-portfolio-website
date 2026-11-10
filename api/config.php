<?php
declare(strict_types=1);

/*
 * Configure these environment variables in your hosting control panel.
 * Do not commit real database credentials to a public repository.
 */
function db(): PDO {
    $host = getenv('DB_HOST') ?: 'localhost';
    $name = getenv('DB_NAME') ?: '';
    $user = getenv('DB_USER') ?: '';
    $pass = getenv('DB_PASS') ?: '';
    if ($name === '' || $user === '') {
        http_response_code(503);
        throw new RuntimeException('Database is not configured.');
    }
    return new PDO(
        "mysql:host={$host};dbname={$name};charset=utf8mb4",
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );
}
function json_input(): array {
    $data = json_decode(file_get_contents('php://input') ?: '{}', true);
    return is_array($data) ? $data : [];
}
function respond(int $status, array $data): never {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-store');
    echo json_encode($data);
    exit;
}
function client_ip_prefix(): string {
    // Use REMOTE_ADDR only. Do not trust spoofable X-Forwarded-For headers.
    $ip = $_SERVER['REMOTE_ADDR'] ?? '';
    $packed = @inet_pton($ip);
    if ($packed === false) return 'unknown';
    if (strlen($packed) === 4) {
        // IPv4 /24: retain network prefix, zero the last octet.
        return inet_ntop(substr($packed, 0, 3) . "\x00") . '/24';
    }
    // IPv6 /56: retain first 7 bytes and zero the remainder.
    return inet_ntop(substr($packed, 0, 7) . str_repeat("\x00", 9)) . '/56';
}
function visitor_device(): array {
    $ua = substr($_SERVER['HTTP_USER_AGENT'] ?? 'unknown', 0, 500);
    $browser = 'Other';
    foreach (['Edg'=>'Edge','OPR'=>'Opera','Chrome'=>'Chrome','Firefox'=>'Firefox','Safari'=>'Safari'] as $needle=>$label) {
        if (stripos($ua, $needle) !== false) { $browser=$label; break; }
    }
    $os = 'Other';
    foreach (['Windows'=>'Windows','Android'=>'Android','iPhone|iPad|iOS'=>'iOS','Mac OS'=>'macOS','Linux'=>'Linux'] as $needle=>$label) {
        if (preg_match('/'.$needle.'/i', $ua)) { $os=$label; break; }
    }
    $kind = preg_match('/iPhone|Android|Mobile/i', $ua) ? 'Mobile' : (preg_match('/iPad|Tablet/i',$ua) ? 'Tablet' : 'Desktop');
    return [$ua,$browser,$os,$kind];
}
