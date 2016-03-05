unique template features/httpd/config;

include 'features/httpd/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'httpd/on' = '';
'httpd/startstop' = true;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/wsgi-keystone.conf}';
'module' = 'apache-keystone';
'daemons/httpd' = 'restart';
'contents/listen' = list(5000, 35357);

'contents/vhosts/0/server' = OS_KEYSTONE_CONTROLLER_HOST;
'contents/vhosts/0/port' = 5000;
'contents/vhosts/0/processgroup' = 'keystone-public';
'contents/vhosts/0/script' = '/usr/bin/keystone-wsgi-public';
'contents/vhosts/0/ssl' = if (OS_SSL) {
  SELF['cert'] = OS_SSL_CERT;
  SELF['key'] = OS_SSL_KEY;
  if (exists(OS_SSL_CHAIN)) {
    SELF['chain'] = OS_SSL_CHAIN;
  };
  SELF;
} else {
  null;
};

'contents/vhosts/1/server' = OS_KEYSTONE_MGMT_HOST;
'contents/vhosts/1/port' = 35357;
'contents/vhosts/1/processgroup' = 'keystone-admin';
'contents/vhosts/1/script' = '/usr/bin/keystone-wsgi-admin';
'contents/vhosts/1/ssl' = if (OS_SSL) {
  SELF['cert'] = OS_MGMT_SSL_CERT;
  SELF['key'] = OS_MGMT_SSL_KEY;
  if (exists(OS_MGMT_SSL_CHAIN)) {
    SELF['chain'] = OS_MGMT_SSL_CHAIN;
  };
  SELF;
} else {
  null;
};

'contents/vhosts/2/server' = OS_KEYSTONE_MGMT_HOST;
'contents/vhosts/2/port' = 5000;
'contents/vhosts/2/processgroup' = 'keystone-internal';
'contents/vhosts/2/script' = '/usr/bin/keystone-wsgi-public';
'contents/vhosts/2/ssl' = if (OS_SSL) {
  SELF['cert'] = OS_MGMT_SSL_CERT;
  SELF['key'] = OS_MGMT_SSL_KEY;
  if (exists(OS_MGMT_SSL_CHAIN)) {
    SELF['chain'] = OS_MGMT_SSL_CHAIN;
  };
  SELF;
} else {
  null;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/apache-keystone.tt}';
'config' = file_contents('features/httpd/metaconfig/apache-keystone.tt');
'perms' = '0644';
