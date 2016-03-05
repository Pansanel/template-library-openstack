unique template personality/glance/config;

# User running Glance daemons (normally created by RPMs)

variable GLANCE_EMAIL ?= SITE_EMAIL;
variable OS_GLANCE_TENANT ?= 'service';
variable OS_GLANCE_DB_NAME ?= 'glance';
variable OS_GLANCE_USERNAME ?= 'glance';
variable OS_GLANCE_PASSWORD ?= error('OS_GLANCE_PASSWORD required but not specified');
variable GLANCE_SERVICES ?= list('openstack-glance-api','openstack-glance-registry');

# Database related variables
variable GLANCE_MYSQL_ADMINUSER ?= 'root';
variable GLANCE_MYSQL_ADMINPWD ?= error('GLANCE_MYSQL_ADMINPWD required but not specified');
variable OS_GLANCE_DB_NAME ?= 'glance';
variable OS_GLANCE_DB_USERNAME ?= 'glance';
variable OS_GLANCE_DB_PASSWORD ?= error('OS_GLANCE_DB_PASSWORD required but not specified');

variable GLANCE_SQL_CONNECTION ?= 'mysql://'+OS_GLANCE_DB_USERNAME+':'+OS_GLANCE_DB_PASSWORD+'@'+GLANCE_MYSQL_SERVER+'/'+OS_GLANCE_DB_NAME;


#------------------------------------------------------------------------------
# Glance configuration
#------------------------------------------------------------------------------

variable GLANCE_API_CONFIG ?= '/etc/glance/glance-api.conf';

variable GLANCE_API_CONFIG_CONTENTS ?= file_contents('personality/glance/templates/glance-api.templ');

variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('SQL_CONNECTION',GLANCE_SQL_CONNECTION,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('KEYSTONE_MGMT_AUTH',KEYSTONE_MGMT_AUTH,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('KEYSTONE_ADMIN_AUTH',KEYSTONE_ADMIN_AUTH,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_TENANT',OS_GLANCE_TENANT,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_USERNAME',OS_GLANCE_USERNAME,GLANCE_API_CONFIG_CONTENTS);
variable GLANCE_API_CONFIG_CONTENTS=replace('GLANCE_PASSWORD',OS_GLANCE_PASSWORD,GLANCE_API_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_API_CONFIG), nlist(
        "config",GLANCE_API_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-api restart",
    ),
);

variable GLANCE_REGISTRY_CONFIG ?= '/etc/glance/glance-registry.conf';

variable GLANCE_REGISTRY_CONFIG_CONTENTS ?= file_contents('personality/glance/templates/glance-registry.templ');

variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('RABBIT_HOST',RABBIT_HOST,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('RABBIT_USER',RABBIT_USER,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('RABBIT_PASSWORD',RABBIT_PASSWORD,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('SQL_CONNECTION',GLANCE_SQL_CONNECTION,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('KEYSTONE_MGMT_AUTH',KEYSTONE_MGMT_AUTH,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('KEYSTONE_ADMIN_AUTH',KEYSTONE_ADMIN_AUTH,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_TENANT',OS_GLANCE_TENANT,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_USERNAME',OS_GLANCE_USERNAME,GLANCE_REGISTRY_CONFIG_CONTENTS);
variable GLANCE_REGISTRY_CONFIG_CONTENTS=replace('GLANCE_PASSWORD',OS_GLANCE_PASSWORD,GLANCE_REGISTRY_CONFIG_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_REGISTRY_CONFIG), nlist(
        "config",GLANCE_REGISTRY_CONFIG_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-registry restart",
    ),
);


#------------------------------------------------------------------------------
# Glance Paste configuration
#------------------------------------------------------------------------------

variable GLANCE_API_PASTE ?= '/etc/glance/glance-api-paste.ini';

variable GLANCE_API_PASTE_CONTENTS ?= file_contents('personality/glance/templates/glance-api-paste.templ');

variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_HOST',OS_KEYSTONE_MGMT_HOST,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_CONTROLLER_PROTOCOL',OS_KEYSTONE_CONTROLLER_PROTOCOL,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_MGMT_ENDPOINT,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_TENANT',OS_GLANCE_TENANT,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_USERNAME',OS_GLANCE_USERNAME,GLANCE_API_PASTE_CONTENTS);
variable GLANCE_API_PASTE_CONTENTS=replace('GLANCE_PASSWORD',OS_GLANCE_PASSWORD,GLANCE_API_PASTE_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_API_PASTE), nlist(
        "config",GLANCE_API_PASTE_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-api restart",
    ),
);

variable GLANCE_REGISTRY_PASTE ?= '/etc/glance/glance-registry-paste.ini';

variable GLANCE_REGISTRY_PASTE_CONTENTS ?= file_contents('personality/glance/templates/glance-registry-paste.templ');

variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_HOST',OS_KEYSTONE_MGMT_HOST,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_CONTROLLER_PROTOCOL',OS_KEYSTONE_CONTROLLER_PROTOCOL,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('KEYSTONE_URI',KEYSTONE_MGMT_ENDPOINT,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_TENANT',OS_GLANCE_TENANT,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_USERNAME',OS_GLANCE_USERNAME,GLANCE_REGISTRY_PASTE_CONTENTS);
variable GLANCE_REGISTRY_PASTE_CONTENTS=replace('GLANCE_PASSWORD',OS_GLANCE_PASSWORD,GLANCE_REGISTRY_PASTE_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_REGISTRY_PASTE), nlist(
        "config",GLANCE_REGISTRY_PASTE_CONTENTS,
        "owner","root",
        "perms","0644",
        "restart", "/sbin/service openstack-glance-registry restart",
    ),
);


#------------------------------------------------------------------------------
# Mariadb configuration
#------------------------------------------------------------------------------

include 'features/mariadb/config';

'/software/components/mysql/servers/' = {
    SELF[GLANCE_MYSQL_SERVER]['adminuser'] = GLANCE_MYSQL_ADMINUSER;
    SELF[GLANCE_MYSQL_SERVER]['adminpwd'] = GLANCE_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[OS_GLANCE_DB_NAME]['createDb'] = true;
    SELF[OS_GLANCE_DB_NAME]['server'] = GLANCE_MYSQL_SERVER;
    SELF[OS_GLANCE_DB_NAME]['users'][OS_GLANCE_DB_USERNAME] = nlist(
        'password', OS_GLANCE_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};


#------------------------------------------------------------------------------
# Endpoint configuration script
#------------------------------------------------------------------------------

variable GLANCE_ENDPOINTS ?= '/root/sbin/create-glance-endpoints.sh';
variable GLANCE_ENDPOINTS_CONTENTS ?= file_contents('personality/glance/templates/create-glance-endpoints.templ');

variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_PASSWORD',OS_GLANCE_PASSWORD,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_EMAIL',GLANCE_EMAIL,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_CONTROLLER_HOST',OS_GLANCE_CONTROLLER_HOST,GLANCE_ENDPOINTS_CONTENTS);
variable GLANCE_ENDPOINTS_CONTENTS = replace('GLANCE_MGMT_HOST',OS_GLANCE_MGMT_HOST,GLANCE_ENDPOINTS_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(GLANCE_ENDPOINTS), nlist(
        "config",GLANCE_ENDPOINTS_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);


#----------------------------------------------------------------------------
# Startup configuration
#----------------------------------------------------------------------------

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service'= {
  foreach(i;service;GLANCE_SERVICES) {
    SELF[service] = nlist('on','',
                          'startstop',true,
                    );
  };

  SELF;
};

variable GLANCE_SERVICE_FILE ?= '/etc/service-glance';
variable GLANCE_SERVICE_CONTENTS ?= {
  contents = '';
  foreach(i;service;GLANCE_SERVICES) {
      contents = contents + service + "\n";
  };
  contents;
};

"/software/components/filecopy/services" = npush(
    escape(GLANCE_SERVICE_FILE), nlist(
        "config",GLANCE_SERVICE_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);

variable GLANCE_STARTUP_FILE ?= '/etc/init.d/openstack-glance';
variable GLANCE_STARTUP_CONTENTS ?= <<EOF;
#!/bin/sh
#
# OpenStack Glance Services
#
# chkconfig:   - 98 02
# description: Glance is the OpenStack image service
#
### END INIT INFO

. /etc/rc.d/init.d/functions

SERVICE_LIST=`cat /etc/service-glance`


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
    escape(GLANCE_STARTUP_FILE), nlist(
        "config",GLANCE_STARTUP_CONTENTS,
        "owner","root:root",
        "perms","0755",
    ),
);
