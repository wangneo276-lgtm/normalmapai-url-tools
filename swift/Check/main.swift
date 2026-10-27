import Darwin
import NormalMapAiUrlTools

func eq(_ got: String, _ want: String) {
    if got != want {
        fputs("\(got) != \(want)\n", stderr)
        exit(1)
    }
}

eq(try Urls.canonicalUrl("/height-map-generator/"), "https://normalmapai.com/height-map-generator")
eq(try Urls.canonicalUrl("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app")
eq(try Urls.canonicalUrl("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(try Urls.canonicalUrl("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing")
eq(try Urls.canonicalUrl("https://normalmapai.com"), "https://normalmapai.com/")
eq(try Urls.mapUrl("roughness"), "https://normalmapai.com/roughness-map-generator")
eq(try Urls.mapUrl("ao"), "https://normalmapai.com/ao-map-generator")
eq(try Urls.mapUrl("normal"), "https://normalmapai.com/image-to-normal-map")
eq(try Urls.guideUrl("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
eq(try Urls.pageUrl("pricing"), "https://normalmapai.com/pricing")
eq(try Urls.homeUrl(), "https://normalmapai.com/")
for bad in ["https://evil.example/app", "/../app", "/not-a-real-page"] {
    do {
        _ = try Urls.canonicalUrl(bad)
        fputs("expected error for \(bad)\n", stderr)
        exit(1)
    } catch {}
}
do {
    _ = try Urls.mapUrl("unknown")
    fputs("expected unknown map\n", stderr)
    exit(1)
} catch {}
print("ok")
