do_deploy:append() {
	CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
	echo "avoid_warnings=1" >> $CONFIG
}
