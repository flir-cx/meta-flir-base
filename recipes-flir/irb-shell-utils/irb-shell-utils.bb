# Copyright (C) 2023 Runi Eriksen <runi.eriksen@flir.com>
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "IRB shell utils"
DESCRIPTION = "IRB shell utilites which ease the use of the IRB shell interface."
AUTHOR = "Runi Eriksen <runi.eriksen@flir.com>"
LICENSE = "CLOSED"

PR = "r1"
PV = "1"

RDEPENDS:${PN} += "picocom"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://irb-shell.sh \
"

do_install:append() {
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/irb-shell.sh ${D}/usr/bin/irb-shell
}
