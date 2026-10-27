using NormalMapAi.UrlTools;
using Xunit;

public class UrlTests
{
    [Fact]
    public void CanonicalUrls()
    {
        Assert.Equal("https://normalmapai.com/height-map-generator", Urls.CanonicalUrl("/height-map-generator/"));
        Assert.Equal("https://normalmapai.com/app", Urls.CanonicalUrl("https://normalmapai.com/app?ref=1#editor"));
        Assert.Equal("https://normalmapai.com/guides/directx-vs-opengl-normal-maps", Urls.CanonicalUrl("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"));
        Assert.Equal("https://normalmapai.com/pricing", Urls.CanonicalUrl("https://NORMALMAPAI.com/Pricing"));
        Assert.Equal("https://normalmapai.com/", Urls.CanonicalUrl("https://normalmapai.com"));
        Assert.Equal("https://normalmapai.com/roughness-map-generator", Urls.MapUrl("roughness"));
        Assert.Equal("https://normalmapai.com/ao-map-generator", Urls.MapUrl("ao"));
        Assert.Equal("https://normalmapai.com/image-to-normal-map", Urls.MapUrl("normal"));
        Assert.Equal("https://normalmapai.com/guides/directx-vs-opengl-normal-maps", Urls.GuideUrl("directx-vs-opengl-normal-maps"));
        Assert.Equal("https://normalmapai.com/pricing", Urls.PageUrl("pricing"));
        Assert.Equal("https://normalmapai.com/", Urls.HomeUrl());
    }

    [Fact]
    public void Rejects()
    {
        Assert.Throws<ArgumentException>(() => Urls.CanonicalUrl("https://evil.example/app"));
        Assert.Throws<ArgumentException>(() => Urls.CanonicalUrl("/../app"));
        Assert.Throws<ArgumentException>(() => Urls.CanonicalUrl("/not-a-real-page"));
        Assert.Throws<ArgumentException>(() => Urls.MapUrl("unknown"));
    }
}
