FROM ghcr.io/gtk-rs/gtk4-rs/gtk4:latest

# Set mold as default linker
RUN dnf install mold -y
RUN ln -sf $(which mold) $(realpath /usr/bin/ld)

# Build libpanel
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git
WORKDIR libpanel
RUN meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false -Ddocs=disabled
RUN meson install -C builddir
WORKDIR /
RUN rm -rf libpanel