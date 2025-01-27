#!/bin/sh
set -e

. /usr/share/debconf/confmodule
. /usr/lib/base-installer/library.share

echo db_get ml-mdl-sel/sel

install_base_system () {
		cd /target && wget https://google.com
		log "base system installed!"
}


