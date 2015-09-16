# PuppetServer

#### Tabela de conteudo

1. [Overview](#overview)
2. [Compatibilidade](#compatibilidade)
3. [Setup](#setup)
4. [Uso](#uso)
5. [Limites](#limites)
6. [Pendende](#pendente)
7. [Referencias](#referencias)

## Overview

Esse módulo instala e configura o ActiveMQ 5.9 em ambiente CentOS com suporte a TLS.

## Compatibilidade

Esse módulo é compatível com CentOS 7.x.

Esse módulo foi desenvolvido usando Puppet 4.

Esse módulo depende do módulo puppetlabs/java_ks.

## Setup

### O que esse modulo gerencia?

#### classe activemq

  * Repositório yum PC1 da Puppet Labs (yumrepo)
  * Repositório yum Products da Puppet Labs (yumrepo)
  * Pacote activeMQ (package)
  * Arquivo de configuração /etc/activemq/activemq.xml (file)
  * Arquivo de configuração /etc/sysconfig/activemq (file)
  * Gera a Keystore (java_ks)
  * Gera a Truststore (java_ks)
  * Gerencia a Truststore do ActiveMQ (file)
  * Gerencia a Keystore do ActiveMQ (file)
  * Gerencia o serviço ActiveMQ (service)
  
## Uso

### declarando classe mcollective

```puppet
  class { ::activemq:
    jvm_heap_mem     => '512m',
    jvm_perm_mem     => '128m',
    keystore_pass    => 'hacklab',
    truststore_pass  => 'hacklab',
    mco_user         => 'mcollective',
    mco_pass         => 'marionette',
  }
```

#### certificados

Esse módulo vem com certificados, pode utilizá-los para teste, no entanto, em produção, o recomendado é que você gere seus certificados e coloque no caminho abixo

```
modules/activemq/files/puppetca.pem
modules/activemq/files/puppetactivemq-private.pem
modules/activemq/files/puppetactivemq-public.pem
```

Depois de substituir aplique o módulo em sua VM para regerar a truststore e a keystore a partir deles.

O módulo puppet4-mcollective também ter certificados gerados a partir dessa mesma CA, logo serão compatíveis na conexão do Mcollective Server ao ActiveMQ usando esses certificados embutidos

## Limites

  1. Só funciona em CentOS 7
  2. Só funciona com Puppet 4
  3. Testando apenas com Puppet Server 2.1.1

## Referencias

  * http://gutocarvalho.net/octopress/2015/08/21/activemq-e-mcollective-no-puppet-4/
  * http://gutocarvalho.net/octopress/2015/09/09/activemq-e-mcollective-com-ssl/