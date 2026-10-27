# normalmapai-url-tools

Builds canonical HTTPS URLs for pages that exist on [NormalMapAI](https://normalmapai.com/).

Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.

Not an official SDK. The helper only accepts paths that are already on the public site. It does not upload images or call the site.

## Examples

- `canonicalUrl("/height-map-generator/")` → https://normalmapai.com/height-map-generator
- `canonicalUrl("https://normalmapai.com/app?ref=1#editor")` → https://normalmapai.com/app
- `mapUrl("roughness")` → https://normalmapai.com/roughness-map-generator
- `mapUrl("ao")` → https://normalmapai.com/ao-map-generator
- `guideUrl("directx-vs-opengl-normal-maps")` → https://normalmapai.com/guides/directx-vs-opengl-normal-maps
- `pageUrl("pricing")` → https://normalmapai.com/pricing

Source: https://github.com/wangneo276-lgtm/normalmapai-url-tools

License: MIT.
