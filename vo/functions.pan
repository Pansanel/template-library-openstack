unique template vo/functions;

function add_vo_infos = {

  function_name = "add_vo_infos";

  vo = ARGV[0];
  vo_params = VO_PARAMS;
  result = nlist();
  auth_uri = list();

  debug("Starting configuration of VO "+vo);

  if ( is_defined(vo_params[vo]['voms_servers']) ) {
    if ( is_list(vo_params[vo]['voms_servers']) ) {
      voms_servers = vo_params[vo]['voms_servers'];
    } else {
      voms_servers = list(vo_params[vo]['voms_servers']);
    };
  } else {
    voms_servers = list();
  };
  debug('Standard VOMS server list = '+to_string(voms_servers));


  # Real name of the virtual organization.
  # 'vo' can be an alias, 'vo_name' is the real name of the VO: use the right one in each context!
  if ( is_defined(vo_params[vo]['name']) ) {
     vo_name = vo_params[vo]['name'];
     result['name'] = vo_name;
     if ( vo_name != vo ) {
       debug("Real VO name = "+vo_name);
     };
  } else {
     error('Name undefined for VO '+vo);
  };

  #
  # Add the VOMS client configuration.
  #

  if ( length(voms_servers) > 0 ) {
    result['vomsclient']['servers'] = list();
    foreach (i;voms_server;voms_servers) {
      if ( is_defined(voms_server['cert']) ) {
        cert_template = 'vo/certs/' + voms_server['cert'];
      } else {
        cert_template = 'vo/certs/' + voms_server['name'];
      };
      vo_cert_params = create(cert_template);
      if ( !exists(vo_cert_params["cert"]) || !is_defined(vo_cert_params["cert"]) ) {
        error(function_name+' : no certificate found in '+cert_template+' for VOMS server '+voms_server['name']);
      };
      if ( is_defined(vo_cert_params["oldcert"]) ) {
        oldcert = nlist('oldcert',vo_cert_params["oldcert"]);
      } else {
        oldcert = nlist();
      };
      
      result['vomsclient']['servers'][length(result['vomsclient']['servers'])] = merge(nlist('host', voms_server['host'],
                                                                                             'port', voms_server['port'],
                                                                                             'cert', vo_cert_params['cert'],
                                                                                            ),
                                                                                       oldcert
                                                                                      );
    };
  };

  result;
};


# 
# This function should only be used with 
# '/software/components/vomsclient' as the 
# path.  This takes a list of VOs and relies on
# the information in the global variable VO_INFO.
#
function combine_vomsclient_vos = {
  function_name = "combine_vomsclient_vos";
  comp_base = "/software/components/vomsclient";
  
  # Check cardinality.
  if (ARGC != 1) error("usage: '"+comp_base+"' = "+function_name+"(vos)");

  if ( !exists(SELF) || !is_defined(SELF)) {
    error(function_name+" : "+comp_base+" must exist");
  };
  
  if ( !exists(SELF['vos']) || !is_nlist(SELF['vos']) ) {
    SELF['vos'] = nlist();
  };
  
  foreach (k;v;ARGV[0]) {
    if ( is_defined(VO_INFO[v]['vomsclient']['servers']) ) {
      SELF['vos'][VO_INFO[v]['name']] = VO_INFO[v]['vomsclient']['servers'];
    };
  };
  SELF; 
};


#
# Add all required VOMS server certificates - if existing
#
function add_voms_certs = {
  vomsdir = '/etc/grid-security/vomsdir';
    if ( exists( VOMS_SERVERS ) && is_nlist( VOMS_SERVERS ) ) {
        # check per VOMS server if a certificate has been defined
        # and include it if that is the case
        foreach( srv; cfg; VOMS_SERVERS ) {
      file = escape(vomsdir + "/" + srv);
            if ( exists( "vo/certs/"+srv ) ) {
                SELF['filecopy']['services'][file] = create("vo/certs/"+srv);
                SELF['filecopy']['services'][file]['perms'] = '0644';
            };
        };
    }
    else {
        debug("[add_voms_certs] VOMS_SERVERS is not defined or not an nlist");
    };
    SELF;
};
