require_relative "lib/normalmapai_url_tools"

def eq(got, want)
  raise "got #{got.inspect} want #{want.inspect}" unless got == want
end

eq(NormalMapAiUrlTools.canonical_url("/height-map-generator/"), "https://normalmapai.com/height-map-generator")
eq(NormalMapAiUrlTools.canonical_url("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app")
eq(NormalMapAiUrlTools.canonical_url("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(NormalMapAiUrlTools.canonical_url("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing")
eq(NormalMapAiUrlTools.canonical_url("https://normalmapai.com"), "https://normalmapai.com/")
eq(NormalMapAiUrlTools.map_url("roughness"), "https://normalmapai.com/roughness-map-generator")
eq(NormalMapAiUrlTools.map_url("ao"), "https://normalmapai.com/ao-map-generator")
eq(NormalMapAiUrlTools.map_url("normal"), "https://normalmapai.com/image-to-normal-map")
eq(NormalMapAiUrlTools.guide_url("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(NormalMapAiUrlTools.page_url("pricing"), "https://normalmapai.com/pricing")
eq(NormalMapAiUrlTools.home_url, "https://normalmapai.com/")
%w[https://evil.example/app /../app /not-a-real-page].each do |bad|
  begin
    NormalMapAiUrlTools.canonical_url(bad)
    raise "expected error for #{bad}"
  rescue ArgumentError
  end
end
begin
  NormalMapAiUrlTools.map_url("unknown")
  raise "expected unknown map"
rescue ArgumentError
end
puts "ok"
