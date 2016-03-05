template personality/keystone/rpms/config;

prefix '/software/packages';

'{openstack-keystone}' ?= nlist();
'{python-keystoneclient}' ?= nlist();

'{openssl-devel}' ?= {
    if ( OS_CONFIGURE_VOS ) {
        nlist();
    } else {
        null;
    };
};
'{swig}' ?= {
    if ( OS_CONFIGURE_VOS ) {
        nlist();
    } else {
        null;
    };
};
'{python-pip}' ?= {
    if ( OS_CONFIGURE_VOS ) {
        nlist();
    } else {
        null;
    };
};
