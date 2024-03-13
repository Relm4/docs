FROM ghcr.io/gtk-rs/gtk4-rs/gtk4:latest

# Set mold as default linker (temporarily disabled)
# RUN dnf install mold -y
# RUN ln -sf $(which mold) $(realpath /usr/bin/ld)

# Build libadwaita
RUN git clone https://gitlab.gnome.org/GNOME/libadwaita.git --depth=1 && \
    (cd /libadwaita && \
        meson setup builddir --prefix=/usr --buildtype release -Dintrospection=disabled -Dvapi=false -Dexamples=false -Dtests=false && \
        meson install -C builddir) && \
    rm -rf /gtk /libadwaita

# Build libpanel
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git && \
    (cd libpanel && \
     meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false -Ddocs=disabled && \
     meson install -C builddir) && \
    cd ../ && \
    rm -rf libpanel

RUN dnf install openssl-devel -y

# Temporary workaround: Install libpanel with dnf
# RUN dnf install libpanel-devel -y
