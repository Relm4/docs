FROM ghcr.io/gtk-rs/gtk4-rs/gtk4:latest

# Try to disable SELinux
RUN setenforce 0

# Set mold as default linker
RUN dnf install mold -y
RUN ln -sf $(which mold) $(realpath /usr/bin/ld)

# Build libpanel
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git && \
    cd libpanel && \
    meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false -Ddocs=disabled && \
    meson install -C builddir && \
    cd ../ && \
    rm -rf libpanel