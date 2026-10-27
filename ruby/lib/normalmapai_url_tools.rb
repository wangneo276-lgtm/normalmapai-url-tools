module NormalMapAiUrlTools
  ORIGIN = 'https://normalmapai.com'.freeze
  DESCRIPTION = 'Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender.'.freeze
  PATHS = ['/', '/app', '/pricing', '/guides', '/about', '/contact', '/privacy', '/terms', '/ai-texture-generator', '/ai-3d-texture', '/ai-3d-model-generator', '/seamless-texture', '/metallic-map-generator', '/curvature-map-generator', '/orm-map-generator', '/glossiness-map-generator', '/albedo-map-generator', '/tileable-texture-generator', '/normal-map-inverter', '/height-to-normal-map', '/normal-to-height-map', '/seamless-texture-checker', '/3d-print-height-map', '/power-of-two-texture-resizer', '/bump-map-generator', '/ao-map-generator', '/roughness-map-generator', '/height-map-generator', '/displacement-map-generator', '/specular-map-generator', '/texture-maker', '/pbr-texture-generator', '/transparent-png', '/image-to-normal-map', '/guides/how-to-use-normal-map-generator', '/guides/how-to-make-seamless-textures', '/guides/import-pbr-maps-unity-unreal-blender', '/guides/pbr-maps-explained', '/guides/height-vs-displacement-maps', '/guides/directx-vs-opengl-normal-maps'].freeze
  MAPS = {"normal" => "/image-to-normal-map", "height" => "/height-map-generator", "roughness" => "/roughness-map-generator", "ao" => "/ao-map-generator", "bump" => "/bump-map-generator", "displacement" => "/displacement-map-generator", "specular" => "/specular-map-generator", "metallic" => "/metallic-map-generator", "curvature" => "/curvature-map-generator", "orm" => "/orm-map-generator", "glossiness" => "/glossiness-map-generator", "albedo" => "/albedo-map-generator"}.freeze
  GUIDES = {"how-to-use-normal-map-generator" => "/guides/how-to-use-normal-map-generator", "how-to-make-seamless-textures" => "/guides/how-to-make-seamless-textures", "import-pbr-maps-unity-unreal-blender" => "/guides/import-pbr-maps-unity-unreal-blender", "pbr-maps-explained" => "/guides/pbr-maps-explained", "height-vs-displacement-maps" => "/guides/height-vs-displacement-maps", "directx-vs-opengl-normal-maps" => "/guides/directx-vs-opengl-normal-maps"}.freeze
  PAGES = {"home" => "/", "app" => "/app", "pricing" => "/pricing", "guides" => "/guides", "about" => "/about", "contact" => "/contact", "privacy" => "/privacy", "terms" => "/terms"}.freeze

  module_function

  def canonical_url(input)
    raise ArgumentError, 'path required' unless input.is_a?(String)
    raw = input.strip
    raise ArgumentError, 'path required' if raw.empty?
    raise ArgumentError, 'invalid path' if raw.include?('\\') || raw.include?('%')
    raw = raw.split('#', 2)[0]
    raw = raw.split('?', 2)[0]
    lower = raw.downcase
    if lower.start_with?('https://') || lower.start_with?('http://') || raw.start_with?('//')
      rest = if lower.start_with?('https://')
               raw[8..]
             elsif lower.start_with?('http://')
               raw[7..]
             else
               raw[2..]
             end
      slash = rest.index('/')
      hostport = slash.nil? ? rest : rest[0...slash]
      path = slash.nil? ? '/' : rest[slash..]
      raise ArgumentError, 'userinfo not allowed' if hostport.include?('@')
      raise ArgumentError, 'port not allowed' if hostport.include?(':')
      raise ArgumentError, 'host not allowed' unless hostport.downcase == 'normalmapai.com'
    elsif raw.start_with?('/')
      path = raw
    else
      path = '/' + raw
    end
    path = path.downcase
    path = path.gsub(%r{//+}, '/')
    path.split('/').each do |seg|
      raise ArgumentError, 'path traversal' if seg == '.' || seg == '..'
    end
    path = path.sub(%r{/+$}, '') if path.length > 1
    path = '/' if path.empty?
    raise ArgumentError, 'unknown path: ' + path unless PATHS.include?(path)
    path == '/' ? ORIGIN + '/' : ORIGIN + path
  end

  def home_url
    canonical_url('/')
  end

  def page_url(name)
    path = PAGES[name] or raise ArgumentError, 'unknown page: ' + name
    canonical_url(path)
  end

  def map_url(kind)
    path = MAPS[kind] or raise ArgumentError, 'unknown map: ' + kind
    canonical_url(path)
  end

  def guide_url(slug)
    path = GUIDES[slug] or raise ArgumentError, 'unknown guide: ' + slug
    canonical_url(path)
  end
end
