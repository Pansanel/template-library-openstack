structure template vo/params/fermilab;

'name' ?= 'fermilab';
'account_prefix' ?= 'ferfwb';

'voms_servers' ?= list(
    nlist('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10307000;
