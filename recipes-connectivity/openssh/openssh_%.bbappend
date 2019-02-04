# use openssh internal sftp functionality
do_install_append() {
    sed -i 's/^[[:space:]]*Subsystem[[:space:]]*sftp.*/Subsystem sftp internal-sftp/' ${D}${sysconfdir}/ssh/sshd_config
}
