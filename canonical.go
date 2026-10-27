// Package normalmapai builds canonical HTTPS URLs for pages on https://normalmapai.com/.
package normalmapai

import (
	"fmt"
	"strings"
)

const Origin = "https://normalmapai.com"
const Description = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender."

var paths = map[string]struct{}{
	"/":                                            struct{}{},
	"/app":                                         struct{}{},
	"/pricing":                                     struct{}{},
	"/guides":                                      struct{}{},
	"/about":                                       struct{}{},
	"/contact":                                     struct{}{},
	"/privacy":                                     struct{}{},
	"/terms":                                       struct{}{},
	"/ai-texture-generator":                        struct{}{},
	"/ai-3d-texture":                               struct{}{},
	"/ai-3d-model-generator":                       struct{}{},
	"/seamless-texture":                            struct{}{},
	"/metallic-map-generator":                      struct{}{},
	"/curvature-map-generator":                     struct{}{},
	"/orm-map-generator":                           struct{}{},
	"/glossiness-map-generator":                    struct{}{},
	"/albedo-map-generator":                        struct{}{},
	"/tileable-texture-generator":                  struct{}{},
	"/normal-map-inverter":                         struct{}{},
	"/height-to-normal-map":                        struct{}{},
	"/normal-to-height-map":                        struct{}{},
	"/seamless-texture-checker":                    struct{}{},
	"/3d-print-height-map":                         struct{}{},
	"/power-of-two-texture-resizer":                struct{}{},
	"/bump-map-generator":                          struct{}{},
	"/ao-map-generator":                            struct{}{},
	"/roughness-map-generator":                     struct{}{},
	"/height-map-generator":                        struct{}{},
	"/displacement-map-generator":                  struct{}{},
	"/specular-map-generator":                      struct{}{},
	"/texture-maker":                               struct{}{},
	"/pbr-texture-generator":                       struct{}{},
	"/transparent-png":                             struct{}{},
	"/image-to-normal-map":                         struct{}{},
	"/guides/how-to-use-normal-map-generator":      struct{}{},
	"/guides/how-to-make-seamless-textures":        struct{}{},
	"/guides/import-pbr-maps-unity-unreal-blender": struct{}{},
	"/guides/pbr-maps-explained":                   struct{}{},
	"/guides/height-vs-displacement-maps":          struct{}{},
	"/guides/directx-vs-opengl-normal-maps":        struct{}{},
}

var maps = map[string]string{
	"normal":       "/image-to-normal-map",
	"height":       "/height-map-generator",
	"roughness":    "/roughness-map-generator",
	"ao":           "/ao-map-generator",
	"bump":         "/bump-map-generator",
	"displacement": "/displacement-map-generator",
	"specular":     "/specular-map-generator",
	"metallic":     "/metallic-map-generator",
	"curvature":    "/curvature-map-generator",
	"orm":          "/orm-map-generator",
	"glossiness":   "/glossiness-map-generator",
	"albedo":       "/albedo-map-generator",
}

var guides = map[string]string{
	"how-to-use-normal-map-generator":      "/guides/how-to-use-normal-map-generator",
	"how-to-make-seamless-textures":        "/guides/how-to-make-seamless-textures",
	"import-pbr-maps-unity-unreal-blender": "/guides/import-pbr-maps-unity-unreal-blender",
	"pbr-maps-explained":                   "/guides/pbr-maps-explained",
	"height-vs-displacement-maps":          "/guides/height-vs-displacement-maps",
	"directx-vs-opengl-normal-maps":        "/guides/directx-vs-opengl-normal-maps",
}

var pages = map[string]string{
	"home":    "/",
	"app":     "/app",
	"pricing": "/pricing",
	"guides":  "/guides",
	"about":   "/about",
	"contact": "/contact",
	"privacy": "/privacy",
	"terms":   "/terms",
}

func CanonicalURL(input string) (string, error) {
	raw := strings.TrimSpace(input)
	if raw == "" {
		return "", fmt.Errorf("path required")
	}
	if strings.Contains(raw, "\\") || strings.Contains(raw, "%") {
		return "", fmt.Errorf("invalid path")
	}
	if i := strings.IndexByte(raw, '#'); i >= 0 {
		raw = raw[:i]
	}
	if i := strings.IndexByte(raw, '?'); i >= 0 {
		raw = raw[:i]
	}
	lower := strings.ToLower(raw)
	var path string
	switch {
	case strings.HasPrefix(lower, "https://"), strings.HasPrefix(lower, "http://"), strings.HasPrefix(raw, "//"):
		rest := raw
		switch {
		case strings.HasPrefix(lower, "https://"):
			rest = raw[len("https://"):]
		case strings.HasPrefix(lower, "http://"):
			rest = raw[len("http://"):]
		default:
			rest = raw[2:]
		}
		hostport := rest
		path = "/"
		if i := strings.IndexByte(rest, '/'); i >= 0 {
			hostport = rest[:i]
			path = rest[i:]
		}
		if strings.Contains(hostport, "@") {
			return "", fmt.Errorf("userinfo not allowed")
		}
		if strings.Contains(hostport, ":") {
			return "", fmt.Errorf("port not allowed")
		}
		if !strings.EqualFold(hostport, "normalmapai.com") {
			return "", fmt.Errorf("host not allowed")
		}
	case strings.HasPrefix(raw, "/"):
		path = raw
	default:
		path = "/" + raw
	}
	path = strings.ToLower(path)
	for strings.Contains(path, "//") {
		path = strings.ReplaceAll(path, "//", "/")
	}
	for _, seg := range strings.Split(path, "/") {
		if seg == "." || seg == ".." {
			return "", fmt.Errorf("path traversal")
		}
	}
	if len(path) > 1 {
		path = strings.TrimRight(path, "/")
	}
	if path == "" {
		path = "/"
	}
	if _, ok := paths[path]; !ok {
		return "", fmt.Errorf("unknown path: %s", path)
	}
	if path == "/" {
		return Origin + "/", nil
	}
	return Origin + path, nil
}

func lookup(table map[string]string, key, label string) (string, error) {
	path, ok := table[key]
	if !ok {
		return "", fmt.Errorf("unknown %s: %s", label, key)
	}
	return CanonicalURL(path)
}

func HomeURL() string {
	u, err := CanonicalURL("/")
	if err != nil {
		panic(err)
	}
	return u
}

func PageURL(name string) (string, error)  { return lookup(pages, name, "page") }
func MapURL(kind string) (string, error)   { return lookup(maps, kind, "map") }
func GuideURL(slug string) (string, error) { return lookup(guides, slug, "guide") }
