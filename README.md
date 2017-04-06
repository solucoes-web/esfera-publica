# Esfera Pública
[![Build Status](https://travis-ci.org/solucoes-web/esfera-publica.svg?branch=master)](https://travis-ci.org/solucoes-web/esfera-publica)

Uma plataforma aberta e distribuída para ler e compartilhar notícias.

## Proposta

Construir uma plataforma distribuída para leitura e compartilhamento de notícias com as seguintes metas:
* algoritmo transparente de sugestão de matéria
* uso de padrões aberto (RSS, RDF, SIOC, FOAF, DC, OpenID etc.)
* possibilidade de comentar e sugerir notícias
* plataforma distribuída (i.e. usuários em outros sites usando o mesmo modelo RSS podem compartilhar materias uns com os outros)

Consulte o [plano de trabalho](https://docs.google.com/presentation/d/1jxLIZcn9uPJnliXzE5CRlQD7mq5iaruq_4Jke4QBpdw/edit?usp=sharing) para mais detalhes.

## Instalação

* clone o repositorio: `git clone https://github.com/solucoes-web/esfera-publica.git`
* gere uma chave usando `rake secret` para cada `secret_key_base` em `config/secrets.sample.yml`
* renomeie o arquivo `config/secrets.sample.yml` para `config/secrets.yml`: `mv config/secrets.sample.yml config/secrets.yml`
* rode as migrações: `rake db:migrate`
