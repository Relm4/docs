FROM fedora:latest

RUN dnf update -y
RUN dnf install git xorg-x11-server-Xvfb procps-ng wget libjpeg-turbo-devel expat-devel 'dnf-command(builddep)' -y
RUN dnf builddep gtk4 -y

# Build GTK4
RUN git clone https://gitlab.gnome.org/GNOME/gtk.git --depth=1
WORKDIR gtk
RUN meson setup builddir --prefix=/usr -Dgtk_doc=false -Dintrospection=disabled -Dbuild-examples=false -Dbuild-tests=false -Ddemos=false
RUN meson install -C builddir
WORKDIR /
RUN rm -rf gtk

# Build Libadwaita
RUN git clone https://gitlab.gnome.org/GNOME/libadwaita.git --depth=1
WORKDIR libadwaita
RUN meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false -Dexamples=false -Dtests=false
RUN meson install -C builddir
WORKDIR /
RUN rm -rf libadwaita

# Build Libpanel
RUN git clone https://gitlab.gnome.org/chergert/libpanel.git --depth 1
WORKDIR libpanel
RUN meson setup builddir --prefix=/usr -Dintrospection=disabled -Dvapi=false
RUN meson install -C builddir
WORKDIR /
RUN rm -rf libpanel