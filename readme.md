# Exemplos e Boas Práticas em Cloud

[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)

Este repositório foi criado para armazenar projetos-exemplo que sirvam para discutir, avaliar ou demonstrar boas práticas em Cloud. Serve, ainda, como um portfólio de soluções que eu desevolvi ou adaptei de fontes reconhecidas (por exemplo, os materiais oferecidos pela própria AWS).

# Índice
1. [Aplicações](#aplicações)
7. [Package Security](#security)
8. [License](#license)

# Aplicações

### Aplicação Demo I "Diretório de Funcionários"

Aplicação desenvolvida pela AWS Training. Clique no link para visualizar como eu [implementei a solução](diretorio-pessoas#diretório-de-funcionários).

#### Pontos a Destacar na Implementação
- Infraestrutura como código (Iac) foi usado;
- O projeto implmenta alta disponibilidade via Application Load Balancer (ALB) em múltiplas AZs;
- O projeto prevê segurança 'by design'.
  - Os servidores Web **NÃO** possuem IP público, todo acesso se dá via ALB (requer NAT, que tem custo);
  - Os servidores Web aceitam conexões **APENAS** do ALB;
- A aplicação acessa arquivos no S3, mas o S3 **NÃO** está com acesso público;
- Logs de acesso do ELB à aplicação Web são salvos no S3 para auditoria.

### Aplicação Demo II "Tô Pensando"

Vai devagar, eu nem terminei a Demo I.

## Security

Please inspect all packages prior to running any of them to ensure safety.
We already know they're safe, but you should verify the security and contents of any
binary from the internet you are not familiar with.

We take security very seriously.

## License

GNU General Public License v2.0