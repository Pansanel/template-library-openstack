# Template to load standard parameters for all VOs
#
# This template is normally called by vo/config.tpl and should not be called
# directly, except for machines requiring VO parameters being loaded but
# without a real VO configuration (e.g. BDII).

template vo/init;

variable VOS_TENANT_MAPPING_TEMPLATE ?= 'vo/site/aliases';

include { if_exists(VOS_TENANT_MAPPING_TEMPLATE) };

variable VOS_TENANT_MAPPING ?= nlist();

include { 'vo/functions' };


variable VO_PARAMS ?={
  foreach(k;v;VOS) {
    if ( exists(VOS_ALIASES[v]) && is_defined(VOS_ALIASES[v]) ) {
      vo = VOS_ALIASES[v];
    } else {
      vo = v;
    };
    SELF[v] = create("vo/params/"+vo);
  };
  SELF;
};

variable VO_INFO = {
  foreach(k;v;VOS) {
    SELF[v] = add_vo_infos(v);
  };
  SELF;
};
