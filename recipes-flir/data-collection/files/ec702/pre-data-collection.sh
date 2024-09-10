#!/bin/sh

mkdir -p /FLIR/internal/data-collection
sed -ri 's/(.*storage_path":\s+").*(",?)/\1\/FLIR\/internal\/data-collection\2/g' /FLIR/usr/etc/data-collection.conf
