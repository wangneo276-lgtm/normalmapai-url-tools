FROM busybox:1.36.1
LABEL org.opencontainers.image.title="normalmapai-url-tools" \
      org.opencontainers.image.description="Free normal map generator by NormalMapAI. Convert any photo into a normal map with live 3D preview — plus height, roughness, AO and more. Private in-browser; export for Unity, Unreal, Godot and Blender." \
      org.opencontainers.image.url="https://normalmapai.com/" \
      org.opencontainers.image.source="https://github.com/wangneo276-lgtm/normalmapai-url-tools" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.licenses="MIT"
COPY bin/normalmapai-url-tools /usr/local/bin/normalmapai-url-tools
RUN chmod +x /usr/local/bin/normalmapai-url-tools
ENTRYPOINT ["/usr/local/bin/normalmapai-url-tools"]
