structure template vo/params/gridpp;

'name' ?= 'gridpp';
'account_prefix' ?= 'griuw';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15000,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15000,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15000,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    nlist('description', '',
          'fqan', '/gridpp/Role=VO-Admin',
          'suffix', 'luw',
          'suffix2', 'tgvfehp',
         ),
    nlist('description', 'SW manager',
          'fqan', '/gridpp/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 110000;
