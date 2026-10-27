const origin = 'https://normalmapai.com';
const description = 'Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.';
const paths = <String>{'/', '/app', '/pricing', '/guides', '/about', '/contact', '/privacy', '/terms', '/ai-texture-generator', '/ai-3d-texture', '/ai-3d-model-generator', '/seamless-texture', '/metallic-map-generator', '/curvature-map-generator', '/orm-map-generator', '/glossiness-map-generator', '/albedo-map-generator', '/tileable-texture-generator', '/normal-map-inverter', '/height-to-normal-map', '/normal-to-height-map', '/seamless-texture-checker', '/3d-print-height-map', '/power-of-two-texture-resizer', '/bump-map-generator', '/ao-map-generator', '/roughness-map-generator', '/height-map-generator', '/displacement-map-generator', '/specular-map-generator', '/texture-maker', '/pbr-texture-generator', '/transparent-png', '/image-to-normal-map', '/guides/how-to-use-normal-map-generator', '/guides/how-to-make-seamless-textures', '/guides/import-pbr-maps-unity-unreal-blender', '/guides/pbr-maps-explained', '/guides/height-vs-displacement-maps', '/guides/directx-vs-opengl-normal-maps'};
const maps = <String, String>{'normal': '/image-to-normal-map', 'height': '/height-map-generator', 'roughness': '/roughness-map-generator', 'ao': '/ao-map-generator', 'bump': '/bump-map-generator', 'displacement': '/displacement-map-generator', 'specular': '/specular-map-generator', 'metallic': '/metallic-map-generator', 'curvature': '/curvature-map-generator', 'orm': '/orm-map-generator', 'glossiness': '/glossiness-map-generator', 'albedo': '/albedo-map-generator'};
const guides = <String, String>{'how-to-use-normal-map-generator': '/guides/how-to-use-normal-map-generator', 'how-to-make-seamless-textures': '/guides/how-to-make-seamless-textures', 'import-pbr-maps-unity-unreal-blender': '/guides/import-pbr-maps-unity-unreal-blender', 'pbr-maps-explained': '/guides/pbr-maps-explained', 'height-vs-displacement-maps': '/guides/height-vs-displacement-maps', 'directx-vs-opengl-normal-maps': '/guides/directx-vs-opengl-normal-maps'};
const pages = <String, String>{'home': '/', 'app': '/app', 'pricing': '/pricing', 'guides': '/guides', 'about': '/about', 'contact': '/contact', 'privacy': '/privacy', 'terms': '/terms'};

String canonicalUrl(String input) {
  final raw0 = input.trim();
  if (raw0.isEmpty) throw ArgumentError('path required');
  if (raw0.contains('\\') || raw0.contains('%')) throw ArgumentError('invalid path');
  var raw = raw0.split('#').first.split('?').first;
  final lower = raw.toLowerCase();
  late String path;
  if (lower.startsWith('https://') || lower.startsWith('http://') || raw.startsWith('//')) {
    final String rest;
    if (lower.startsWith('https://')) {
      rest = raw.substring('https://'.length);
    } else if (lower.startsWith('http://')) {
      rest = raw.substring('http://'.length);
    } else {
      rest = raw.substring(2);
    }
    final slash = rest.indexOf('/');
    final hostport = slash == -1 ? rest : rest.substring(0, slash);
    path = slash == -1 ? '/' : rest.substring(slash);
    if (hostport.contains('@')) throw ArgumentError('userinfo not allowed');
    if (hostport.contains(':')) throw ArgumentError('port not allowed');
    if (hostport.toLowerCase() != 'normalmapai.com') throw ArgumentError('host not allowed');
  } else if (raw.startsWith('/')) {
    path = raw;
  } else {
    path = '/$raw';
  }
  path = path.toLowerCase().replaceAll(RegExp(r'/{2,}'), '/');
  for (final seg in path.split('/')) {
    if (seg == '.' || seg == '..') throw ArgumentError('path traversal');
  }
  if (path.length > 1) {
    while (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
  }
  if (path.isEmpty) path = '/';
  if (!paths.contains(path)) throw ArgumentError('unknown path: $path');
  return path == '/' ? '$origin/' : '$origin$path';
}

String _lookup(Map<String, String> table, String key, String label) {
  final path = table[key];
  if (path == null) throw ArgumentError('unknown $label: $key');
  return canonicalUrl(path);
}

String homeUrl() => canonicalUrl('/');
String pageUrl(String name) => _lookup(pages, name, 'page');
String mapUrl(String kind) => _lookup(maps, kind, 'map');
String guideUrl(String slug) => _lookup(guides, slug, 'guide');
