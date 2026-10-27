local M = dofile((arg[0]:gsub("test%.lua$", "normalmapai_url_tools.lua")))
local function eq(got, want)
  if got ~= want then error(tostring(got) .. " != " .. tostring(want)) end
end
eq(M.canonical_url("/height-map-generator/"), "https://normalmapai.com/height-map-generator")
eq(M.canonical_url("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app")
eq(M.canonical_url("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(M.canonical_url("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing")
eq(M.canonical_url("https://normalmapai.com"), "https://normalmapai.com/")
eq(M.map_url("roughness"), "https://normalmapai.com/roughness-map-generator")
eq(M.map_url("ao"), "https://normalmapai.com/ao-map-generator")
eq(M.map_url("normal"), "https://normalmapai.com/image-to-normal-map")
eq(M.guide_url("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(M.page_url("pricing"), "https://normalmapai.com/pricing")
eq(M.home_url(), "https://normalmapai.com/")
for _, bad in ipairs({"https://evil.example/app", "/../app", "/not-a-real-page"}) do
  local ok = pcall(M.canonical_url, bad)
  if ok then error("expected error for " .. bad) end
end
local ok = pcall(M.map_url, "unknown")
if ok then error("expected unknown map") end
print("ok")
