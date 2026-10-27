import test from "node:test";
import assert from "node:assert/strict";
import { canonicalUrl, guideUrl, homeUrl, mapUrl, metadata, pageUrl } from "./index.js";

test("canonical urls", () => {
  assert.equal(canonicalUrl("/height-map-generator/"), "https://normalmapai.com/height-map-generator");
  assert.equal(canonicalUrl("https://normalmapai.com/app?ref=1#editor"), "https://normalmapai.com/app");
  assert.equal(canonicalUrl("http://normalmapai.com//guides/directx-vs-opengl-normal-maps/"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
  assert.equal(canonicalUrl("https://NORMALMAPAI.com/Pricing"), "https://normalmapai.com/pricing");
  assert.equal(canonicalUrl("https://normalmapai.com"), "https://normalmapai.com/");
  assert.equal(canonicalUrl("height-map-generator"), "https://normalmapai.com/height-map-generator");
  assert.equal(mapUrl("roughness"), "https://normalmapai.com/roughness-map-generator");
  assert.equal(mapUrl("ao"), "https://normalmapai.com/ao-map-generator");
  assert.equal(mapUrl("normal"), "https://normalmapai.com/image-to-normal-map");
  assert.equal(guideUrl("directx-vs-opengl-normal-maps"), "https://normalmapai.com/guides/directx-vs-opengl-normal-maps");
  assert.equal(pageUrl("pricing"), "https://normalmapai.com/pricing");
  assert.equal(homeUrl(), "https://normalmapai.com/");
  assert.equal(metadata().homepage, "https://normalmapai.com/");
});

test("rejects unknown or unsafe input", () => {
  assert.throws(() => canonicalUrl("https://evil.example/app"), /host not allowed/);
  assert.throws(() => canonicalUrl("/../app"), /path traversal/);
  assert.throws(() => canonicalUrl("/not-a-real-page"), /unknown path/);
  assert.throws(() => mapUrl("unknown"), /unknown map/);
});
