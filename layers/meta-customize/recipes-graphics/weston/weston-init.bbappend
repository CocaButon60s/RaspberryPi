FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://myweston.ini file://weston.ini.org"

do_install:append() {
	# 差があればエラーになる
	diff -u ${S}/weston.ini.org ${S}/weston.ini
	install -D -m0644 ${S}/myweston.ini ${D}/${sysconfdir}/xdg/weston/weston.ini
}
