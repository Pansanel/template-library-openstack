structure template vo/params/enea;

'name' ?= 'enea';
'account_prefix' ?= 'enerl';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15005,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'SW manager',
#          'fqan', '/enea/Role=SoftwareManager',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 47000;
