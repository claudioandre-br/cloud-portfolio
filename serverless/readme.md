# Serverless

Este diretório contém uma aplicação que usa uma série de serviços serverless da AWS. A aplicação original foi criada pelo time de treinamento AWS para demonstrar como utilizar a AWS. Adaptei para o meu caso de uso.

Deve ser possível testar este ambiente na sua conta sem alterações. Eu **não** usei IaC (Infra como código), portanto, algumas funcionalidades foram implementadas diretamente na AWS e você não conseguirá vê-las aqui.

### Aplicação Demo "Qual o clima no Campus do IFSP"

Esta aplicação utiliza os serviços serverless Amazon LEX, o Amazon CloudFront, o Amazon DynamoDB, Amazon API Gateway e o Simple Storage Service (S3). A aplicação contém:

- Um bot com reconhecimento de fala e compreensão de linguagem natural (em inglês, o Amazon LEX ainda não suporta PT-BR);
- Uma interface web que informa o clima no campus selecionado;
- Baixa latência via CDN e acesso restrito à origem no S3;
- Persistência de dados;

### Casos de Uso

Aprender como usar AWS e como usar IaC.

Elegível para o nível gratuito. Elegible for the free tier.

IMPORTANT: The total cost of your sessions on AWS will vary depending on your usage and whether you are outside the AWS Free Tier limits.