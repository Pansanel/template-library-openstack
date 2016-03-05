# This template defines tenant mapping for VO names

unique template vo/site/vos_tenant_mapping;

# VOS_ALIASES is a nlist where key is the name used to refer to the VO (the alias)
# and the value is the name of the tenant which the VO is mapped.

variable VOS_TENANT_MAPPING ?= nlist(
  'dteam', 'dteam',
  'fedcloud.egi.eu', 'EGI_FCTF',
  'ops', 'EGI_ops',
  'vo.france-grilles.fr', 'FG_Cloud',
  'vo.formation.idgrilles.fr', 'FG_formation',
  'cms', 'LHC_cms',
  'biomed', 'EGI_biomed',
  'vo.nbis.se', 'EGI_nbis',
  'verce.eu', 'EGI_verce',
);
