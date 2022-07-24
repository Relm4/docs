FROM ghcr.io/gtk-rs/gtk4-rs/gtk4:latest

# Build Libpanel
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git --depth 1
WORKDIR libpanel
RUN meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false
RUN meson install -C builddir
WORKDIR /
RUN rm -rf libpanel