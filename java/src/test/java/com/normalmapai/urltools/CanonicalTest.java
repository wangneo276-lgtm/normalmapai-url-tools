package com.normalmapai.urltools;

public final class CanonicalTest {
    private static void eq(String got, String want) {
        if (!want.equals(got)) {
            throw new AssertionError(got + " != " + want);
        }
    }

    public static void main(String[] args) {
        eq(Canonical.canonicalUrl("/height-map-generator/"), "https://normalmapai.com/height-map-generator");
        eq(Canonical.canonicalUrl("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app");
        eq(Canonical.canonicalUrl("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
        eq(Canonical.canonicalUrl("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing");
        eq(Canonical.canonicalUrl("https://normalmapai.com"), "https://normalmapai.com/");
        eq(Canonical.mapUrl("roughness"), "https://normalmapai.com/roughness-map-generator");
        eq(Canonical.mapUrl("ao"), "https://normalmapai.com/ao-map-generator");
        eq(Canonical.mapUrl("normal"), "https://normalmapai.com/image-to-normal-map");
        eq(Canonical.guideUrl("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
        eq(Canonical.pageUrl("pricing"), "https://normalmapai.com/pricing");
        eq(Canonical.homeUrl(), "https://normalmapai.com/");
        for (String bad : new String[] {"https://evil.example/app", "/../app", "/not-a-real-page"}) {
            try {
                Canonical.canonicalUrl(bad);
                throw new AssertionError("expected error for " + bad);
            } catch (IllegalArgumentException expected) {
                // rejected
            }
        }
        try {
            Canonical.mapUrl("unknown");
            throw new AssertionError("expected unknown map");
        } catch (IllegalArgumentException expected) {
            // rejected
        }
        System.out.println("ok");
    }
}
