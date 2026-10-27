from __future__ import annotations

ORIGIN = 'https://normalmapai.com'
DESCRIPTION = 'Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.'
PATHS = {
    '/',
    '/app',
    '/pricing',
    '/guides',
    '/about',
    '/contact',
    '/privacy',
    '/terms',
    '/ai-texture-generator',
    '/ai-3d-texture',
    '/ai-3d-model-generator',
    '/seamless-texture',
    '/metallic-map-generator',
    '/curvature-map-generator',
    '/orm-map-generator',
    '/glossiness-map-generator',
    '/albedo-map-generator',
    '/tileable-texture-generator',
    '/normal-map-inverter',
    '/height-to-normal-map',
    '/normal-to-height-map',
    '/seamless-texture-checker',
    '/3d-print-height-map',
    '/power-of-two-texture-resizer',
    '/bump-map-generator',
    '/ao-map-generator',
    '/roughness-map-generator',
    '/height-map-generator',
    '/displacement-map-generator',
    '/specular-map-generator',
    '/texture-maker',
    '/pbr-texture-generator',
    '/transparent-png',
    '/image-to-normal-map',
    '/guides/how-to-use-normal-map-generator',
    '/guides/how-to-make-seamless-textures',
    '/guides/import-pbr-maps-unity-unreal-blender',
    '/guides/pbr-maps-explained',
    '/guides/height-vs-displacement-maps',
    '/guides/directx-vs-opengl-normal-maps'
}
MAPS = {'normal': '/image-to-normal-map', 'height': '/height-map-generator', 'roughness': '/roughness-map-generator', 'ao': '/ao-map-generator', 'bump': '/bump-map-generator', 'displacement': '/displacement-map-generator', 'specular': '/specular-map-generator', 'metallic': '/metallic-map-generator', 'curvature': '/curvature-map-generator', 'orm': '/orm-map-generator', 'glossiness': '/glossiness-map-generator', 'albedo': '/albedo-map-generator'}
GUIDES = {'how-to-use-normal-map-generator': '/guides/how-to-use-normal-map-generator', 'how-to-make-seamless-textures': '/guides/how-to-make-seamless-textures', 'import-pbr-maps-unity-unreal-blender': '/guides/import-pbr-maps-unity-unreal-blender', 'pbr-maps-explained': '/guides/pbr-maps-explained', 'height-vs-displacement-maps': '/guides/height-vs-displacement-maps', 'directx-vs-opengl-normal-maps': '/guides/directx-vs-opengl-normal-maps'}
PAGES = {'home': '/', 'app': '/app', 'pricing': '/pricing', 'guides': '/guides', 'about': '/about', 'contact': '/contact', 'privacy': '/privacy', 'terms': '/terms'}


def canonical_url(value: str) -> str:
    if not isinstance(value, str):
        raise ValueError("path required")
    raw = value.strip()
    if not raw:
        raise ValueError("path required")
    if "\\" in raw or "%" in raw:
        raise ValueError("invalid path")
    raw = raw.split("#", 1)[0]
    raw = raw.split("?", 1)[0]
    lower = raw.lower()
    if lower.startswith("https://") or lower.startswith("http://") or raw.startswith("//"):
        if lower.startswith("https://"):
            rest = raw[len("https://"):]
        elif lower.startswith("http://"):
            rest = raw[len("http://"):]
        else:
            rest = raw[2:]
        slash = rest.find("/")
        hostport = rest if slash == -1 else rest[:slash]
        path = "/" if slash == -1 else rest[slash:]
        if "@" in hostport:
            raise ValueError("userinfo not allowed")
        if ":" in hostport:
            raise ValueError("port not allowed")
        if hostport.lower() != "normalmapai.com":
            raise ValueError("host not allowed")
    elif raw.startswith("/"):
        path = raw
    else:
        path = "/" + raw
    path = path.lower()
    while "//" in path:
        path = path.replace("//", "/")
    for seg in path.split("/"):
        if seg in (".", ".."):
            raise ValueError("path traversal")
    if len(path) > 1:
        path = path.rstrip("/")
    if path == "":
        path = "/"
    if path not in PATHS:
        raise ValueError("unknown path: " + path)
    return ORIGIN + "/" if path == "/" else ORIGIN + path


def home_url() -> str:
    return canonical_url("/")


def page_url(name: str) -> str:
    try:
        path = PAGES[name]
    except KeyError:
        raise ValueError("unknown page: " + name) from None
    return canonical_url(path)


def map_url(kind: str) -> str:
    try:
        path = MAPS[kind]
    except KeyError:
        raise ValueError("unknown map: " + kind) from None
    return canonical_url(path)


def guide_url(slug: str) -> str:
    try:
        path = GUIDES[slug]
    except KeyError:
        raise ValueError("unknown guide: " + slug) from None
    return canonical_url(path)


def metadata() -> dict[str, object]:
    return {
        "name": "NormalMapAI",
        "homepage": home_url(),
        "description": DESCRIPTION,
        "canonicalPages": {name: page_url(name) for name in PAGES},
    }
