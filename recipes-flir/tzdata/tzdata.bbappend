PV = "2024b"

SRC_URI[tzdata.sha256sum] = "70e754db126a8d0db3d16d6b4cb5f7ec1e04d5f261255e4558a67fe92d39e550"
SRC_URI[tzcode.sha256sum] = "5e438fc449624906af16a18ff4573739f0cda9862e5ec28d3bcb19cbaed0f672"

FILES_tzdata-core +=" \
                ${FILES:tzdata-africa}               \
                ${FILES:tzdata-americas}             \
                ${FILES:tzdata-antarctica}           \
                ${FILES:tzdata-arctic}               \
                ${FILES:tzdata-asia}                 \
                ${FILES:tzdata-atlantic}             \
                ${FILES:tzdata-australia}            \
                ${FILES:tzdata-europe}               \
                ${FILES:tzdata-pacific}              \
                ${FILES:tzdata-misc}                 \
                "

