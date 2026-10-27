use normalmapai_url_tools::{canonical_url, guide_url, home_url, map_url, page_url};

#[test]
fn canonical_urls() {
    assert_eq!(canonical_url("/height-map-generator/").unwrap(), "https://normalmapai.com/height-map-generator");
    assert_eq!(canonical_url("https://normalmapai.com/app?ref=1#editor").unwrap(), "https://normalmapai.com/app");
    assert_eq!(canonical_url("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/").unwrap(), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
    assert_eq!(canonical_url("https://NORMALMAPAI.com/Pricing").unwrap(), "https://normalmapai.com/pricing");
    assert_eq!(canonical_url("https://normalmapai.com").unwrap(), "https://normalmapai.com/");
    assert_eq!(canonical_url("height-map-generator").unwrap(), "https://normalmapai.com/height-map-generator");
    assert_eq!(map_url("roughness").unwrap(), "https://normalmapai.com/roughness-map-generator");
    assert_eq!(map_url("ao").unwrap(), "https://normalmapai.com/ao-map-generator");
    assert_eq!(map_url("normal").unwrap(), "https://normalmapai.com/image-to-normal-map");
    assert_eq!(guide_url("directx-vs-opengl-normal-maps").unwrap(), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
    assert_eq!(page_url("pricing").unwrap(), "https://normalmapai.com/pricing");
    assert_eq!(home_url(), "https://normalmapai.com/");
}

#[test]
fn rejects() {
    assert!(canonical_url("https://evil.example/app").is_err());
    assert!(canonical_url("/../app").is_err());
    assert!(canonical_url("/not-a-real-page").is_err());
    assert!(map_url("unknown").is_err());
}
