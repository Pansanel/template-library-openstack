
unique template personality/nova/controller/service;

variable NOVA_MYSQL_SERVER ?= MYSQL_HOST;

# Add RPMs for Nova
include { 'personality/nova/controller/rpms/config' };

include { 'features/bdii/rpms' };
# Add Nova controller configuration
include { 'personality/nova/controller/config' };
