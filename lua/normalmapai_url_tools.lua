local M = {}
M.origin = "https://normalmapai.com"
M.description = "Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender."
local paths = { ["/"]=true, ["/app"]=true, ["/pricing"]=true, ["/guides"]=true, ["/about"]=true, ["/contact"]=true, ["/privacy"]=true, ["/terms"]=true, ["/ai-texture-generator"]=true, ["/ai-3d-texture"]=true, ["/ai-3d-model-generator"]=true, ["/seamless-texture"]=true, ["/metallic-map-generator"]=true, ["/curvature-map-generator"]=true, ["/orm-map-generator"]=true, ["/glossiness-map-generator"]=true, ["/albedo-map-generator"]=true, ["/tileable-texture-generator"]=true, ["/normal-map-inverter"]=true, ["/height-to-normal-map"]=true, ["/normal-to-height-map"]=true, ["/seamless-texture-checker"]=true, ["/3d-print-height-map"]=true, ["/power-of-two-texture-resizer"]=true, ["/bump-map-generator"]=true, ["/ao-map-generator"]=true, ["/roughness-map-generator"]=true, ["/height-map-generator"]=true, ["/displacement-map-generator"]=true, ["/specular-map-generator"]=true, ["/texture-maker"]=true, ["/pbr-texture-generator"]=true, ["/transparent-png"]=true, ["/image-to-normal-map"]=true, ["/guides/how-to-use-normal-map-generator"]=true, ["/guides/how-to-make-seamless-textures"]=true, ["/guides/import-pbr-maps-unity-unreal-blender"]=true, ["/guides/pbr-maps-explained"]=true, ["/guides/height-vs-displacement-maps"]=true, ["/guides/directx-vs-opengl-normal-maps"]=true }
local maps = { ["normal"]="/image-to-normal-map", ["height"]="/height-map-generator", ["roughness"]="/roughness-map-generator", ["ao"]="/ao-map-generator", ["bump"]="/bump-map-generator", ["displacement"]="/displacement-map-generator", ["specular"]="/specular-map-generator", ["metallic"]="/metallic-map-generator", ["curvature"]="/curvature-map-generator", ["orm"]="/orm-map-generator", ["glossiness"]="/glossiness-map-generator", ["albedo"]="/albedo-map-generator" }
local guides = { ["how-to-use-normal-map-generator"]="/guides/how-to-use-normal-map-generator", ["how-to-make-seamless-textures"]="/guides/how-to-make-seamless-textures", ["import-pbr-maps-unity-unreal-blender"]="/guides/import-pbr-maps-unity-unreal-blender", ["pbr-maps-explained"]="/guides/pbr-maps-explained", ["height-vs-displacement-maps"]="/guides/height-vs-displacement-maps", ["directx-vs-opengl-normal-maps"]="/guides/directx-vs-opengl-normal-maps" }
local pages = { ["home"]="/", ["app"]="/app", ["pricing"]="/pricing", ["guides"]="/guides", ["about"]="/about", ["contact"]="/contact", ["privacy"]="/privacy", ["terms"]="/terms" }

local function canonical_url(input)
  if type(input) ~= "string" then error("path required") end
  local raw = input:match("^%s*(.-)%s*$")
  if raw == "" then error("path required") end
  if raw:find("\\", 1, true) or raw:find("%%") then error("invalid path") end
  raw = raw:gsub("#.*", ""):gsub("%?.*", "")
  local lower = raw:lower()
  local path
  if lower:sub(1, 8) == "https://" or lower:sub(1, 7) == "http://" or raw:sub(1, 2) == "//" then
    local rest
    if lower:sub(1, 8) == "https://" then rest = raw:sub(9)
    elseif lower:sub(1, 7) == "http://" then rest = raw:sub(8)
    else rest = raw:sub(3) end
    local slash = rest:find("/", 1, true)
    local hostport = slash and rest:sub(1, slash - 1) or rest
    path = slash and rest:sub(slash) or "/"
    if hostport:find("@", 1, true) then error("userinfo not allowed") end
    if hostport:find(":", 1, true) then error("port not allowed") end
    if hostport:lower() ~= "normalmapai.com" then error("host not allowed") end
  elseif raw:sub(1, 1) == "/" then
    path = raw
  else
    path = "/" .. raw
  end
  path = path:lower():gsub("//+", "/")
  for seg in (path .. "/"):gmatch("([^/]*)/") do
    if seg == "." or seg == ".." then error("path traversal") end
  end
  if #path > 1 then path = path:gsub("/+$", "") end
  if path == "" then path = "/" end
  if not paths[path] then error("unknown path: " .. path) end
  if path == "/" then return M.origin .. "/" end
  return M.origin .. path
end

local function lookup(table, key, label)
  local path = table[key]
  if not path then error("unknown " .. label .. ": " .. key) end
  return canonical_url(path)
end

M.canonical_url = canonical_url
function M.home_url() return canonical_url("/") end
function M.page_url(name) return lookup(pages, name, "page") end
function M.map_url(kind) return lookup(maps, kind, "map") end
function M.guide_url(slug) return lookup(guides, slug, "guide") end
return M
