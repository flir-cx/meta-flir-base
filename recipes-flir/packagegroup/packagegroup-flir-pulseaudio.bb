SUMMARY = "Packages for Pulseaudio"
PR = "r12"
LICENSE = "MIT"

inherit packagegroup 

PACKAGES += " \
    ${PN}-packages \
"

RDEPENDS_${PN}-packages = "\
    pulseaudio-server \
    pulseaudio-misc \
    pulseaudio-module-bluetooth-policy \
    pulseaudio-module-switch-on-connect \
    pulseaudio-module-bluetooth-discover \
    pulseaudio-module-bluez5-discover \
    pulseaudio-module-bluez5-device \
"








