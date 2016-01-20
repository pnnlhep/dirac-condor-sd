#!/bin/bash -e

# Setup DIRAC SiteDirector for condor
ptables -I INPUT -p tcp --dport 9130:9200 -j ACCEPT
service iptables save
mkdir -p /opt/dirac/etc/grid-security/
ln -s /etc/grid-security/certificates  /opt/dirac/etc/grid-security/certificates
cp /etc/grid-security/hostcert.pem /opt/dirac/etc/grid-security
cp /etc/grid-security/hostkey.pem /opt/dirac/etc/grid-security
chown -R cdms:cdms /opt/dirac

mkdir -p /srv/dirac
cd /srv/dirac
wget -np https://github.com/DIRACGrid/DIRAC/raw/integration/Core/scripts/install_site.sh --no-check-certificate
chmod +x install_site.sh
chown -R cdms:cdms /srv/dirac
sudo -u cdms ./install_site.sh pnnl_dirac.cfg
dirac-install-agent WorkloadManagement SiteDirectorPNNL -ddd

# Setup CONDOR client
. /etc/sysconfig/condor
condor_master -f 

