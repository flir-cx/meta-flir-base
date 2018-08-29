FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append = " \
    file://0001-Support-for-FLIR-low-cost-brassboard.patch \  
    file://0002-Add-bootaux-command-to-load-and-start-M4.patch \  
    file://0003-bblc-environment-boot-with-flir-emmc-layout-and-supp.patch \  
"
