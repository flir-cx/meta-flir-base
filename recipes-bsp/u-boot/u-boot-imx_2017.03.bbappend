FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0000-MLK-17200-1-mx7ulp-Add-CPU-revision-check-for-B0.patch \
    file://0001-MLK-17200-2-mx7ulp-Remove-SNVS-LP-settings-for-B0.patch \
    file://0002-MLK-17200-3-mx7ulp-Select-the-SCG1-APLL-PFD-as-a-sys.patch \
    file://0003-MLK-17292-mx7ulp-Set-A7-core-frequency-to-500Mhz-for.patch \
    file://0004-MLK-17439-mx7ulp-Change-clock-rate-calculation-for-N.patch \
    file://0001-Added-bootaux-to-imx7ulp_evk.patch \
"
