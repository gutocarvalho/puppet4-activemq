class activemq (
    $jvm_heap_mem     = '512m',
    $jvm_perm_mem     = '128m',
    $keystore_pass    = 'hacklab',
    $truststore_pass  = 'hacklab',
    $mco_user         = 'mcollective',
    $mco_pass         = 'marionette',
    ) {

  $activemq_confdir = '/etc/activemq'
  $activemq_ssldir  = '/etc/activemq/ssl'

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  yumrepo { 'puppetlabs-pc1':
    ensure   => 'present',
    baseurl  => 'http://yum.puppetlabs.com/el/7/PC1/$basearch',
    descr    => 'Puppet Labs PC1 Repository el 7 - $basearch',
    enabled  => '1',
    gpgcheck => '0',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
  }

  yumrepo { 'puppetlabs-deps':
    ensure   => 'present',
    baseurl  => 'http://yum.puppetlabs.com/el/7/dependencies/x86_64',
    descr    => 'Puppet Labs Dependencies EL 7 - x86_64',
    enabled  => '1',
    gpgcheck => '0',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
  }

  yumrepo { 'puppetlabs-products':
    ensure   => 'present',
    baseurl  => 'http://yum.puppetlabs.com/el/7/products/x86_64',
    descr    => 'Puppet Labs Products EL 7 - x86_64',
    enabled  => '1',
    gpgcheck => '0',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
  }

  package { 'activemq':
    ensure => present,
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    content => template('activemq/activemq.xml.erb'),
    notify  => Service['activemq'],
  }

  file { '/etc/sysconfig/activemq':
    ensure  => file,
    content => template('activemq/sysconfig.erb')
  }

  file { '/usr/share/activemq/activemq-data':
    ensure => link,
    target => '/usr/share/activemq/data',
  }

  file { $activemq_ssldir:
    ensure => directory,
  }

  file { "${activemq_ssldir}/puppet":
    ensure => directory,
  }

  file { "${activemq_ssldir}/puppet/ca.pem":
    ensure  => file,
    source  => 'puppet:///modules/activemq/puppet/ca.pem',
    notify  => Service['activemq'],
  }

  file { "${activemq_ssldir}/puppet/activemq-public.pem":
    ensure  => file,
    source  => 'puppet:///modules/activemq/puppet/activemq-public.pem',
  }

  file { "${activemq_ssldir}/puppet/activemq-private.pem":
    ensure  => file,
    source  => 'puppet:///modules/activemq/puppet/activemq-private.pem',
  }

  java_ks { 'activemq_ca:truststore':
    ensure       => latest,
    certificate  => '/etc/activemq/ssl/puppet/ca.pem',
    target       => '/etc/activemq/truststore.jks',
    password     => $truststore_pass,
    trustcacerts => true,
  }

  java_ks { 'activemq_cert:keystore':
    ensure      => latest,
    certificate => '/etc/activemq/ssl/puppet/activemq-public.pem',
    private_key => '/etc/activemq/ssl/puppet/activemq-private.pem',
    target      => '/etc/activemq/keystore.jks',
    password    => $keystore_pass,
  }

  file { "${activemq_confdir}/keystore.jks":
    require => Java_ks['activemq_cert:keystore'],
  }

  file { "${activemq_confdir}/truststore.jks":
    require => Java_ks['activemq_ca:truststore'],
  }

  service { 'activemq':
    ensure      => running,
    enable      => true,
  }

}