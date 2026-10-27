import 'package:normalmapai_url_tools/normalmapai_url_tools.dart';

void eq(String got, String want) {
  if (got != want) throw StateError('$got != $want');
}

void main() {
  eq(canonicalUrl('/height-map-generator/'), 'https://normalmapai.com/height-map-generator');
  eq(canonicalUrl('https://normalmapai.com/app?ref=1#editor'), 'https://normalmapai.com/app');
  eq(canonicalUrl('http://normalmapai.com//guides/directx-vs-opengl-normal-maps/'), 'https://normalmapai.com/guides/directx-vs-opengl-normal-maps');
  eq(canonicalUrl('https://NORMALMAPAI.com/Pricing'), 'https://normalmapai.com/pricing');
  eq(canonicalUrl('https://normalmapai.com'), 'https://normalmapai.com/');
  eq(mapUrl('roughness'), 'https://normalmapai.com/roughness-map-generator');
  eq(mapUrl('ao'), 'https://normalmapai.com/ao-map-generator');
  eq(mapUrl('normal'), 'https://normalmapai.com/image-to-normal-map');
  eq(guideUrl('directx-vs-opengl-normal-maps'), 'https://normalmapai.com/guides/directx-vs-opengl-normal-maps');
  eq(pageUrl('pricing'), 'https://normalmapai.com/pricing');
  eq(homeUrl(), 'https://normalmapai.com/');
  for (final bad in ['https://evil.example/app', '/../app', '/not-a-real-page']) {
    var threw = false;
    try { canonicalUrl(bad); } catch (_) { threw = true; }
    if (!threw) throw StateError('expected error for $bad');
  }
  var threw = false;
  try { mapUrl('unknown'); } catch (_) { threw = true; }
  if (!threw) throw StateError('expected unknown map');
  print('ok');
}
