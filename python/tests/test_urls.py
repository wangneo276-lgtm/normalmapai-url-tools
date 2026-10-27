import unittest
from normalmapai_url_tools import canonical_url, guide_url, home_url, map_url, metadata, page_url

class UrlTests(unittest.TestCase):
    def test_canonical(self):
        self.assertEqual(canonical_url("/height-map-generator/"), "https://normalmapai.com/height-map-generator")
        self.assertEqual(canonical_url("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app")
        self.assertEqual(canonical_url("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
        self.assertEqual(canonical_url("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing")
        self.assertEqual(canonical_url("https://normalmapai.com"), "https://normalmapai.com/")
        self.assertEqual(canonical_url("height-map-generator"), "https://normalmapai.com/height-map-generator")
        self.assertEqual(map_url("roughness"), "https://normalmapai.com/roughness-map-generator")
        self.assertEqual(map_url("ao"), "https://normalmapai.com/ao-map-generator")
        self.assertEqual(map_url("normal"), "https://normalmapai.com/image-to-normal-map")
        self.assertEqual(guide_url("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps")
        self.assertEqual(page_url("pricing"), "https://normalmapai.com/pricing")
        self.assertEqual(home_url(), "https://normalmapai.com/")
        self.assertEqual(metadata()["homepage"], "https://normalmapai.com/")

    def test_rejects(self):
        with self.assertRaises(ValueError):
            canonical_url("https://evil.example/app")
        with self.assertRaises(ValueError):
            canonical_url("/../app")
        with self.assertRaises(ValueError):
            canonical_url("/not-a-real-page")
        with self.assertRaises(ValueError):
            map_url("unknown")

if __name__ == "__main__":
    unittest.main()
