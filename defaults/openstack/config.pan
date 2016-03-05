unique template defaults/openstack/config;

# This file defines a set of global variables for configuring the 
# OpenStack middleware.  Where the variables have sensible defaults,
# real values are given.  Others which must be changed are defined
# as 'undef'.  These will generate errors if you use them without
# redefining the value. 

# This template should be included after any of your customizations
# but before using any of the standard OpenStack templates in your
# machine definitions.

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

variable OS_MGMT_NETWORK_ENABLED ?= false;
variable OS_CONTROLLER_HOST ?= error('OS_CONTROLLER_HOST must be declared');
variable OS_MGMT_CONTROLLER_HOST ?= {
  if (OS_MGMT_NETWORK_ENABLED) {
    error('OS_MGMT_CONTROLLER_HOST must be declared');
  } else {
    OS_CONTROLLER_HOST;
  };
};

############################
# Active SSL configuration #
############################
variable OS_SSL ?= false;
variable OS_SSL_CERT ?= '/etc/pki/tls/certs/' + OS_CONTROLLER_HOST + '.pem';
variable OS_SSL_KEY ?= '/etc/pki/tls/private/' + OS_CONTROLLER_HOST + '.key';
variable OS_MGMT_SSL_CERT ?= '/etc/pki/tls/certs/' + OS_MGMT_CONTROLLER_HOST + '.pem';
variable OS_MGMT_SSL_KEY ?= '/etc/pki/tls/private/' + OS_MGMT_CONTROLLER_HOST + '.key';
variable OS_SSL_CHAIN ?= null;
variable OS_MGMT_SSL_CHAIN ?= null;
variable OS_CONTROLLER_PROTOCOL ?= if (OS_SSL) {
  'https';
} else {
  'http';
};

variable OS_CONFIGURE_VOS ?= false;

##############
# RegionName #
##############
variable OS_REGION_NAME ?= 'RegionOne';

#----------------------------------------------------------------
# SECURITY LOCATIONS
#----------------------------------------------------------------

# Constants used for security-related files and directories.  Change these
# only if you keep these in non-standard locations.

variable SITE_DEF_GRIDSEC_ROOT ?= "/etc/grid-security";
variable SITE_DEF_HOST_CERT    ?= SITE_DEF_GRIDSEC_ROOT+"/hostcert.pem";
variable SITE_DEF_HOST_KEY     ?= SITE_DEF_GRIDSEC_ROOT+"/hostkey.pem";
variable SITE_DEF_CERTDIR      ?= SITE_DEF_GRIDSEC_ROOT+"/certificates";
variable SITE_DEF_VOMSDIR      ?= SITE_DEF_GRIDSEC_ROOT+"/vomsdir";

#----------------------------------------------------------------
# SITE DEFINITIONS
#----------------------------------------------------------------

# Site's DNS domain name.  This must be a fully-qualified domain
# name as a string.  It is used throughout the standard configuration.

variable SITE_DOMAIN ?= undef;

#----------------------------------------------------------------
# SERVICE LOCATIONS
#----------------------------------------------------------------

# Nova host (cloud controller) 
variable OS_NOVA_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NOVA_MGMT_HOST ?= OS_MGMT_CONTROLLER_HOST;

# Keystone
variable OS_KEYSTONE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_KEYSTONE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_KEYSTONE_MGMT_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_KEYSTONE_MGMT_HOST ?= OS_MGMT_CONTROLLER_HOST;
variable KEYSTONE_CONTROLLER_AUTH ?= OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
variable KEYSTONE_MGMT_AUTH ?= OS_KEYSTONE_MGMT_PROTOCOL + '://' + OS_KEYSTONE_MGMT_HOST + ':5000';
variable KEYSTONE_ADMIN_AUTH ?= OS_KEYSTONE_MGMT_PROTOCOL + '://' + OS_KEYSTONE_MGMT_HOST + ':35357';
variable KEYSTONE_PUBLIC_ENDPOINT ?= OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
variable KEYSTONE_MGMT_ENDPOINT ?= OS_KEYSTONE_MGMT_PROTOCOL + '://' + OS_KEYSTONE_MGMT_HOST + ':5000/v2.0';

# Glance host
variable OS_GLANCE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_GLANCE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_GLANCE_MGMT_HOST ?= OS_MGMT_CONTROLLER_HOST;

# Cinder host
variable OS_CINDER_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_CINDER_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_CINDER_MGMT_HOST ?= OS_MGMT_CONTROLLER_HOST;

# Neutron host
variable OS_NEUTRON_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NEUTRON_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_NEUTRON_MGMT_HOST ?= OS_MGMT_CONTROLLER_HOST;
variable METADATA_PROXY_ENABLED ?= true;
variable METADATA_PROXY_SHARED_SECRET ?= '';

# Rabbit host
variable RABBIT_HOST ?= OS_MGMT_CONTROLLER_HOST;
variable RABBITMQ_USER ?= 'openstack';
variable RABBITMQ_PASSWORD ?= 'RABBIT_PASS';


# MySQL host
variable MYSQL_HOST ?= OS_MGMT_CONTROLLER_HOST;

#############################
# Memcache specfic variable #
#############################
variable OS_MEMCACHE_HOST ?= 'localhost';

