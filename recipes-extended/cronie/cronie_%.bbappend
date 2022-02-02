inherit update-alternatives
ALTERNATIVE_${PN} = "crond cronnext crontab"
ALTERNATIVE_LINK_NAME[crond] = "${sbindir}/crond"
ALTERNATIVE_LINK_NAME[cronnext] = "${bindir}/cronnext"
ALTERNATIVE_LINK_NAME[crontab] = "${bindir}/crontab"
ALTERNATIVE_PRIORITY = "100"
