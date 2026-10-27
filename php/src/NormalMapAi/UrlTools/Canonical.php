<?php

declare(strict_types=1);

namespace NormalMapAi\UrlTools;

final class Canonical
{
    public const ORIGIN = 'https://normalmapai.com';
    public const DESCRIPTION = 'Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.';

    /** @var array<string, true> */
    private const PATHS = [
        "/" => true,
        "/app" => true,
        "/pricing" => true,
        "/guides" => true,
        "/about" => true,
        "/contact" => true,
        "/privacy" => true,
        "/terms" => true,
        "/ai-texture-generator" => true,
        "/ai-3d-texture" => true,
        "/ai-3d-model-generator" => true,
        "/seamless-texture" => true,
        "/metallic-map-generator" => true,
        "/curvature-map-generator" => true,
        "/orm-map-generator" => true,
        "/glossiness-map-generator" => true,
        "/albedo-map-generator" => true,
        "/tileable-texture-generator" => true,
        "/normal-map-inverter" => true,
        "/height-to-normal-map" => true,
        "/normal-to-height-map" => true,
        "/seamless-texture-checker" => true,
        "/3d-print-height-map" => true,
        "/power-of-two-texture-resizer" => true,
        "/bump-map-generator" => true,
        "/ao-map-generator" => true,
        "/roughness-map-generator" => true,
        "/height-map-generator" => true,
        "/displacement-map-generator" => true,
        "/specular-map-generator" => true,
        "/texture-maker" => true,
        "/pbr-texture-generator" => true,
        "/transparent-png" => true,
        "/image-to-normal-map" => true,
        "/guides/how-to-use-normal-map-generator" => true,
        "/guides/how-to-make-seamless-textures" => true,
        "/guides/import-pbr-maps-unity-unreal-blender" => true,
        "/guides/pbr-maps-explained" => true,
        "/guides/height-vs-displacement-maps" => true,
        "/guides/directx-vs-opengl-normal-maps" => true,
    ];

    /** @param array<string, string> $table */
    private static function lookup(array $table, string $key, string $label): string
    {
        if (!array_key_exists($key, $table)) {
            throw new \InvalidArgumentException('unknown ' . $label . ': ' . $key);
        }
        return self::canonicalUrl($table[$key]);
    }

    public static function canonicalUrl(string $input): string
    {
        $raw = trim($input);
        if ($raw === '') {
            throw new \InvalidArgumentException('path required');
        }
        if (str_contains($raw, '\\') || str_contains($raw, '%')) {
            throw new \InvalidArgumentException('invalid path');
        }
        $hash = strpos($raw, '#');
        if ($hash !== false) {
            $raw = substr($raw, 0, $hash);
        }
        $query = strpos($raw, '?');
        if ($query !== false) {
            $raw = substr($raw, 0, $query);
        }
        $lower = strtolower($raw);
        if (str_starts_with($lower, 'https://') || str_starts_with($lower, 'http://') || str_starts_with($raw, '//')) {
            if (str_starts_with($lower, 'https://')) {
                $rest = substr($raw, strlen('https://'));
            } elseif (str_starts_with($lower, 'http://')) {
                $rest = substr($raw, strlen('http://'));
            } else {
                $rest = substr($raw, 2);
            }
            $slash = strpos($rest, '/');
            $hostport = $slash === false ? $rest : substr($rest, 0, $slash);
            $path = $slash === false ? '/' : substr($rest, $slash);
            if (str_contains($hostport, '@')) {
                throw new \InvalidArgumentException('userinfo not allowed');
            }
            if (str_contains($hostport, ':')) {
                throw new \InvalidArgumentException('port not allowed');
            }
            if (strtolower($hostport) !== 'normalmapai.com') {
                throw new \InvalidArgumentException('host not allowed');
            }
        } elseif (str_starts_with($raw, '/')) {
            $path = $raw;
        } else {
            $path = '/' . $raw;
        }
        $path = strtolower($path);
        while (str_contains($path, '//')) {
            $path = str_replace('//', '/', $path);
        }
        foreach (explode('/', $path) as $seg) {
            if ($seg === '.' || $seg === '..') {
                throw new \InvalidArgumentException('path traversal');
            }
        }
        if (strlen($path) > 1) {
            $path = rtrim($path, '/');
        }
        if ($path === '') {
            $path = '/';
        }
        if (!isset(self::PATHS[$path])) {
            throw new \InvalidArgumentException('unknown path: ' . $path);
        }
        return $path === '/' ? self::ORIGIN . '/' : self::ORIGIN . $path;
    }

    public static function homeUrl(): string
    {
        return self::canonicalUrl('/');
    }

    public static function pageUrl(string $name): string
    {
        return self::lookup([
            "home" => "/",
            "app" => "/app",
            "pricing" => "/pricing",
            "guides" => "/guides",
            "about" => "/about",
            "contact" => "/contact",
            "privacy" => "/privacy",
            "terms" => "/terms",
        ], $name, 'page');
    }

    public static function mapUrl(string $kind): string
    {
        return self::lookup([
            "normal" => "/image-to-normal-map",
            "height" => "/height-map-generator",
            "roughness" => "/roughness-map-generator",
            "ao" => "/ao-map-generator",
            "bump" => "/bump-map-generator",
            "displacement" => "/displacement-map-generator",
            "specular" => "/specular-map-generator",
            "metallic" => "/metallic-map-generator",
            "curvature" => "/curvature-map-generator",
            "orm" => "/orm-map-generator",
            "glossiness" => "/glossiness-map-generator",
            "albedo" => "/albedo-map-generator",
        ], $kind, 'map');
    }

    public static function guideUrl(string $slug): string
    {
        return self::lookup([
            "how-to-use-normal-map-generator" => "/guides/how-to-use-normal-map-generator",
            "how-to-make-seamless-textures" => "/guides/how-to-make-seamless-textures",
            "import-pbr-maps-unity-unreal-blender" => "/guides/import-pbr-maps-unity-unreal-blender",
            "pbr-maps-explained" => "/guides/pbr-maps-explained",
            "height-vs-displacement-maps" => "/guides/height-vs-displacement-maps",
            "directx-vs-opengl-normal-maps" => "/guides/directx-vs-opengl-normal-maps",
        ], $slug, 'guide');
    }
}
