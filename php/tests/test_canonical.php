<?php

declare(strict_types=1);

require __DIR__ . '/../src/NormalMapAi/UrlTools/Canonical.php';

use NormalMapAi\UrlTools\Canonical;

function eq(string $got, string $want, string $label): void
{
    if ($got !== $want) {
        fwrite(STDERR, "$label: $got != $want\n");
        exit(1);
    }
}

eq(Canonical::canonicalUrl('/height-map-generator/'), 'https://normalmapai.com/height-map-generator', 'height');
eq(Canonical::canonicalUrl('https://normalmapai.com/app?ref=1#editor'), 'https://normalmapai.com/app', 'app');
eq(Canonical::canonicalUrl('http://normalmapai.com//guides/directx-vs-opengl-normal-maps/'), 'https://normalmapai.com/guides/directx-vs-opengl-normal-maps', 'guide path');
eq(Canonical::canonicalUrl('https://NORMALMAPAI.com/Pricing'), 'https://normalmapai.com/pricing', 'case');
eq(Canonical::canonicalUrl('https://normalmapai.com'), 'https://normalmapai.com/', 'origin');
eq(Canonical::mapUrl('roughness'), 'https://normalmapai.com/roughness-map-generator', 'roughness');
eq(Canonical::mapUrl('ao'), 'https://normalmapai.com/ao-map-generator', 'ao');
eq(Canonical::mapUrl('normal'), 'https://normalmapai.com/image-to-normal-map', 'normal');
eq(Canonical::guideUrl('directx-vs-opengl-normal-maps'), 'https://normalmapai.com/guides/directx-vs-opengl-normal-maps', 'guide');
eq(Canonical::pageUrl('pricing'), 'https://normalmapai.com/pricing', 'pricing');
eq(Canonical::homeUrl(), 'https://normalmapai.com/', 'home');

foreach (['https://evil.example/app', '/../app', '/not-a-real-page'] as $bad) {
    try {
        Canonical::canonicalUrl($bad);
        fwrite(STDERR, "expected error for $bad\n");
        exit(1);
    } catch (InvalidArgumentException $e) {
    }
}
try {
    Canonical::mapUrl('unknown');
    fwrite(STDERR, "expected unknown map\n");
    exit(1);
} catch (InvalidArgumentException $e) {
}
echo "ok\n";
