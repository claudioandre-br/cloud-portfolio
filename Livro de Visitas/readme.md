# Outros Recursos

Este diretório contém um aplicativo serverless que demonstra o uso do Amplify e de como acrescentar recursos dinâmicos a um site estático.

### Aplicação Demo "Livro de Visitas"

Eu fiz um site estático que, via API Gateway, registra os visitantes do site.
- O site é um "Livro de Visitas";
- O objetivo é incluir os dados digitados pelo usuário em um banco de dados.

Esta aplicação utiliza os serviços serverless Amazon CloudFront, o Amazon DynamoDB, o Amazon API Gateway e o
AWS Amplify. A aplicação contém:

- Uma interface web (site estático);
- Baixa latência via CDN (API Gateway via Endpoint Type);
- Persistência de dados;

### Como Tudo Funciona

Acesse o app via:
- https://dev.d39s1d4kron4ae.amplifyapp.com/

Funcionamento
- o site HTML chama uma API REST definida no API Gateway;
- A API Gateway repassa a chamada para uma função lambda;
- a função lambda chamada salva os dados no banco de dados DynamoDB.

A aplicação é:
- 100% serverless.
- o acesso é otimizado para a borda via CDN.