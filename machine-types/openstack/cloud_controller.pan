template machine-types/openstack/cloud_controller;

# Include base configuration of a Cloud node
include { 'machine-types/openstack/base' };

include 'features/mariadb/config';
include 'features/rabbitmq/config';

include { 'personality/keystone/service' };
include { 'personality/glance/service' };
include { 'personality/cinder/service' };
include { 'personality/neutron/controller/service' };
include { 'personality/nova/controller/service' };

# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
include { if_exists(OPENSTACK_OS_POSTCONFIG) };

