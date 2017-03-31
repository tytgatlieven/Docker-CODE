#!/bin/sh

# Fix lool resolv.conf problem (wizdude)
rm /opt/lool/systemplate/etc/resolv.conf
ln -s /etc/resolv.conf /opt/lool/systemplate/etc/resolv.conf

if [ ${SSL} = true ]; then
	# Generate new SSL certificate instead of using the default
	mkdir -p /opt/ssl/
	cd /opt/ssl/
	mkdir -p certs/ca
	openssl genrsa -out certs/ca/root.key.pem 2048
	openssl req -x509 -new -nodes -key certs/ca/root.key.pem -days 9131 -out certs/ca/root.crt.pem -subj "/C=${SSL_C}/ST=${SSL_ST}/L=${SSL_L}/O=Dummy Authority/CN=Dummy Authority"
	mkdir -p certs/{servers,tmp}
	mkdir -p "certs/servers/${SSL_CN}"
	openssl genrsa -out "certs/servers/${SSL_CN}/privkey.pem" 2048 -key "certs/servers/${SSL_CN}/privkey.pem"
	openssl req -key "certs/servers/${SSL_CN}/privkey.pem" -new -sha256 -out "certs/tmp/${SSL_CN}.csr.pem" -subj "/C=${SSL_C}/ST=${SSL_ST}/L=${SSL_L}/O=Dummy Authority/CN=${SSL_CN}"
	openssl x509 -req -in certs/tmp/${SSL_CN}.csr.pem -CA certs/ca/root.crt.pem -CAkey certs/ca/root.key.pem -CAcreateserial -out certs/servers/${SSL_CN}/cert.pem -days 9131
	mv certs/servers/${SSL_CN}/privkey.pem /etc/loolwsd/key.pem
	mv certs/servers/${SSL_CN}/cert.pem /etc/loolwsd/cert.pem
	mv certs/ca/root.crt.pem /etc/loolwsd/ca-chain.cert.pem
else
	perl -pi -e "s/true<\/enable>/false<\/enable>/g" /etc/loolwsd/loolwsd.xml
	perl -pi -e "s/true<\/termination>/false<\/termination>/g" /etc/loolwsd/loolwsd.xml
	perl -pi -e "s/\/etc\/loolwsd\/cert.pem<\/cert_file_path>/<\/cert_file_path>/g" /etc/loolwsd/loolwsd.xml
	perl -pi -e "s/\/etc\/loolwsd\/key.pem<\/key_file_path>/<\/key_file_path>/g" /etc/loolwsd/loolwsd.xml
	perl -pi -e "s/\/etc\/loolwsd\/ca-chain.cert.pem<\/ca_file_path>/<\/ca_file_path>/g" /etc/loolwsd/loolwsd.xml
fi

# replace log level, threads, max file size and respawn childs
perl -pi -e "s/1<\/num_prespawn_children>/${NUM_PRESPAWN_CHILDREN}<\/num_prespawn_children>/g" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/4<\/max_concurrency>/${MAX_CONCURRENCY}<\/max_concurrency>/g" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/warning<\/level>/${LOG_LEVEL}<\/level>/g" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/0<\/max_file_size>/${MAX_FILE_SIZE}<\/max_file_size>/g" /etc/loolwsd/loolwsd.xml

# Replace trusted host and set admin username and password
perl -pi -e "s/localhost<\/host>/${HOSTS_ALLOWED}<\/host>/g" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<username desc=\"The username of the admin console. Must be set.\"><\/username>/<username desc=\"The username of the admin console. Must be set.\">${USERNAME}<\/username>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<password desc=\"The password of the admin console. Must be set.\"><\/password>/<password desc=\"The password of the admin console. Must be set.\">${PASSWORD}<\/password>/g" /etc/loolwsd/loolwsd.xml

# Start loolwsd
su -c "/usr/bin/loolwsd --version --o:sys_template_path=/opt/lool/systemplate --o:lo_template_path=/opt/collaboraoffice5.1 --o:child_root_path=/opt/lool/child-roots --o:file_server_root_path=/usr/share/loolwsd" -s /bin/bash lool
