unique template personality/cinder/config;

variable CINDER_SERVER_SERVICES ?= list();
variable CINDER_VOLUME_SERVICES ?= list();
variable CINDER_SERVICES = merge(CINDER_SERVER_SERVICES,CINDER_VOLUME_SERVICES);

variable OS_CINDER_TENANT ?= 'service';
variable OS_CINDER_USERNAME ?= 'cinder';
variable OS_CINDER_PASSWORD ?=  error('OS_CINDER_PASSWORD required but not specified');

variable CINDER_SQL_CONNECTION ?= 'mysql://'+OS_CINDER_DB_USERNAME+':'+OS_CINDER_DB_PASSWORD+'@'+CINDER_MYSQL_SERVER+'/'+OS_CINDER_DB_NAME;


#------------------------------------------------------------------------------
# Cinder configuration
#------------------------------------------------------------------------------

variable CINDER_CONFIG ?= '/etc/cinder/cinder.conf';

variable CINDER_CONFIG_CONTENTS ?= file_contents('personality/cinder/templates/cinder.templ');

variable CINDER_CONFIG_CONTENTS=replace('HOST_IP',DB_IP[escape(FULL_HOSTNAME)],CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('GLANCE_HOST',OS_GLANCE_MGMT_HOST,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('SQL_CONNECTION',CINDER_SQL_CONNECTION,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('KEYSTONE_MGMT_AUTH',KEYSTONE_MGMT_AUTH,CINDER_CONFIG_CONTENTS); 
variable CINDER_CONFIG_CONTENTS=replace('KEYSTONE_ADMIN_AUTH',KEYSTONE_ADMIN_AUTH,CINDER_CONFIG_CONTENTS); 
variable CINDER_CONFIG_CONTENTS=replace('CINDER_TENANT',OS_CINDER_TENANT,CINDER_CONFIG_CONTENTS); 
variable CINDER_CONFIG_CONTENTS=replace('CINDER_USERNAME',OS_CINDER_USERNAME,CINDER_CONFIG_CONTENTS);
variable CINDER_CONFIG_CONTENTS=replace('CINDER_PASSWORD',OS_CINDER_PASSWORD,CINDER_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(CINDER_CONFIG), nlist(
        "config",CINDER_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-cinder restart",
    ),
);


#------------------------------------------------------------------------------
# Cinder API configuration
#------------------------------------------------------------------------------

variable CINDER_API ?= '/etc/cinder/api-paste.ini';

variable CINDER_API_CONTENTS ?= file_contents('personality/cinder/templates/api-paste.templ');

variable CINDER_API_CONTENTS=replace('KEYSTONE_HOST',OS_KEYSTONE_MGMT_HOST,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('KEYSTONE_CONTROLLER_PROTOCOL',OS_KEYSTONE_CONTROLLER_PROTOCOL,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_MGMT_ENDPOINT,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_TENANT',OS_CINDER_TENANT,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_USERNAME',OS_CINDER_USERNAME,CINDER_API_CONTENTS);
variable CINDER_API_CONTENTS=replace('CINDER_PASSWORD',OS_CINDER_PASSWORD,CINDER_API_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(CINDER_API), nlist(
        "config",CINDER_API_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-cinder restart",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;CINDER_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};

variable CINDER_SERVICE_FILE ?= '/etc/service-cinder';
variable CINDER_SERVICE_CONTENTS ?= {
  contents = '';
  foreach(i;service;CINDER_SERVICES) {
      contents = contents + service + "\n";
  };
  contents;
};

"/software/components/filecopy/services" = npush(
    escape(CINDER_SERVICE_FILE), nlist(
        "config",CINDER_SERVICE_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);

variable CINDER_STARTUP_FILE ?= '/etc/init.d/openstack-cinder';
variable CINDER_STARTUP_CONTENTS ?= <<EOF;
#!/bin/sh
#
# OpenStack Cinder Services
#
# chkconfig:   - 98 02
# description: Cinder is the OpenStack block storage service
#
### END INIT INFO

. /etc/rc.d/init.d/functions

SERVICE_LIST=`cat /etc/service-cinder`


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
    escape(CINDER_STARTUP_FILE), nlist(
        "config",CINDER_STARTUP_CONTENTS,
        "owner","root:root",
        "perms","0755",
    ),
);
