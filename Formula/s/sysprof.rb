class Sysprof < Formula
  desc "Statistical, system-wide profiler"
  homepage "https://gitlab.gnome.org/GNOME/sysprof"
  url "https://gitlab.gnome.org/GNOME/sysprof/-/archive/47.0/sysprof-47.0.tar.gz"
  sha256 "9cdad67d8ba3e13b7c40053da424b6f033b22fb7b6cec47a1277b7076e53db87"
  # See Debian's Copyright File. https://metadata.ftp-master.debian.org/changelogs//main/s/sysprof/sysprof_47.0-2_copyright
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.0-or-later",
    "LGPL-3.0-or-later",
    "BSD-2-Clause-Patent",
    "BSD-3-Clause",
    :public_domain,
  ]
  head "https://gitlab.gnome.org/GNOME/sysprof.git", branch: "master"

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk4"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libdex"
  depends_on "libpanel"
  depends_on "libunwind"
  depends_on :linux

  def install
    system "meson", "setup", "build",
                    "-Dgtk=true",
                    "-Dtools=true",
                    "-Dtests=false",
                    "-Dexamples=false",
                    "-Dpolkit-agent=disabled", # requires dependencies not packaged yet
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/app.c", "."
    system "make", "app"
    system "./app"
  end
end
