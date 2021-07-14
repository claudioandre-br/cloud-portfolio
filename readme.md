# Exemplos e Boas Práticas em Cloud

[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)

Este repositório foi criado para armazenar projetos-exemplo que sirvam para discutir, avaliar, aprender ou demonstrar boas práticas em Cloud. Serve, ainda, como um portfólio de soluções que eu desevolvi ou adaptei de fontes reconhecidas (por exemplo, os materiais oferecidos pela própria AWS).

# Índice
1. [Portfolio de Cloud (Aplicações de Demonstração e Exemplo)](#aplicações)
    1. [Aplicação "Diretório de Funcionários"](#aplicação-demo-i-diretório-de-funcionários)
    1. [Aplicação "Clima no Campus"](#aplicação-demo-ii-clima-no-campus)
1. [AWS Identity and Access Management](#aws-identity-and-access-management-aws-iam)
6. [Cursos AWS que são um show](#cursos-recomendados)
7. [Segurança](#security)
8. [Licença](#license)

# Aplicações

Este repositório serve como um portfólio de soluções Cloud que eu desevolvi ou adaptei. Ainda, para demonstrar minha vivência na plataforma AWS. Por fim, como um _cheat sheet_ usado para referência e consultas rápidas.

### Aplicação Demo I "Diretório de Funcionários"

Aplicação desenvolvida pela AWS Training. Clique no link para visualizar como eu [implementei a solução](diretorio-pessoas#diretório-de-funcionários).

[![ Diagrama de Arquitetura](diretorio-pessoas/demo-01.svg)](diretorio-pessoas#diretório-de-funcionários)

#### Pontos a Destacar na Implementação
- Infraestrutura como código (IaC) foi usado;
- O projeto implementa alta disponibilidade via Application Load Balancer (ALB) em múltiplas AZs;
- O projeto prevê segurança 'by design';
  - Os servidores Web **NÃO** possuem IP público, todo acesso se dá via ALB (desabilitado: requer NAT, que tem custo);
  - Os servidores Web aceitam conexões **APENAS** do ALB;
- A aplicação acessa arquivos no S3, mas o S3 **NÃO** está com acesso público;
- Logs de acesso à aplicação Web (obtidos do ALB) são salvos no S3 para auditoria.

Application Load Balancer (ALB) é um dos tipos de Elastic Load Balancer (ELB).

### Aplicação Demo II "Clima no Campus"

Aplicação adaptada de um app desenvolvido pela AWS Training. Clique no link para visualizar como eu [implementei a solução](serverless#serverless).

[![ Diagrama de Arquitetura](serverless/Estrutura-Serverless-AWS.svg)](serverless#serverless)

#### Pontos a Destacar na Implementação
- Aplicação 100% serverless;
- Implementa uma interface de conversação capaz de lidar com voz e texto;
- O bot para interação é capaz de reconhecimento de fala e compreensão de linguagem natural;
- Uso de CDN para melhorar a experiência no usuário;
- O S3 **NÃO** está com acesso público (apenas o CloudFront pode acessar a origem).

### AWS Identity and Access Management (AWS IAM)

Neste tópico, eu salvei coisas interessantes relacionadas ao controle de acesso. Salvei alguns exemplos de policy (que eu criei no papel, sem testar) que são bons indicadores das possibilidades que o IAM oferece.

Clique no link para visualizar [os exemplos que criei](IAM#policies).

O fluxograma abaixo demonstra de forma simplificada como a avaliação sobre conceder ou não direitos a um usuário funciona. Contudo, muitos outros fatores influenciam esta decisão, como você poder ver no [fluxograma desta página](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow).

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBMShSZXF1aXNpw6fDo288YnI-ZmVpdGEgcGVsbzxicj51c3XDoXJpbyByb290PylcbiAgICBBMihQZXJtaXRpZG8pXG5cbiAgICBCMShGb2kgbmVnYWRvPGJyPmV4cGxpY2l0YW1lbnRlPylcbiAgICBCMihFeHBsaWNpdCBEZW55KVxuXG4gICAgQzEoRm9pIHBlcm1pdGlkbzxicj5leHBsaWNpdGFtZW50ZT8pXG4gICAgQzIoUGVybWl0aWRvKVxuICAgIEMzKEltcGxpY2l0IERlbnkpXG5cbiAgICBBMSAtLT58U2ltfCBBMlxuICAgIEExIC0tPnxOw6NvfCBCMVxuICAgIEIxIC0tPnxTaW18IEIyXG4gICAgQjEgLS0-fE7Do298IEMxXG4gICAgQzEgLS0-fFNpbXwgQzJcbiAgICBDMSAtLT58TsOjb3wgQzNcbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6dHJ1ZSwiYXV0b1N5bmMiOnRydWUsInVwZGF0ZURpYWdyYW0iOnRydWV9)](IAM#policies)

Para criar policies, beba da fonte mais pura. Use estes exemplos:
- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html

Ou use uma GUI para te auxiliar a iniciar a jornada:
- https://awspolicygen.s3.amazonaws.com/policygen.html

## Cursos Recomendados

Este tópico lista _alguns_[1] cursos AWS que eu fiz e recomendo. São cursos oficiais, desenvolvidos e produzidos pela própria AWS; em alguns casos, operacionalizados por instituições credenciadas (`instituições reconhecidas de ensino superior`), mas todo o material audiovisual é de autoria da AWS.

- _AWS Training and Certification_
  * AWS Cloud Practitioner Essentials (**ES·PE·TA·CU·LAR**)
  * Getting Started with Cloud Acquisition
  * AWS Security Fundamentals (Second Edition)

- _Coursera_ fornecidos por Amazon Web Services
  * Introduction to AWS Identity and Access Management
  * AWS Fundamentals: Going Cloud-Native

  Via "AWS Fundamentals Specialization":
  * AWS Cloud Technical Essentials (muito interessante)
  * AWS Fundamentals: Addressing Security Risk (deixa a desejar)
  * AWS Fundamentals: Migrating to the Cloud
  * AWS Fundamentals: Building Serverless Applications (muito interessante)

- _Instituto Federal de São Paulo (IFSP)_
  * AWS Academy Cloud Foundations (ACF)

- _AWS Educate_ (são cursos fracos, ainda assim, oficiais)
  * Solutions Architect

[1] Alguns cursos, apesar de interessantes e gratuitos, não foram listados para manter a objetividade e brevidade. Fiz mais de uma dúzia de cursos AWS oficiais (desenvolvidos pela Aws Training and Certification), alguns estão disponíveis em alguma plataforma (por exemplo, curso desenvolvido pela AWS e disponível no Coursera). Valem muito a pena: profundidade e a precisão na medida certa.

## Security

Please inspect all packages prior to running any of them to ensure safety.
We already know they're safe, but you should verify the security and contents of any
binary from the internet you are not familiar with.

We take security very seriously.

## License

GNU General Public License v2.0