const ORIGIN = "https://normalmapai.com";
const PATHS = new Set(["/", "/app", "/pricing", "/guides", "/about", "/contact", "/privacy", "/terms", "/ai-texture-generator", "/ai-3d-texture", "/ai-3d-model-generator", "/seamless-texture", "/metallic-map-generator", "/curvature-map-generator", "/orm-map-generator", "/glossiness-map-generator", "/albedo-map-generator", "/tileable-texture-generator", "/normal-map-inverter", "/height-to-normal-map", "/normal-to-height-map", "/seamless-texture-checker", "/3d-print-height-map", "/power-of-two-texture-resizer", "/bump-map-generator", "/ao-map-generator", "/roughness-map-generator", "/height-map-generator", "/displacement-map-generator", "/specular-map-generator", "/texture-maker", "/pbr-texture-generator", "/transparent-png", "/image-to-normal-map", "/guides/how-to-use-normal-map-generator", "/guides/how-to-make-seamless-textures", "/guides/import-pbr-maps-unity-unreal-blender", "/guides/pbr-maps-explained", "/guides/height-vs-displacement-maps", "/guides/directx-vs-opengl-normal-maps"]);
const MAPS = {"normal": "/image-to-normal-map", "height": "/height-map-generator", "roughness": "/roughness-map-generator", "ao": "/ao-map-generator", "bump": "/bump-map-generator", "displacement": "/displacement-map-generator", "specular": "/specular-map-generator", "metallic": "/metallic-map-generator", "curvature": "/curvature-map-generator", "orm": "/orm-map-generator", "glossiness": "/glossiness-map-generator", "albedo": "/albedo-map-generator"};
const GUIDES = {"how-to-use-normal-map-generator": "/guides/how-to-use-normal-map-generator", "how-to-make-seamless-textures": "/guides/how-to-make-seamless-textures", "import-pbr-maps-unity-unreal-blender": "/guides/import-pbr-maps-unity-unreal-blender", "pbr-maps-explained": "/guides/pbr-maps-explained", "height-vs-displacement-maps": "/guides/height-vs-displacement-maps", "directx-vs-opengl-normal-maps": "/guides/directx-vs-opengl-normal-maps"};
const PAGES = {"home": "/", "app": "/app", "pricing": "/pricing", "guides": "/guides", "about": "/about", "contact": "/contact", "privacy": "/privacy", "terms": "/terms"};
const DESCRIPTION = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.";

function canonicalUrl(input) {
  if (typeof input !== "string") throw new Error("path required");
  let raw = input.trim();
  if (!raw) throw new Error("path required");
  if (raw.includes("\\") || raw.includes("%")) throw new Error("invalid path");
  const hash = raw.indexOf("#");
  if (hash >= 0) raw = raw.slice(0, hash);
  const query = raw.indexOf("?");
  if (query >= 0) raw = raw.slice(0, query);
  let path;
  const lower = raw.toLowerCase();
  if (lower.startsWith("https://") || lower.startsWith("http://") || raw.startsWith("//")) {
    let rest = raw;
    if (lower.startsWith("https://")) rest = raw.slice("https://".length);
    else if (lower.startsWith("http://")) rest = raw.slice("http://".length);
    else rest = raw.slice(2);
    const slash = rest.indexOf("/");
    const hostport = slash === -1 ? rest : rest.slice(0, slash);
    path = slash === -1 ? "/" : rest.slice(slash);
    if (hostport.includes("@")) throw new Error("userinfo not allowed");
    if (hostport.includes(":")) throw new Error("port not allowed");
    if (hostport.toLowerCase() !== "normalmapai.com") throw new Error("host not allowed");
  } else if (raw.startsWith("/")) {
    path = raw;
  } else {
    path = "/" + raw;
  }
  path = path.toLowerCase().replace(/\/{2,}/g, "/");
  for (const seg of path.split("/")) {
    if (seg === "." || seg === "..") throw new Error("path traversal");
  }
  if (path.length > 1) path = path.replace(/\/+$/, "");
  if (path === "") path = "/";
  if (!PATHS.has(path)) throw new Error("unknown path: " + path);
  return path === "/" ? ORIGIN + "/" : ORIGIN + path;
}

export function homeUrl() {
  return canonicalUrl("/");
}

export function pageUrl(name) {
  if (!Object.prototype.hasOwnProperty.call(PAGES, name)) throw new Error("unknown page: " + name);
  return canonicalUrl(PAGES[name]);
}

export function mapUrl(kind) {
  if (!Object.prototype.hasOwnProperty.call(MAPS, kind)) throw new Error("unknown map: " + kind);
  return canonicalUrl(MAPS[kind]);
}

export function guideUrl(slug) {
  if (!Object.prototype.hasOwnProperty.call(GUIDES, slug)) throw new Error("unknown guide: " + slug);
  return canonicalUrl(GUIDES[slug]);
}

export function metadata() {
  return {
    name: "NormalMapAI",
    homepage: homeUrl(),
    description: DESCRIPTION,
    canonicalPages: Object.fromEntries(Object.keys(PAGES).map((name) => [name, pageUrl(name)])),
  };
}

export { canonicalUrl, ORIGIN, DESCRIPTION };
