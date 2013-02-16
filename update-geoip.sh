#!/bin/sh
# (C) Ludovico Cavedon <cavedon@debian.org>

GEOIP_URL="http://geolite.maxmind.com/download/geoip/database/"

GEOLITE_COUNTRY_PATH="GeoLiteCountry/"
GEOLITE_COUNTRY_FILE="GeoIP.dat.gz"

GEOLITE_COUNTRY_IPV6_PATH=""
GEOLITE_COUNTRY_IPV6_FILE="GeoIPv6.dat.gz"

GEOLITE_CITY_PATH=""
GEOLITE_CITY_FILE="GeoLiteCity.dat.gz"

GEOLITE_CITY_IPV6_PATH="GeoLiteCityv6-beta/"
GEOLITE_CITY_IPV6_FILE="GeoLiteCityv6.dat.gz"

GEOLITE_ASNUM_PATH="asnum/"
GEOLITE_ASNUM_FILE="GeoIPASNum.dat.gz"

FAILED=0

for url in \
    "$GEOIP_URL$GEOLITE_COUNTRY_PATH$GEOLITE_COUNTRY_FILE" \
    "$GEOIP_URL$GEOLITE_COUNTRY_IPV6_PATH$GEOLITE_COUNTRY_IPV6_FILE" \
    "$GEOIP_URL$GEOLITE_CITY_PATH$GEOLITE_CITY_FILE" \
    "$GEOIP_URL$GEOLITE_CITY_IPV6_PATH$GEOLITE_CITY_IPV6_FILE" \
    "$GEOIP_URL$GEOLITE_ASNUM_PATH$GEOLITE_ASNUM_FILE"
do
    echo "Downloading $url"

    FILE=$(basename $url)

    rm -f /usr/share/GeoIP/$FILE
    /usr/bin/wget -t3 -T15 -P /usr/share/GeoIP/ "$url" && \
        /bin/gunzip -f /usr/share/GeoIP/$FILE
    if [ "$?" != "0" ]
    then
        FAILED=1
        echo "Failed to download and decompress $FILE"
    fi
done

ln -fs /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
ln -fs /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat
ln -fs /usr/share/GeoIP/ /usr/local/share/

ln -fs /usr/share/GeoIP/GeoIP.dat /etc/netsniff-ng/country4.dat
ln -fs /usr/share/GeoIP/GeoIPv6.dat /etc/netsniff-ng/country6.dat

ln -fs /usr/share/GeoIP/GeoIPCity.dat /etc/netsniff-ng/city4.dat
ln -fs /usr/share/GeoIP/GeoIPCityv6.dat /etc/netsniff-ng/city6.dat

exit $FAILED
