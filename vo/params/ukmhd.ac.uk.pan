structure template vo/params/ukmhd.ac.uk;

'name' ?= 'ukmhd.ac.uk';
'account_prefix' ?= 'ukmfua';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15041,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10254000;
