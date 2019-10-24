set_root_passwd() {
		  sed 's%^root:[^:]*:%root:${FLIR_ROOT_PASSWORD}:%' \
		  < ${IMAGE_ROOTFS}/etc/shadow \
		  > ${IMAGE_ROOTFS}/etc/shadow.new;\
		  mv ${IMAGE_ROOTFS}/etc/shadow.new ${IMAGE_ROOTFS}/etc/shadow ;
		  chmod 640 ${IMAGE_ROOTFS}/etc/shadow
}

cleanup_rootfs() {
   rm -rf ${IMAGE_ROOTFS}/usr/include
   rm -rf ${IMAGE_ROOTFS}/opt
}


flir_rev_update() {
   REPODIR=$(cd "${FILE_DIRNAME}/../../../../.repo"; pwd); \
   BLD_VERSION=`git -C ${REPODIR}/manifests describe --dirty --long --always`;\
   if echo ${BLD_VERSION} | grep -vq "dirty"
   then
      FLIR1DIR="${REPODIR}/../sources/meta-flir-base"; \
      FLIR2DIR="${REPODIR}/../sources/meta-flir-internal"; \
      if ! ( git -C "${FLIR1DIR}" diff --quiet ) || \
         ( [ -d "${FLIR2DIR}" ] && ! ( git -C "${FLIR2DIR}" diff --quiet) )
      then
          BLD_VERSION=${BLD_VERSION}-dirty
      fi
   fi
   BLDHOST=`/bin/hostname`;\
   date +%Y%m%d%H%M > ${IMAGE_ROOTFS}/etc/build; \
   echo "${MACHINE}" > ${IMAGE_ROOTFS}/etc/platform; \
   FLIR_VERSION=${BLD_VERSION}; \
   echo "${FLIR_VERSION}" >${IMAGE_ROOTFS}/etc/version ;\
   echo "${FLIR_VERSION}" >${DEPLOY_DIR_IMAGE}/rootfs.version ;\
   sed -i 's/IMAGENAME/${IMAGE_NAME}/g' ${IMAGE_ROOTFS}/etc/os-release ;\
   sed -i s/IVERSION/${BLD_VERSION}/g ${IMAGE_ROOTFS}/etc/os-release ;\
   sed -i 's/BLDUSER/${USER}/g' ${IMAGE_ROOTFS}/etc/os-release ;\
   sed -i s/BLDHOST/${BLDHOST}/g ${IMAGE_ROOTFS}/etc/os-release ;\
   cp -p ${REPODIR}/manifest.xml ${IMAGE_ROOTFS}/etc/flir-os-manifest.xml; \
}

link_licenses_info() {
# Create the symlink for _licenses.tgz
  if [ -n "${IMAGE_LINK_NAME}" ] && [ -e ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}_licenses.tgz ]; then
     ln -sf  ${IMAGE_NAME}_licenses.tgz ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}_licenses.tgz
  fi  
}

create_licenses_info() {
  # Create dir
  common_lic_path=${IMAGE_ROOTFS}/usr/share/common-licenses
  mkdir -p ${common_lic_path}
  # check if old file exists
  lic="${common_lic_path}/licenses.html"
  if [ -e "$lic" ]; then
    rm "$lic"
  fi
  # Create new licenses file
  #awk -v ADD_HREF=${COPY_LIC_DIRS} '
  awk -v ADD_HREF=0 '
  BEGIN {
    # Init field separator and global variable(s)
    FS=": " 
    pkg=0; 
    print "<h3> A complete list of common licenses can be found <a href=\"http://support.flir.com/resources/licenses/\"> here </a> </h3>"
    print "<p>http://support.flir.com/resources/licenses/<p>"
  }
  {
    # print package name and version
    #print "src path", FILENAME;
    if ( $1 == "PACKAGE NAME" ) { pkg = $2; printf("<h4> %s ", pkg); }
    else if ( $1 == "PACKAGE VERSION" ) { print $2, "</h4>" }
    # print all the licenses and create links to license text
    else if ( $1 == "LICENSE" ) {
      n=split($2,array," ");
      for (i=1;i<=n;i++) {
        if ( array[i] == "CLOSED" ) {
          print "<a>",array[i], "</a><br>";
        }
        #else if ( array[i] == "Proprietary" ) {
        #  printf( "<a href=\"/usr/share/common-licenses/%s/%s\" > %s </a><br>",pkg, array[i], array[i]);
        #}
        else {
          # remove any '+' and append generic_
          lic_file=array[i];
	  l=split(array[i],chunks,"+");
          if (l > 0)
            lic_file=chunks[1];
	  if (ADD_HREF==1)
             printf( "<a href=\"/usr/share/common-licenses/%s/generic_%s\" > %s </a><br>",pkg, lic_file, array[i]);
          else
             print "<a>",array[i], "</a><br>";
        }
      }
    }
  }' \
  ${DEPLOY_DIR}/licenses/${IMAGE_NAME}/license.manifest > $lic
  #
  # Create a index.html file which will be use in a licenses tgz package. The package should be deployed on FLIR support site
  #  
  index="${common_lic_path}/index.html"
  if [ -e "$index" ]; then
    rm "$index"
  fi
  tmp_dir="${IMAGE_ROOTFS}/usr/share"
  # Create new licenses file
  awk -v ADD_HREF=1 '
  BEGIN {
    # Init field separator and global variable(s)
    FS=": " 
    pkg=0; 
    # Add html header
    print "<!DOCTYPE html>"
    print "<html>"
    print "<head>"
    print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
    print "<title>Common licenses used in FLIR Ex5/T5xx rootfs</title>"
    print "</head>"
    print "<body>"
  }
  {
    # print package name and version
    if ( $1 == "PACKAGE NAME" ) { pkg = $2; printf("<h4> %s ", pkg); }
    else if ( $1 == "PACKAGE VERSION" ) { print $2, "</h4>" }
    # print all the licenses and create links to license text
    else if ( $1 == "LICENSE" ) {
      n=split($2,array," ");
      for (i=1;i<=n;i++) {
        if ( array[i] == "CLOSED" ) {
          print "<a>",array[i], "</a><br>";
        }
        #else if ( array[i] == "Proprietary" ) {
        #  printf( "<a href=\"%s\" > %s </a><br>", array[i], array[i]);
        #}
        else {
          # remove any '+' and append generic_
          lic_file=array[i];
	  l=split(array[i],chunks,"+");
          if (l > 0)
            lic_file=chunks[1];
	  if (ADD_HREF==1)
             printf( "<a href=\"generic_%s\" > %s </a><br>",lic_file, array[i]);
          else
             print "<a>",array[i], "</a><br>";
        }
      }
    }
  }
  END {
      # Add html footer
      print "</body>"
      print "</html>"
  }' \
  ${DEPLOY_DIR}/licenses/${IMAGE_NAME}/license.manifest > $index
  # now create a zip of the license information
  zip_file="${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}_licenses.tgz"
  if [ -e "$zip_file" ]; then
    rm "$zip_file"
  fi
  yocto_pwd=${PWD}
  cd "${common_lic_path}"
  tar -zcvf "$zip_file" "."
  cd "${yocto_pwd}"
  # remove the license information but leave manifest and licenses.html
  mv "${common_lic_path}/license.manifest" "${tmp_dir}/license.manifest"
  mv "${common_lic_path}/licenses.html" "${tmp_dir}/licenses.html"
  rm -r "${common_lic_path}"
  mkdir "${common_lic_path}"
  mv "${tmp_dir}/license.manifest" "${common_lic_path}/license.manifest"  
  mv "${tmp_dir}/licenses.html" "${common_lic_path}/licenses.html"
}
