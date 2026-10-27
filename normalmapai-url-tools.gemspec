Gem::Specification.new do |spec|
  spec.name = 'normalmapai-url-tools'
  spec.version = '0.1.0'
  spec.summary = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender."
  spec.description = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender."
  spec.authors = ['wangneo276-lgtm']
  spec.homepage = 'https://normalmapai.com/'
  spec.license = 'MIT'
  spec.files = Dir['ruby/lib/**/*.rb', 'README.md', 'LICENSE']
  spec.require_paths = ['ruby/lib']
  spec.required_ruby_version = '>= 3.0'
  spec.metadata = {
    'homepage_uri' => 'https://normalmapai.com/',
    'source_code_uri' => 'https://github.com/wangneo276-lgtm/normalmapai-url-tools'
  }
end
