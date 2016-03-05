# Template configuring Neutron controller

unique template personality/neutron/controller/config;

variable NEUTRON_EMAIL ?= SITE_EMAIL;
variable NEUTRON_SERVICES ?= list('neutron-server');
variable NEUTRON_NODE_TYPE ?= 'controller';

# include configuration common to client and server
include { 'personality/neutron/config' };

# Database related variables
variable NEUTRON_MYSQL_ADMINUSER ?= 'root';
variable NEUTRON_MYSQL_ADMINPWD ?= error('NEUTRON_MYSQL_ADMINPWD required but not specified');

#------------------------------------------------------------------------------
# MySQL configuration
#------------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
    SELF[NEUTRON_MYSQL_SERVER]['adminuser'] = NEUTRON_MYSQL_ADMINUSER;
    SELF[NEUTRON_MYSQL_SERVER]['adminpwd'] = NEUTRON_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases/' = {
    SELF[OS_NEUTRON_DB_NAME]['createDb'] = true;
    SELF[OS_NEUTRON_DB_NAME]['server'] = NEUTRON_MYSQL_SERVER;
    SELF[OS_NEUTRON_DB_NAME]['users'][OS_NEUTRON_DB_USERNAME] = nlist(
        'password', OS_NEUTRON_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};

#------------------------------------------------------------------------------
# Endpoint configuration script
#------------------------------------------------------------------------------

variable NEUTRON_ENDPOINTS ?= '/root/sbin/create-neutron-endpoints.sh';
variable NEUTRON_ENDPOINTS_CONTENTS ?= file_contents('personality/neutron/controller/templates/create-neutron-endpoints.templ');

variable NEUTRON_ENDPOINTS_CONTENTS = replace('NEUTRON_PASSWORD',OS_NEUTRON_PASSWORD,NEUTRON_ENDPOINTS_CONTENTS);
variable NEUTRON_ENDPOINTS_CONTENTS = replace('NEUTRON_EMAIL',NEUTRON_EMAIL,NEUTRON_ENDPOINTS_CONTENTS);
variable NEUTRON_ENDPOINTS_CONTENTS = replace('NEUTRON_CONTROLLER_HOST',OS_NEUTRON_CONTROLLER_HOST,NEUTRON_ENDPOINTS_CONTENTS);
variable NEUTRON_ENDPOINTS_CONTENTS = replace('NEUTRON_MGMT_HOST',OS_NEUTRON_MGMT_HOST,NEUTRON_ENDPOINTS_CONTENTS);

"/software/components/filecopy/services" = npush(
    escape(NEUTRON_ENDPOINTS), nlist(
        "config",NEUTRON_ENDPOINTS_CONTENTS,
        "owner","root",
        "perms","0700",
    ),
);
