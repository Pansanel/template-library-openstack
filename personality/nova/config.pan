template personality/nova/config; 

variable MY_IP ?= DB_IP[escape(FULL_HOSTNAME)];
variable VNCSERVER_LISTEN ?= "0.0.0.0";
variable VNCSERVER_PROXYCLIENT_ADDRESS ?= MY_IP;
variable NOVNCPROXY_BASE_URL ?= 'http://'+OS_NOVA_CONTROLLER_HOST+':6080/vnc_auto.html';
variable XVPVNCPROXY_BASE_URL ?= 'http://'+OS_NOVA_CONTROLLER_HOST+':6081/console';
variable OS_NOVA_TENANT ?= 'service';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?= error('OS_NOVA_PASSWORD required but not specified');

# Neutron related variables
variable NEUTRON_URL ?= 'http://' + OS_NEUTRON_MGMT_HOST + ':9696';
variable OS_NEUTRON_TENANT ?= 'service';
variable OS_NEUTRON_USERNAME ?= 'neutron';
variable OS_NEUTRON_PASSWORD ?= error('OS_NEUTRON_PASSWORD required but not specified');
variable NEUTRON_ADMIN_AUTH_URL ?= KEYSTONE_MGMT_ENDPOINT;

# Nova - Neutron related variables
variable NOVA_FLOATING_IP_POOL ?= 'ext-net';

# Database related variables
variable NOVA_MYSQL_SERVER ?= MYSQL_HOST;
variable OS_NOVA_DB_NAME ?= 'nova';
variable OS_NOVA_DB_USERNAME ?= 'nova';
variable OS_NOVA_DB_PASSWORD ?= error('NOVA_DB_PASSWORD required but not specified');

variable NOVA_SQL_CONNECTION ?= 'mysql://'+OS_NOVA_DB_USERNAME+':'+OS_NOVA_DB_PASSWORD+'@'+NOVA_MYSQL_SERVER+'/'+OS_NOVA_DB_NAME;

# OCCI related variables
variable ENABLED_APIS ?= {
  if (OS_CONFIGURE_VOS) {
    'osapi_compute,metadata,ooi';
  } else {
    'osapi_compute,metadata';
  };
};

variable OCCI_LISTEN_PORT ?= '9000';

#------------------------------------------------------------------------------
# Nova Configuration
#------------------------------------------------------------------------------

variable NOVA_CONFIG ?= '/etc/nova/nova.conf';

variable NOVA_CONFIG_CONTENTS ?= file_contents('personality/nova/templates/nova.templ');

variable NOVA_CONFIG_CONTENTS=replace('MY_IP',MY_IP,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('REGION_NAME',OS_REGION_NAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('VNCSERVER_LISTEN',VNCSERVER_LISTEN,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('VNCSERVER_PROXYCLIENT_ADDRESS',VNCSERVER_PROXYCLIENT_ADDRESS,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('XVPVNCPROXY_BASE_URL',XVPVNCPROXY_BASE_URL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_FLOATING_IP_POOL',NOVA_FLOATING_IP_POOL,NOVA_CONFIG_CONTENTS);

variable NOVA_CONFIG_CONTENTS={
  if (VNCSERVER_LISTEN == "0.0.0.0") {
    replace('VNC_ENABLED','true',NOVA_CONFIG_CONTENTS);
  } else {
    replace('VNC_ENABLED','false',NOVA_CONFIG_CONTENTS);
  };
};
variable NOVA_CONFIG_CONTENTS={
  if (VNCSERVER_LISTEN == "0.0.0.0") {
    replace('#novncproxy_base_url=http://127.0.0.1:6080/vnc_auto.html','novncproxy_base_url='+NOVNCPROXY_BASE_URL,NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};
variable NOVA_CONFIG_CONTENTS=replace('GLANCE_HOST',OS_GLANCE_MGMT_HOST,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('SQL_CONNECTION',NOVA_SQL_CONNECTION,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('KEYSTONE_MGMT_AUTH',KEYSTONE_MGMT_AUTH,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('KEYSTONE_ADMIN_AUTH',KEYSTONE_ADMIN_AUTH,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_TENANT',OS_NOVA_TENANT,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_USERNAME',OS_NOVA_USERNAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NOVA_PASSWORD',OS_NOVA_PASSWORD,NOVA_CONFIG_CONTENTS);

variable NOVA_CONFIG_CONTENTS={
  if (METADATA_PROXY_ENABLED) {
    replace('METADATA_PROXY_ENABLED','true',NOVA_CONFIG_CONTENTS);
  } else {
    replace('METADATA_PROXY_ENABLED','false',NOVA_CONFIG_CONTENTS);
  };
};
variable NOVA_CONFIG_CONTENTS={
  if (METADATA_PROXY_ENABLED) {
    replace('#metadata_proxy_shared_secret=METADATA_PROXY_SHARED_SECRET','metadata_proxy_shared_secret='+METADATA_PROXY_SHARED_SECRET,NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};

# Neutron part
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_URL',NEUTRON_URL,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('REGION_NAME',OS_REGION_NAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_USERNAME',OS_NEUTRON_USERNAME,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_PASSWORD',OS_NEUTRON_PASSWORD,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_TENANT',OS_NEUTRON_TENANT,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS=replace('NEUTRON_ADMIN_AUTH_URL',NEUTRON_ADMIN_AUTH_URL,NOVA_CONFIG_CONTENTS);

# OCCI part
variable NOVA_CONFIG_CONTENTS=replace('ENABLED_APIS',ENABLED_APIS,NOVA_CONFIG_CONTENTS);
variable NOVA_CONFIG_CONTENTS={
  if (OS_CONFIGURE_VOS) {
    replace('#ooi_listen_port=OCCI_LISTEN_PORT','ooi_listen_port='+OCCI_LISTEN_PORT,NOVA_CONFIG_CONTENTS);
  } else {
    NOVA_CONFIG_CONTENTS;
  };
};

"/software/components/filecopy/services" = npush(
    escape(NOVA_CONFIG), nlist(
        "config",NOVA_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-nova restart",
    ),
);


#------------------------------------------------------------------------------
# Nova API configuration
#------------------------------------------------------------------------------

variable NOVA_API ?= '/etc/nova/api-paste.ini';

variable NOVA_API_CONTENTS ?= file_contents('personality/nova/templates/api-paste.templ');

variable OCCI_CONTENTS ?= {
  if (OS_CONFIGURE_VOS) {
    file_contents('personality/nova/templates/occi-paste.templ');
  } else {
  '';
  };
};

variable NOVA_API_CONTENTS=replace('AUTH_URI',KEYSTONE_CONTROLLER_AUTH,NOVA_API_CONTENTS);
variable NOVA_API_CONTENTS=replace('OCCI_CONTENTS',OCCI_CONTENTS,NOVA_API_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NOVA_API), nlist(
        "config",NOVA_API_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-nova restart",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;NOVA_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};

variable NOVA_SERVICE_FILE ?= '/etc/service-nova';
variable NOVA_SERVICE_CONTENTS ?= {
  contents = '';
  foreach(i;service;NOVA_SERVICES) {
      contents = contents + service + "\n";
  };
  contents;
};

"/software/components/filecopy/services" = npush(
    escape(NOVA_SERVICE_FILE), nlist(
        "config",NOVA_SERVICE_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);

variable NOVA_STARTUP_FILE ?= '/etc/init.d/openstack-nova';
variable NOVA_STARTUP_CONTENTS ?= <<EOF;
#!/bin/sh
#
# OpenStack Nova Services
#
# chkconfig:   - 98 02
# description: Nova is the OpenStack cloud computing fabric controller
#
### END INIT INFO

. /etc/rc.d/init.d/functions

SERVICE_LIST=`cat /etc/service-nova`


case "$1" in
    start)
        for s in `echo ${SERVICE_LIST}`; do
            echo "*** `basename ${s}`:"; 
            /usr/sbin/service ${s} start
            echo""
        done
        ;;
    stop)
        for s in `echo ${SERVICE_LIST}`; do
            echo "*** `basename ${s}`:";
            /usr/sbin/service ${s} stop
            echo""
        done
        ;;
    restart)
        for s in `echo ${SERVICE_LIST}`; do
            echo "*** `basename ${s}`:";
            /usr/sbin/service ${s} stop
            echo""
        done
        for s in `echo ${SERVICE_LIST}`; do
            echo "*** `basename ${s}`:"; 
            /usr/sbin/service ${s} start
            echo""
        done
        ;;
    status)
        for s in `echo ${SERVICE_LIST}`; do
            echo "*** `basename ${s}`:";
            /usr/sbin/service ${s} status
            echo""
        done
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart"
        exit 1;; 
esac
exit 0
EOF

"/software/components/filecopy/services" = npush(
    escape(NOVA_STARTUP_FILE), nlist(
        "config",NOVA_STARTUP_CONTENTS,
        "owner","root:root",
        "perms","0755",
    ),
);
