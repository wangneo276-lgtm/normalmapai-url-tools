const ORIGIN: &str = "https://normalmapai.com";
const DESCRIPTION: &str = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.";

fn known(path: &str) -> bool {
    matches!(path, "/" | "/app" | "/pricing" | "/guides" | "/about" | "/contact" | "/privacy" | "/terms" | "/ai-texture-generator" | "/ai-3d-texture" | "/ai-3d-model-generator" | "/seamless-texture" | "/metallic-map-generator" | "/curvature-map-generator" | "/orm-map-generator" | "/glossiness-map-generator" | "/albedo-map-generator" | "/tileable-texture-generator" | "/normal-map-inverter" | "/height-to-normal-map" | "/normal-to-height-map" | "/seamless-texture-checker" | "/3d-print-height-map" | "/power-of-two-texture-resizer" | "/bump-map-generator" | "/ao-map-generator" | "/roughness-map-generator" | "/height-map-generator" | "/displacement-map-generator" | "/specular-map-generator" | "/texture-maker" | "/pbr-texture-generator" | "/transparent-png" | "/image-to-normal-map" | "/guides/how-to-use-normal-map-generator" | "/guides/how-to-make-seamless-textures" | "/guides/import-pbr-maps-unity-unreal-blender" | "/guides/pbr-maps-explained" | "/guides/height-vs-displacement-maps" | "/guides/directx-vs-opengl-normal-maps")
}

pub fn canonical_url(input: &str) -> Result<String, &'static str> {
    let raw = input.trim();
    if raw.is_empty() {
        return Err("path required");
    }
    if raw.contains('\\') || raw.contains('%') {
        return Err("invalid path");
    }
    let raw = raw.split('#').next().unwrap_or(raw);
    let raw = raw.split('?').next().unwrap_or(raw);
    let lower = raw.to_ascii_lowercase();
    let path = if lower.starts_with("https://") || lower.starts_with("http://") || raw.starts_with("//") {
        let rest = if lower.starts_with("https://") {
            &raw["https://".len()..]
        } else if lower.starts_with("http://") {
            &raw["http://".len()..]
        } else {
            &raw[2..]
        };
        let (hostport, path) = match rest.find('/') {
            Some(i) => (&rest[..i], &rest[i..]),
            None => (rest, "/"),
        };
        if hostport.contains('@') {
            return Err("userinfo not allowed");
        }
        if hostport.contains(':') {
            return Err("port not allowed");
        }
        if !hostport.eq_ignore_ascii_case("normalmapai.com") {
            return Err("host not allowed");
        }
        path.to_string()
    } else if raw.starts_with('/') {
        raw.to_string()
    } else {
        format!("/{raw}")
    };
    let mut path = path.to_ascii_lowercase();
    while path.contains("//") {
        path = path.replace("//", "/");
    }
    for seg in path.split('/') {
        if seg == "." || seg == ".." {
            return Err("path traversal");
        }
    }
    if path.len() > 1 {
        path = path.trim_end_matches('/').to_string();
    }
    if path.is_empty() {
        path = "/".to_string();
    }
    if !known(&path) {
        return Err("unknown path");
    }
    if path == "/" {
        Ok(format!("{ORIGIN}/"))
    } else {
        Ok(format!("{ORIGIN}{path}"))
    }
}

fn lookup<'a>(table: &'a [(&str, &str)], key: &str, label: &'static str) -> Result<&'a str, String> {
    table.iter().find(|(k, _)| *k == key).map(|(_, v)| *v).ok_or_else(|| format!("unknown {label}"))
}

pub fn page_url(name: &str) -> Result<String, String> {
    let path = lookup(&[        ("home", "/"),
        ("app", "/app"),
        ("pricing", "/pricing"),
        ("guides", "/guides"),
        ("about", "/about"),
        ("contact", "/contact"),
        ("privacy", "/privacy"),
        ("terms", "/terms"),
    ], name, "page")?;
    canonical_url(path).map_err(|e| e.to_string())
}

pub fn map_url(kind: &str) -> Result<String, String> {
    let path = lookup(&[        ("normal", "/image-to-normal-map"),
        ("height", "/height-map-generator"),
        ("roughness", "/roughness-map-generator"),
        ("ao", "/ao-map-generator"),
        ("bump", "/bump-map-generator"),
        ("displacement", "/displacement-map-generator"),
        ("specular", "/specular-map-generator"),
        ("metallic", "/metallic-map-generator"),
        ("curvature", "/curvature-map-generator"),
        ("orm", "/orm-map-generator"),
        ("glossiness", "/glossiness-map-generator"),
        ("albedo", "/albedo-map-generator"),
    ], kind, "map")?;
    canonical_url(path).map_err(|e| e.to_string())
}

pub fn guide_url(slug: &str) -> Result<String, String> {
    let path = lookup(&[        ("how-to-use-normal-map-generator", "/guides/how-to-use-normal-map-generator"),
        ("how-to-make-seamless-textures", "/guides/how-to-make-seamless-textures"),
        ("import-pbr-maps-unity-unreal-blender", "/guides/import-pbr-maps-unity-unreal-blender"),
        ("pbr-maps-explained", "/guides/pbr-maps-explained"),
        ("height-vs-displacement-maps", "/guides/height-vs-displacement-maps"),
        ("directx-vs-opengl-normal-maps", "/guides/directx-vs-opengl-normal-maps"),
    ], slug, "guide")?;
    canonical_url(path).map_err(|e| e.to_string())
}

pub fn home_url() -> String {
    canonical_url("/").expect("home")
}

pub fn description() -> &'static str {
    DESCRIPTION
}
