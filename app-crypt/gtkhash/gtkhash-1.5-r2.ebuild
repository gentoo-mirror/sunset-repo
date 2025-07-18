# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A cross-platform desktop utility for computing message digests or checksums"
HOMEPAGE="https://gtkhash.org/"
SRC_URI="https://github.com/tristanheaven/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nettle +openssl mbedtls caja nemo thunar"

DEPEND="dev-libs/libgcrypt
	app-crypt/libb2
	x11-libs/gtk+:3
	sys-libs/zlib
	nettle? ( dev-libs/nettle )
	openssl? ( dev-libs/openssl )
	mbedtls? ( net-libs/mbedtls:0 )
	caja? ( mate-base/caja )
	nemo? ( gnome-extra/nemo )
	thunar? ( xfce-base/thunar )"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}/fix-msgfmt-keyword-use-space.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_use nettle)
		$(meson_use openssl libcrypto)
		$(meson_use mbedtls)
		$(meson_use caja build-caja)
		-Dbuild-nautilus=false # Extension does not work with GTK4 Nautilus
		$(meson_use nemo build-nemo)
		$(meson_use thunar build-thunar)
		-Dlinux-crypto=true # Probably should NOT assume we're running on Linux...
		-Dglib-checksums=true # Indirect dependency of GTK3 so why not
	)
	meson_src_configure
}
