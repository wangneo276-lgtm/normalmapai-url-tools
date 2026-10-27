package com.normalmapai.urltools;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/** Canonical HTTPS URLs for pages that exist on https://normalmapai.com/. */
public final class Canonical {
    /** Site origin without a trailing slash. */
    public static final String ORIGIN = "https://normalmapai.com";
    /** Homepage description copied from the live site. */
    public static final String DESCRIPTION = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.";
    private static final Set<String> PATHS = Set.of("/", "/app", "/pricing", "/guides", "/about", "/contact", "/privacy", "/terms", "/ai-texture-generator", "/ai-3d-texture", "/ai-3d-model-generator", "/seamless-texture", "/metallic-map-generator", "/curvature-map-generator", "/orm-map-generator", "/glossiness-map-generator", "/albedo-map-generator", "/tileable-texture-generator", "/normal-map-inverter", "/height-to-normal-map", "/normal-to-height-map", "/seamless-texture-checker", "/3d-print-height-map", "/power-of-two-texture-resizer", "/bump-map-generator", "/ao-map-generator", "/roughness-map-generator", "/height-map-generator", "/displacement-map-generator", "/specular-map-generator", "/texture-maker", "/pbr-texture-generator", "/transparent-png", "/image-to-normal-map", "/guides/how-to-use-normal-map-generator", "/guides/how-to-make-seamless-textures", "/guides/import-pbr-maps-unity-unreal-blender", "/guides/pbr-maps-explained", "/guides/height-vs-displacement-maps", "/guides/directx-vs-opengl-normal-maps");
    private static final Map<String, String> MAPS;
    static {
        Map<String, String> m = new HashMap<>();
        m.put("normal", "/image-to-normal-map");
        m.put("height", "/height-map-generator");
        m.put("roughness", "/roughness-map-generator");
        m.put("ao", "/ao-map-generator");
        m.put("bump", "/bump-map-generator");
        m.put("displacement", "/displacement-map-generator");
        m.put("specular", "/specular-map-generator");
        m.put("metallic", "/metallic-map-generator");
        m.put("curvature", "/curvature-map-generator");
        m.put("orm", "/orm-map-generator");
        m.put("glossiness", "/glossiness-map-generator");
        m.put("albedo", "/albedo-map-generator");
        MAPS = Map.copyOf(m);
    }
    private static final Map<String, String> GUIDES;
    static {
        Map<String, String> m = new HashMap<>();
        m.put("how-to-use-normal-map-generator", "/guides/how-to-use-normal-map-generator");
        m.put("how-to-make-seamless-textures", "/guides/how-to-make-seamless-textures");
        m.put("import-pbr-maps-unity-unreal-blender", "/guides/import-pbr-maps-unity-unreal-blender");
        m.put("pbr-maps-explained", "/guides/pbr-maps-explained");
        m.put("height-vs-displacement-maps", "/guides/height-vs-displacement-maps");
        m.put("directx-vs-opengl-normal-maps", "/guides/directx-vs-opengl-normal-maps");
        GUIDES = Map.copyOf(m);
    }
    private static final Map<String, String> PAGES;
    static {
        Map<String, String> m = new HashMap<>();
        m.put("home", "/");
        m.put("app", "/app");
        m.put("pricing", "/pricing");
        m.put("guides", "/guides");
        m.put("about", "/about");
        m.put("contact", "/contact");
        m.put("privacy", "/privacy");
        m.put("terms", "/terms");
        PAGES = Map.copyOf(m);
    }

    private Canonical() {}

    /**
     * Build the canonical URL for a known site path or absolute URL.
     *
     * @param input path, slug, or absolute URL on normalmapai.com
     * @return canonical https URL
     */
    public static String canonicalUrl(String input) {
        if (input == null) {
            throw new IllegalArgumentException("path required");
        }
        String raw = input.trim();
        if (raw.isEmpty()) {
            throw new IllegalArgumentException("path required");
        }
        if (raw.indexOf('\\') >= 0 || raw.indexOf('%') >= 0) {
            throw new IllegalArgumentException("invalid path");
        }
        int hash = raw.indexOf('#');
        if (hash >= 0) {
            raw = raw.substring(0, hash);
        }
        int query = raw.indexOf('?');
        if (query >= 0) {
            raw = raw.substring(0, query);
        }
        String lower = raw.toLowerCase(Locale.ROOT);
        String path;
        if (lower.startsWith("https://") || lower.startsWith("http://") || raw.startsWith("//")) {
            String rest;
            if (lower.startsWith("https://")) {
                rest = raw.substring("https://".length());
            } else if (lower.startsWith("http://")) {
                rest = raw.substring("http://".length());
            } else {
                rest = raw.substring(2);
            }
            int slash = rest.indexOf('/');
            String hostport = slash < 0 ? rest : rest.substring(0, slash);
            path = slash < 0 ? "/" : rest.substring(slash);
            if (hostport.indexOf('@') >= 0) {
                throw new IllegalArgumentException("userinfo not allowed");
            }
            if (hostport.indexOf(':') >= 0) {
                throw new IllegalArgumentException("port not allowed");
            }
            if (!hostport.toLowerCase(Locale.ROOT).equals("normalmapai.com")) {
                throw new IllegalArgumentException("host not allowed");
            }
        } else if (raw.startsWith("/")) {
            path = raw;
        } else {
            path = "/" + raw;
        }
        path = path.toLowerCase(Locale.ROOT);
        while (path.contains("//")) {
            path = path.replace("//", "/");
        }
        for (String seg : path.split("/", -1)) {
            if (seg.equals(".") || seg.equals("..")) {
                throw new IllegalArgumentException("path traversal");
            }
        }
        if (path.length() > 1) {
            while (path.endsWith("/")) {
                path = path.substring(0, path.length() - 1);
            }
        }
        if (path.isEmpty()) {
            path = "/";
        }
        if (!PATHS.contains(path)) {
            throw new IllegalArgumentException("unknown path: " + path);
        }
        return "/".equals(path) ? ORIGIN + "/" : ORIGIN + path;
    }

    /**
     * @return the site root
     */
    public static String homeUrl() {
        return canonicalUrl("/");
    }

    /**
     * @param name page key such as pricing
     * @return canonical page URL
     */
    public static String pageUrl(String name) {
        return lookup(PAGES, name, "page");
    }

    /**
     * @param kind map kind such as roughness or ao
     * @return canonical generator URL
     */
    public static String mapUrl(String kind) {
        return lookup(MAPS, kind, "map");
    }

    /**
     * @param slug guide slug
     * @return canonical guide URL
     */
    public static String guideUrl(String slug) {
        return lookup(GUIDES, slug, "guide");
    }

    private static String lookup(Map<String, String> table, String key, String label) {
        String path = table.get(key);
        if (path == null) {
            throw new IllegalArgumentException("unknown " + label + ": " + key);
        }
        return canonicalUrl(path);
    }
}
