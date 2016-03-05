structure template vo/params/lsst;

'name' ?= 'lsst';
'account_prefix' ?= 'lssfvb';

'voms_servers' ?= list(
    nlist('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10281000;
