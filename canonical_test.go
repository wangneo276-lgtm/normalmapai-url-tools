package normalmapai

import "testing"

func TestCanonical(t *testing.T) {
	cases := []struct{ in, out string }{
		{"/height-map-generator/", "https://normalmapai.com/height-map-generator"},
		{"https://normalmapai.com/app?ref=1#editor", "https://normalmapai.com/app"},
		{"http://normalmapai.com//guides/directx-vs-opengl-normal-maps/", "https://normalmapai.com/guides/directx-vs-opengl-normal-maps"},
		{"https://NORMALMAPAI.com/Pricing", "https://normalmapai.com/pricing"},
		{"https://normalmapai.com", "https://normalmapai.com/"},
		{"height-map-generator", "https://normalmapai.com/height-map-generator"},
	}
	for _, tc := range cases {
		got, err := CanonicalURL(tc.in)
		if err != nil || got != tc.out {
			t.Fatalf("%q -> %q %v, want %s", tc.in, got, err, tc.out)
		}
	}
	if u, _ := MapURL("roughness"); u != "https://normalmapai.com/roughness-map-generator" {
		t.Fatal(u)
	}
	if u, _ := MapURL("ao"); u != "https://normalmapai.com/ao-map-generator" {
		t.Fatal(u)
	}
	if u, _ := MapURL("normal"); u != "https://normalmapai.com/image-to-normal-map" {
		t.Fatal(u)
	}
	if u, _ := GuideURL("directx-vs-opengl-normal-maps"); u != "https://normalmapai.com/guides/directx-vs-opengl-normal-maps" {
		t.Fatal(u)
	}
	if u, _ := PageURL("pricing"); u != "https://normalmapai.com/pricing" {
		t.Fatal(u)
	}
	if HomeURL() != "https://normalmapai.com/" {
		t.Fatal(HomeURL())
	}
}

func TestRejects(t *testing.T) {
	for _, in := range []string{"https://evil.example/app", "/../app", "/not-a-real-page"} {
		if _, err := CanonicalURL(in); err == nil {
			t.Fatal("expected error", in)
		}
	}
	if _, err := MapURL("unknown"); err == nil {
		t.Fatal("expected unknown map")
	}
}
