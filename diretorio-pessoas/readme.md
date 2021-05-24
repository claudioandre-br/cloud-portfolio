# Diretório de Funcionários

Aplicação criada pelo time de treinamento AWS para demonstrar como utilizar a AWS. Adaptei para uso via IaC (infra as Code).

Deve ser possível testar este ambiente na sua conta sem alterações. Contudo, como o nome do bucket deve ser exclusivo na AWS, se outra pessoa já estiver usando o nome que eu coloquei nos arquivos `.tf`, você terá que alterar o nome do bucket; faça isto nos dois arquivos abaixo:

```bash
$ grep -Ri bucked-id
s3.tf:  default = "employee-photo-bucket-cl" # TODO bucked-id.
start-up.sh:export PHOTOS_BUCKET=employee-photo-bucket-cl #TODO bucked-id.
```

### Casos de Uso

Aprender como usar AWS e como usar IaC.

Elegível para o nível gratuito. Elegible for the free tier.

IMPORTANT: The total cost of your sessions on AWS will vary depending on your usage and whether you are outside the AWS Free Tier limits.

### Dependências
[Terraform](http://www.terraform.io/downloads.html). A imagem Docker [claudioandre/john-cloud-tools](https://hub.docker.com/r/claudioandre/john-cloud-tools) usada nos exemplos abaixo já contém todas as dependências instaladas. Use-a:

```bash
cd PROJECT_FOLDER && \
  docker run -it --rm -v $(pwd):/host/cloud-tools -v ~/.aws/:/home/cracker/.aws/:ro claudioandre/john-cloud-tools
```

Dica: crie um _alias_ para o comando.

### AWS Credentials Profile
Crie seu arquivo [AWS profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

Exemplo de arquivo `~/.aws/credentials`
```
[rh]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

## Exemplo de uso (testado em uma conta Vocareum a na minha conta pessoal)

NÃO SE ESQUEÇA: garanta que o nome do bucket é único. Personalize-o, se necessário (veja acima no tópico [Diretório de Funcionários](#diretório-de-funcionários) como fazer isto).

```bash
# Get the tool
git clone https://github.com/claudioandre-br/cloud-portfolio.git cloud
cd  cloud/diretorio-pessoas

# The `-v` is to share content between host and Docker (Bind-mount a directory inside Docker)
#   Current (project) folder   -v $(pwd):/host/cloud-tools
#   AWS credentials            -v ~/.aws/:/home/cracker/.aws/:ro

docker run -it --rm -v $(pwd):/host/cloud-tools -v ~/.aws/:/home/cracker/.aws/:ro claudioandre/john-cloud-tools

# Create disposable SSH credentials (to use inside docker).
# You will not lose the key, it will be saved on the host machine due to Bind-mount (-v).
#   Do NOT use a passphrase.
ssh-keygen -t rsa -f workerKey

# If you have not created and linked your AWS credentials for use in Docker, create them now.
terraform init
terraform apply

# Do some tests then destroy the infrastructure created below (to avoid costs).
terraform destroy
```