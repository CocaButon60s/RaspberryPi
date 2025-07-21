do_install:append() {
	install -D -p -m0644 ${S}/weston.ini ${D}${sysconfdir}/xdg/weston/weston.ini
}
