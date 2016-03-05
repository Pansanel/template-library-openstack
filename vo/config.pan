# Template to configure VOs for a specific node (including pool account
# creation)
#
# Some variables can be used to customize this template behaviour

template vo/config;

variable NODE_VO_VOMSCLIENT ?= true;


# Check VO list is defined and handle special value 'ALL' (configure all possible VOs).
# Also allows VOS to a be string instead of a list and convert it to a list.
variable VOS ?= { error('vo/config : VO list (VOS) undefined'); };
variable VOS = if ( is_list(SELF) ) {
                 SELF;
               } else {
                 error('Invalid value for VOS ('+to_string(VOS)+'. Must be a list.');
               };

# Include VO parameters and functions
include { 'vo/functions' };
include { 'vo/init' };

#
# Virtual organization configuration.
#
#'/system/vo' = combine_system_vo(VOS);

# Configure VOMS client
variable VOMSCLIENT_CONFIG = if ( NODE_VO_VOMSCLIENT ) { 
                               "features/security/vomsclient";
                             } else {
                               null;
                             };
include { VOMSCLIENT_CONFIG };
variable VOMSCLIENT_INCLUDE = if ( NODE_VO_VOMSCLIENT ) {
                                "components/vomsclient/config";
                              } else {
                                null;
                              };
include { VOMSCLIENT_INCLUDE };
'/software/components/vomsclient' = if ( NODE_VO_VOMSCLIENT ) {
                                      combine_vomsclient_vos(VOS);
                                    } else {
                                      null;
                                    };
