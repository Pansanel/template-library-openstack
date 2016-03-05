structure template vo/params/eli-beams.eu;

'name' ?= 'eli-beams.eu';
'account_prefix' ?= 'elifvn';

'voms_servers' ?= list(
    nlist('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15006,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10293000;
