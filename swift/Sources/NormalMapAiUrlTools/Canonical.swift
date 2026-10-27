import Foundation

public enum UrlError: Error { case message(String) }

public enum Urls {
    public static let origin = "https://normalmapai.com"
    public static let description = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender."
    private static let paths: Set<String> = [
        "/",
        "/app",
        "/pricing",
        "/guides",
        "/about",
        "/contact",
        "/privacy",
        "/terms",
        "/ai-texture-generator",
        "/ai-3d-texture",
        "/ai-3d-model-generator",
        "/seamless-texture",
        "/metallic-map-generator",
        "/curvature-map-generator",
        "/orm-map-generator",
        "/glossiness-map-generator",
        "/albedo-map-generator",
        "/tileable-texture-generator",
        "/normal-map-inverter",
        "/height-to-normal-map",
        "/normal-to-height-map",
        "/seamless-texture-checker",
        "/3d-print-height-map",
        "/power-of-two-texture-resizer",
        "/bump-map-generator",
        "/ao-map-generator",
        "/roughness-map-generator",
        "/height-map-generator",
        "/displacement-map-generator",
        "/specular-map-generator",
        "/texture-maker",
        "/pbr-texture-generator",
        "/transparent-png",
        "/image-to-normal-map",
        "/guides/how-to-use-normal-map-generator",
        "/guides/how-to-make-seamless-textures",
        "/guides/import-pbr-maps-unity-unreal-blender",
        "/guides/pbr-maps-explained",
        "/guides/height-vs-displacement-maps",
        "/guides/directx-vs-opengl-normal-maps"
    ]
    private static let maps = [
        "normal": "/image-to-normal-map",
        "height": "/height-map-generator",
        "roughness": "/roughness-map-generator",
        "ao": "/ao-map-generator",
        "bump": "/bump-map-generator",
        "displacement": "/displacement-map-generator",
        "specular": "/specular-map-generator",
        "metallic": "/metallic-map-generator",
        "curvature": "/curvature-map-generator",
        "orm": "/orm-map-generator",
        "glossiness": "/glossiness-map-generator",
        "albedo": "/albedo-map-generator"
    ]
    private static let guides = [
        "how-to-use-normal-map-generator": "/guides/how-to-use-normal-map-generator",
        "how-to-make-seamless-textures": "/guides/how-to-make-seamless-textures",
        "import-pbr-maps-unity-unreal-blender": "/guides/import-pbr-maps-unity-unreal-blender",
        "pbr-maps-explained": "/guides/pbr-maps-explained",
        "height-vs-displacement-maps": "/guides/height-vs-displacement-maps",
        "directx-vs-opengl-normal-maps": "/guides/directx-vs-opengl-normal-maps"
    ]
    private static let pages = [
        "home": "/",
        "app": "/app",
        "pricing": "/pricing",
        "guides": "/guides",
        "about": "/about",
        "contact": "/contact",
        "privacy": "/privacy",
        "terms": "/terms"
    ]

    public static func canonicalUrl(_ input: String) throws -> String {
        var raw = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if raw.isEmpty { throw UrlError.message("path required") }
        if raw.contains("\\") || raw.contains("%") { throw UrlError.message("invalid path") }
        if let hash = raw.firstIndex(of: "#") { raw = String(raw[..<hash]) }
        if let query = raw.firstIndex(of: "?") { raw = String(raw[..<query]) }
        let lower = raw.lowercased()
        var path: String
        if lower.hasPrefix("https://") || lower.hasPrefix("http://") || raw.hasPrefix("//") {
            let rest: String
            if lower.hasPrefix("https://") { rest = String(raw.dropFirst("https://".count)) }
            else if lower.hasPrefix("http://") { rest = String(raw.dropFirst("http://".count)) }
            else { rest = String(raw.dropFirst(2)) }
            if let slash = rest.firstIndex(of: "/") {
                let hostport = String(rest[..<slash])
                path = String(rest[slash...])
                try checkHost(hostport)
            } else {
                try checkHost(rest)
                path = "/"
            }
        } else if raw.hasPrefix("/") {
            path = raw
        } else {
            path = "/" + raw
        }
        path = path.lowercased()
        while path.contains("//") { path = path.replacingOccurrences(of: "//", with: "/") }
        for seg in path.split(separator: "/", omittingEmptySubsequences: false) {
            if seg == "." || seg == ".." { throw UrlError.message("path traversal") }
        }
        if path.count > 1 {
            while path.hasSuffix("/") { path.removeLast() }
        }
        if path.isEmpty { path = "/" }
        if !paths.contains(path) { throw UrlError.message("unknown path") }
        return path == "/" ? origin + "/" : origin + path
    }

    private static func checkHost(_ hostport: String) throws {
        if hostport.contains("@") { throw UrlError.message("userinfo not allowed") }
        if hostport.contains(":") { throw UrlError.message("port not allowed") }
        if hostport.lowercased() != "normalmapai.com" { throw UrlError.message("host not allowed") }
    }

    public static func homeUrl() throws -> String { try canonicalUrl("/") }
    public static func pageUrl(_ name: String) throws -> String { try lookup(pages, name, "page") }
    public static func mapUrl(_ kind: String) throws -> String { try lookup(maps, kind, "map") }
    public static func guideUrl(_ slug: String) throws -> String { try lookup(guides, slug, "guide") }

    private static func lookup(_ table: [String: String], _ key: String, _ label: String) throws -> String {
        guard let path = table[key] else { throw UrlError.message("unknown \(label)") }
        return try canonicalUrl(path)
    }
}
