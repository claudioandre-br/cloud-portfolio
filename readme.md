# Exemplos e Boas Práticas em Cloud

[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)

Este repositório foi criado para armazenar projetos-exemplo que sirvam para discutir, avaliar ou demonstrar boas práticas em Cloud. Serve, ainda, como um portfólio de soluções que eu desevolvi ou adaptei de fontes reconhecidas (por exemplo, os materiais oferecidos pela própria AWS).

# Índice
1. [Aplicação "Diretório de Funcionários"](#aplicação-demo-i-diretório-de-funcionários)
1. [AWS Identity and Access Management](#aws-identity-and-access-management-aws-iam)
7. [Package Security](#security)
8. [License](#license)

# Aplicações

### Aplicação Demo I "Diretório de Funcionários"

Aplicação desenvolvida pela AWS Training. Clique no link para visualizar como eu [implementei a solução](diretorio-pessoas#diretório-de-funcionários).

[![ Diagrama de Arquitetura](diretorio-pessoas/demo-01.svg)](diretorio-pessoas#diretório-de-funcionários)

#### Pontos a Destacar na Implementação
- Infraestrutura como código (IaC) foi usado;
- O projeto implementa alta disponibilidade via Application Load Balancer (ALB) em múltiplas AZs;
- O projeto prevê segurança 'by design'.
  - Os servidores Web **NÃO** possuem IP público, todo acesso se dá via ALB (desabilitado: requer NAT, que tem custo);
  - Os servidores Web aceitam conexões **APENAS** do ALB;
- A aplicação acessa arquivos no S3, mas o S3 **NÃO** está com acesso público;
- Logs de acesso à aplicação (via ALB) Web são salvos no S3 para auditoria.

Application Load Balancer é um dos tipos de Elastic Load Balancer (ELB).

### AWS Identity and Access Management (AWS IAM)

Neste tópico, eu salvei coisas interessantes relacionadas ao controle de acesso. Salvei alguns exemplos de policy (que eu criei no papel, sem testar) que são bons indicadores das possibilidades que o IAM oferece.

Clique no link para visualizar [os exemplos que criei](IAM#policies).

O fluxograma abaixo demonstra de forma simplificada como a avaliação sobre conceder ou não direitos a um usuário funciona. Contudo, muitos outros fatores influenciam esta decisão, como você poder ver no [fluxograma desta página](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow).
  
[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBMShSZXF1aXNpw6fDo288YnI-ZmVpdGEgcGVsbzxicj51c3XDoXJpbyByb290PylcbiAgICBBMihQZXJtaXRpZG8pXG5cbiAgICBCMShGb2kgbmVnYWRvPGJyPmV4cGxpY2l0YW1lbnRlPylcbiAgICBCMihFeHBsaWNpdCBEZW55KVxuXG4gICAgQzEoRm9pIHBlcm1pdGlkbzxicj5leHBsaWNpdGFtZW50ZT8pXG4gICAgQzIoUGVybWl0aWRvKVxuICAgIEMzKEltcGxpY2l0IERlbnkpXG5cbiAgICBBMSAtLT58U2ltfCBBMlxuICAgIEExIC0tPnxOw6NvfCBCMVxuICAgIEIxIC0tPnxTaW18IEIyXG4gICAgQjEgLS0-fE7Do298IEMxXG4gICAgQzEgLS0-fFNpbXwgQzJcbiAgICBDMSAtLT58TsOjb3wgQzNcbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6dHJ1ZSwiYXV0b1N5bmMiOnRydWUsInVwZGF0ZURpYWdyYW0iOnRydWV9)](IAM#policies)

Para criar policies, beba da fonte mais pura. Use estes exemplos:
- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html

Ou use uma GUI para te auxiliar a iniciar a jornada:
- https://awspolicygen.s3.amazonaws.com/policygen.html

## Security

Please inspect all packages prior to running any of them to ensure safety.
We already know they're safe, but you should verify the security and contents of any
binary from the internet you are not familiar with.

We take security very seriously.

## License

GNU General Public License v2.0