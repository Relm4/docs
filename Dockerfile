FROM ghcr.io/gtk-rs/gtk4-rs/gtk4:latest

# Build Libpanel
# RUN git clone https://gitlab.gnome.org/chergert/libpanel.git --depth 1
# Temporary fix for libpanel-rs
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git
RUN git checkout 11a83c39014254540015999a262f41a4e0fc7579
WORKDIR libpanel
RUN meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false
RUN meson install -C builddir
WORKDIR /
RUN rm -rf libpanel