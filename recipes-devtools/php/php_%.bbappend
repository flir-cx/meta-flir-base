PACKAGECONFIG_remove = "mysql"

DEPENDS += " libpng libxml2 jpeg libzip"
DEPENDS_class-target += "gd libxml2 libzip"
RDEPENDS_${PN}_class-target += "gd libxml2 libzip"

COMMON_EXTRA_OECONF_append += " --without-pear --disable-phar"
EXTRA_OECONF_append_mx6 = "  --enable-gd --with-jpeg --with-zip"

