QT_CONFIG_FLAGS_APPEND_imxgpu3d = "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '-no-eglfs', \
        bb.utils.contains('DISTRO_FEATURES', 'wayland', '-eglfs', \
            '-eglfs', d), d)}"

OE_QMAKE_CXXFLAGS += "-fpermissive"

PACKAGECONFIG_append_pn-qtbase = " xkbcommon"
