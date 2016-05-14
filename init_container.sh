#!/bin/bash -x

FILE="/code/tt-rss/config.php"
TEMPLATE="${FILE}.tmpl"

rm -f ${FILE}
cp ${TEMPLATE} ${FILE}

sed -i "s|%DB_TYPE%|${DB_TYPE}|g" ${FILE}
sed -i "s|%DB_HOST%|${DB_HOST}|g" ${FILE}
sed -i "s|%DB_USER%|${DB_USER}|g" ${FILE}
sed -i "s|%DB_NAME%|${DB_NAME}|g" ${FILE}
sed -i "s|%DB_PASS%|${DB_PASS}|g" ${FILE}
sed -i "s|%DB_PORT%|${DB_PORT}|g" ${FILE}
sed -i "s|%URL_PATH%|${URL_PATH}|g" ${FILE}
sed -i "s|%ALLOW_REGISTRATION%|${ALLOW_REGISTRATION}|g" ${FILE}
sed -i "s|%NEW_USER_EMAIL%|${NEW_USER_EMAIL}|g" ${FILE}
sed -i "s|%PLUGIN_LIST%|${PLUGIN_LIST}|g" ${FILE}

if [ "${DB_TYPE}" == "mysql" ]; then
    mysql -h ${DB_HOST} -u ${DB_USER} --password=${DB_PASS} ${DB_NAME} -e "SELECT * FROM ttrss_version" >> /dev/null 2>&1
    if [ $? == 0 ]; then
        sudo -u www-data /usr/local/bin/php /code/tt-rss/update.php --update-schema
    else
        mysql -h ${DB_HOST} -u ${DB_USER} --password=${DB_PASS} ${DB_NAME} < /code/tt-rss/schema/ttrss_schema_mysql.sql
    fi
fi

/etc/init.d/supervisor start

php-fpm
