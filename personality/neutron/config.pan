template personality/neutron/config;

variable OS_NEUTRON_TENANT ?= 'service';
variable OS_NEUTRON_USERNAME ?= 'neutron';
variable OS_NEUTRON_PASSWORD ?= error('OS_NEUTRON_PASSWORD required but not specified');

# Nova related variables
# Neutron related variables
variable NOVA_URL ?= 'http://' + OS_NOVA_MGMT_HOST + ':8774';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?=error('OS_NOVA_PASSWORD required but not specified');
variable OS_NOVA_TENANT ?= 'service';
variable NOVA_KEYSTONE_AUTH_URL ?= KEYSTONE_MGMT_ENDPOINT;

# Database related variables
variable NEUTRON_MYSQL_SERVER ?= MYSQL_HOST;
variable OS_NEUTRON_DB_NAME ?= 'neutron';
variable OS_NEUTRON_DB_USERNAME ?= 'neutron';
variable OS_NEUTRON_DB_PASSWORD ?= error('OS_NEUTRON_DB_PASSWORD required but not specified');

variable NEUTRON_SQL_CONNECTION ?= 'mysql://'+OS_NEUTRON_DB_USERNAME+':'+OS_NEUTRON_DB_PASSWORD+'@'+NEUTRON_MYSQL_SERVER+'/'+OS_NEUTRON_DB_NAME;

variable NEUTRON_NETWORK_PLUGIN ?= 'ml2';

#----------------------------------------------------------------------------
# Neutron configuration
#----------------------------------------------------------------------------

variable NEUTRON_CONFIG ?= '/etc/neutron/neutron.conf';

variable NEUTRON_CONFIG_CONTENTS ?= file_contents('personality/neutron/templates/neutron.templ');

variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('SQL_CONNECTION',NEUTRON_SQL_CONNECTION,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_HOST',OS_KEYSTONE_MGMT_HOST,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_CONTROLLER_PROTOCOL',OS_KEYSTONE_CONTROLLER_PROTOCOL,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_MGMT_AUTH',KEYSTONE_MGMT_AUTH,NEUTRON_CONFIG_CONTENTS); 
variable NEUTRON_CONFIG_CONTENTS=replace('KEYSTONE_ADMIN_AUTH',KEYSTONE_ADMIN_AUTH,NEUTRON_CONFIG_CONTENTS); 
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_TENANT',OS_NEUTRON_TENANT,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_USERNAME',OS_NEUTRON_USERNAME,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NEUTRON_PASSWORD',OS_NEUTRON_PASSWORD,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_URL',NOVA_URL,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_USERNAME',OS_NOVA_USERNAME,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_PASSWORD',OS_NOVA_PASSWORD,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_TENANT',OS_NOVA_TENANT,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('NOVA_ADMIN_AUTH_URL',NOVA_KEYSTONE_AUTH_URL,NEUTRON_CONFIG_CONTENTS);
variable NEUTRON_CONFIG_CONTENTS=replace('REGION_NAME',OS_REGION_NAME,NEUTRON_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NEUTRON_CONFIG), nlist(
        "config",NEUTRON_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-neutron restart",
    ),
);

#----------------------------------------------------------------------------
# Network plugin
#----------------------------------------------------------------------------

include { 'personality/neutron/plugins/' + NEUTRON_NETWORK_PLUGIN + '/config' };

# Link default plugin to plugin.ini file
include { 'components/symlink/config' };
variable NEUTRON_PLUGIN_TARGET ?= {
  if (NEUTRON_NETWORK_PLUGIN == 'ml2') {
    target = '/etc/neutron/plugins/ml2/ml2_conf.ini';
  } else if (NEUTRON_NETWORK_PLUGIN == 'openvswitch') {
    target = '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini';
  };

  target;
};
'/software/components/symlink/links'=push(
  nlist('name', '/etc/neutron/plugin.ini',
        'replace', nlist('all','yes','link','yes'),
        'target', NEUTRON_PLUGIN_TARGET,
  ),
);

#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;NEUTRON_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};

variable NEUTRON_SERVICE_FILE ?= '/etc/service-neutron';
variable NEUTRON_SERVICE_CONTENTS ?= {
  contents = '';
  foreach(i;service;NEUTRON_SERVICES) {
      contents = contents + service + "\n";
  };
  contents;
};

"/software/components/filecopy/services" = npush(
    escape(NEUTRON_SERVICE_FILE), nlist(
        "config",NEUTRON_SERVICE_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);

variable NEUTRON_STARTUP_FILE ?= '/etc/init.d/openstack-neutron';
variable NEUTRON_STARTUP_CONTENTS ?= <<EOF;
#!/bin/sh
#
# OpenStack Neutron Services
#
# chkconfig:   - 98 02
# description: Neutron is the OpenStack network service
#
### END INIT INFO

. /etc/rc.d/init.d/functions

SERVICE_LIST=`cat /etc/service-neutron`


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
    escape(NEUTRON_STARTUP_FILE), nlist(
        "config",NEUTRON_STARTUP_CONTENTS,
        "owner","root:root",
        "perms","0755",
    ),
);
