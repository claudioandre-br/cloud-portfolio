######################################################################
# Copyright (c) 2021 Claudio André <claudioandre.br at gmail.com>
#
# This program comes with ABSOLUTELY NO WARRANTY; express or implied.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, as expressed in version 2, seen at
# http://www.gnu.org/licenses/gpl-2.0.html
######################################################################

# -------------- Livro de Ocorrências --------------
# Criar o bucket da aplicação. (casos-app)
read -p "Please enter the bucket name: " BUCKET_NAME
aws s3 mb s3://$BUCKET_NAME

# Listar os buckets e confirmar a criação.
aws s3 ls

# -------------------- Etapa I ---------------------
# Obter a aplicação.
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-BuildingNet/downloads/webapp1.zip -O webapp1.zip
unzip webapp1.zip -d webapp

# Obter o "banco de dados" (JSON) da aplicação.
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-BuildingNet/downloads/dragon_stats_one.txt -O dragon_stats_one.txt
cp dragon_stats_one.txt stats.txt

# -------------------- Etapa II --------------------
# Obter a aplicação.
wget https://rrs-public.s3.amazonaws.com/exercises/downloads/webapp2.zip -O webapp2.zip
unzip webapp2.zip -d webapp

# ------------------- Etapa III --------------------
# Obter a aplicação.
wget https://rrs-public.s3.amazonaws.com/exercises/downloads/webapp3.zip -O webapp3.zip
unzip webapp3.zip -d webapp

# ------------ Projeto do Visual Studio ------------
# Obter a solução (.sln) do Visual Studio.
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-BuildingNet/downloads/explore-sdk.zip -O explore-sdk.zip
unzip explore-sdk.zip -d modern-app

wget https://rrs-public.s3.amazonaws.com/exercises/downloads/dragons-lambda.zip -OutFile dragons-lambda.zip -O modern-app.zip
unzip modern-app.zip -d modern-app

# ------------------- Recorrente -------------------
BUCKET_NAME=casos-app

# Publicar a aplicação.
aws s3 cp webapp s3://$BUCKET_NAME/vigilante/ --recursive --acl public-read
echo "O link da aplicação é: https://$BUCKET_NAME.s3.amazonaws.com/vigilante/index.html"

# Publicar o "banco de dados" (JSON) da aplicação.
aws s3 cp DB.json s3://$BUCKET_NAME/DB.json
aws s3 ls s3://$BUCKET_NAME

# Ajustar os valores de configuração no 'Parameter Store'.
aws ssm put-parameter \
  --name "modern_app_bucket_name" \
  --type "String" \
  --overwrite \
  --value $BUCKET_NAME
aws ssm put-parameter \
  --name "modern_app_db_name" \
  --type "String" \
  --overwrite \
  --value DB.json

# --------------------- Outros ---------------------
  aws lambda list-functions --query 'Functions[].FunctionArn'

# ------------------ Cross Account ------------------
# O tempo para sincronizar o IAM foi relativamente alto.
# Eu mantive o Cognito e o bucket na conta de origem.
# API Gateway e as funções lambda estão na conta destino. Esta conta tem Step Functions e funciona
# Eu usei o lab LEVEL 300: LAMBDA CROSS ACCOUNT USING BUCKET POLICY para certificar meu conhecimento sobre o assunto.
  aws lambda add-permission   --function-name "arn:aws:lambda:us-east-1:AWS_ACC_ID:function:ListEventos"   --source-arn "arn:aws:execute-api:us-east-1:AWS_ACC_ID:API_GW_ID/*/GET/events"   --principal apigateway.amazonaws.com   --statement-id 3c9cf394-47d6-46e2-8677-266f4ac0e281   --action lambda:InvokeFunction