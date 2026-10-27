using System;
using System.Collections.Generic;

namespace NormalMapAi.UrlTools;

/// <summary>Canonical HTTPS URLs for pages on https://normalmapai.com/.</summary>
public static class Urls
{
    public const string Origin = "https://normalmapai.com";
    public const string Description = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.";
    private static readonly HashSet<string> Paths = BuildPaths();
    private static readonly Dictionary<string, string> Maps = new()
    {
        { "normal", "/image-to-normal-map" },
        { "height", "/height-map-generator" },
        { "roughness", "/roughness-map-generator" },
        { "ao", "/ao-map-generator" },
        { "bump", "/bump-map-generator" },
        { "displacement", "/displacement-map-generator" },
        { "specular", "/specular-map-generator" },
        { "metallic", "/metallic-map-generator" },
        { "curvature", "/curvature-map-generator" },
        { "orm", "/orm-map-generator" },
        { "glossiness", "/glossiness-map-generator" },
        { "albedo", "/albedo-map-generator" },
    };
    private static readonly Dictionary<string, string> Guides = new()
    {
        { "how-to-use-normal-map-generator", "/guides/how-to-use-normal-map-generator" },
        { "how-to-make-seamless-textures", "/guides/how-to-make-seamless-textures" },
        { "import-pbr-maps-unity-unreal-blender", "/guides/import-pbr-maps-unity-unreal-blender" },
        { "pbr-maps-explained", "/guides/pbr-maps-explained" },
        { "height-vs-displacement-maps", "/guides/height-vs-displacement-maps" },
        { "directx-vs-opengl-normal-maps", "/guides/directx-vs-opengl-normal-maps" },
    };
    private static readonly Dictionary<string, string> Pages = new()
    {
        { "home", "/" },
        { "app", "/app" },
        { "pricing", "/pricing" },
        { "guides", "/guides" },
        { "about", "/about" },
        { "contact", "/contact" },
        { "privacy", "/privacy" },
        { "terms", "/terms" },
    };

    private static HashSet<string> BuildPaths()
    {
        var paths = new HashSet<string>(StringComparer.Ordinal);
        paths.Add("/");
        paths.Add("/app");
        paths.Add("/pricing");
        paths.Add("/guides");
        paths.Add("/about");
        paths.Add("/contact");
        paths.Add("/privacy");
        paths.Add("/terms");
        paths.Add("/ai-texture-generator");
        paths.Add("/ai-3d-texture");
        paths.Add("/ai-3d-model-generator");
        paths.Add("/seamless-texture");
        paths.Add("/metallic-map-generator");
        paths.Add("/curvature-map-generator");
        paths.Add("/orm-map-generator");
        paths.Add("/glossiness-map-generator");
        paths.Add("/albedo-map-generator");
        paths.Add("/tileable-texture-generator");
        paths.Add("/normal-map-inverter");
        paths.Add("/height-to-normal-map");
        paths.Add("/normal-to-height-map");
        paths.Add("/seamless-texture-checker");
        paths.Add("/3d-print-height-map");
        paths.Add("/power-of-two-texture-resizer");
        paths.Add("/bump-map-generator");
        paths.Add("/ao-map-generator");
        paths.Add("/roughness-map-generator");
        paths.Add("/height-map-generator");
        paths.Add("/displacement-map-generator");
        paths.Add("/specular-map-generator");
        paths.Add("/texture-maker");
        paths.Add("/pbr-texture-generator");
        paths.Add("/transparent-png");
        paths.Add("/image-to-normal-map");
        paths.Add("/guides/how-to-use-normal-map-generator");
        paths.Add("/guides/how-to-make-seamless-textures");
        paths.Add("/guides/import-pbr-maps-unity-unreal-blender");
        paths.Add("/guides/pbr-maps-explained");
        paths.Add("/guides/height-vs-displacement-maps");
        paths.Add("/guides/directx-vs-opengl-normal-maps");
        return paths;
    }

    public static string CanonicalUrl(string input)
    {
        if (input == null) throw new ArgumentException("path required");
        var raw = input.Trim();
        if (raw.Length == 0) throw new ArgumentException("path required");
        if (raw.Contains('\\') || raw.Contains('%')) throw new ArgumentException("invalid path");
        var hash = raw.IndexOf('#');
        if (hash >= 0) raw = raw.Substring(0, hash);
        var query = raw.IndexOf('?');
        if (query >= 0) raw = raw.Substring(0, query);
        var lower = raw.ToLowerInvariant();
        string path;
        if (lower.StartsWith("https://") || lower.StartsWith("http://") || raw.StartsWith("//"))
        {
            string rest;
            if (lower.StartsWith("https://")) rest = raw.Substring("https://".Length);
            else if (lower.StartsWith("http://")) rest = raw.Substring("http://".Length);
            else rest = raw.Substring(2);
            var slash = rest.IndexOf('/');
            var hostport = slash < 0 ? rest : rest.Substring(0, slash);
            path = slash < 0 ? "/" : rest.Substring(slash);
            if (hostport.Contains('@')) throw new ArgumentException("userinfo not allowed");
            if (hostport.Contains(':')) throw new ArgumentException("port not allowed");
            if (!hostport.Equals("normalmapai.com", StringComparison.OrdinalIgnoreCase))
                throw new ArgumentException("host not allowed");
        }
        else if (raw.StartsWith("/")) path = raw;
        else path = "/" + raw;
        path = path.ToLowerInvariant();
        while (path.Contains("//")) path = path.Replace("//", "/");
        foreach (var seg in path.Split('/'))
        {
            if (seg == "." || seg == "..") throw new ArgumentException("path traversal");
        }
        if (path.Length > 1) path = path.TrimEnd('/');
        if (path.Length == 0) path = "/";
        if (!Paths.Contains(path)) throw new ArgumentException("unknown path: " + path);
        return path == "/" ? Origin + "/" : Origin + path;
    }

    public static string HomeUrl() => CanonicalUrl("/");
    public static string PageUrl(string name) => Lookup(Pages, name, "page");
    public static string MapUrl(string kind) => Lookup(Maps, kind, "map");
    public static string GuideUrl(string slug) => Lookup(Guides, slug, "guide");

    private static string Lookup(Dictionary<string, string> table, string key, string label)
    {
        if (!table.TryGetValue(key, out var path))
            throw new ArgumentException("unknown " + label + ": " + key);
        return CanonicalUrl(path);
    }
}
