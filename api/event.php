<?php
declare(strict_types=1);
require __DIR__ . '/config.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') respond(405, ['error'=>'Method not allowed']);
$d = json_input();
if (($d['consent'] ?? false) !== true) respond(400, ['error'=>'Consent required']);

$token = static function($v, int $max=80): string {
    $v = (string)$v;
    return substr(preg_replace('/[^a-zA-Z0-9._:-]/', '', $v) ?? '', 0, $max);
};
$visitor = $token($d['visitor_id'] ?? '');
$session = $token($d['session_id'] ?? '');
if (strlen($visitor)<12 || strlen($session)<8) respond(400, ['error'=>'Invalid analytics token']);

$allowed = ['session_start','page_view','page_exit','navigation','click','project_open','folder_open','file_preview','download','outbound_click','scroll_depth','search_used'];
$type = (string)($d['event_type'] ?? '');
if (!in_array($type, $allowed, true)) respond(400, ['error'=>'Invalid event type']);

$clean = static function($v, int $max): string {
    $v = trim((string)$v);
    $v = preg_replace('/[\x00-\x1F\x7F]/u', '', $v) ?? '';
    return mb_substr($v, 0, $max);
};
try {
    [$ua,$browser,$os,$kind] = visitor_device();
    $stmt = db()->prepare(
      'INSERT INTO portfolio_events
      (visitor_id,session_id,event_type,target_type,target_label,target_url,page_path,page_title,element_id,element_class,referrer,screen_width,screen_height,language_code,duration_ms,scroll_percent,ip_prefix,user_agent,browser,operating_system,device_type,consent_given)
      VALUES
      (:visitor,:session,:type,:target_type,:label,:url,:page,:title,:element_id,:element_class,:referrer,:sw,:sh,:lang,:duration,:scroll,:ip,:ua,:browser,:os,:device,1)'
    );
    $sw = isset($d['screen_width']) ? max(0,min(65535,(int)$d['screen_width'])) : null;
    $sh = isset($d['screen_height']) ? max(0,min(65535,(int)$d['screen_height'])) : null;
    $stmt->execute([
      ':visitor'=>$visitor, ':session'=>$session, ':type'=>$type,
      ':target_type'=>$clean($d['target_type'] ?? '',40),
      ':label'=>$clean($d['target_label'] ?? '',180),
      ':url'=>$clean($d['target_url'] ?? '',500),
      ':page'=>$clean($d['page'] ?? '/',180),
      ':title'=>$clean($d['page_title'] ?? '',200),
      ':element_id'=>$clean($d['element_id'] ?? '',100),
      ':element_class'=>$clean($d['element_class'] ?? '',180),
      ':referrer'=>$clean($d['referrer'] ?? '',500),
      ':sw'=>$sw, ':sh'=>$sh, ':lang'=>$clean($d['language'] ?? '',20),
      ':duration'=>max(0,min(86400000,(int)($d['duration_ms'] ?? 0))),
      ':scroll'=>max(0,min(100,(int)($d['scroll_percent'] ?? 0))),
      ':ip'=>client_ip_prefix(), ':ua'=>$ua, ':browser'=>$browser, ':os'=>$os, ':device'=>$kind
    ]);
    respond(201, ['ok'=>true]);
} catch (Throwable $e) {
    error_log('Portfolio event logging failed: '.$e->getMessage());
    respond(503, ['error'=>'Analytics temporarily unavailable']);
}
