const AWS = require('aws-sdk');

let dynamodb = new AWS.DynamoDB.DocumentClient();
let date = new Date();
let now = date.toISOString();

exports.handler = async (event) => {
    // Obter os dados do solicitante do evento
    let visitante = JSON.stringify(`Visitante no Lambda: ${event.firstName} ${event.lastName}`);
    
    // Cria JSON com o registro que será salvo no DynamoDB
    let params = {
        TableName:'LivroDeVisitas',
        Item: {
            'ID': visitante,
            'LatestGreetingTime': now
        }
    };
    
    // Aguardar os dados serem gravados antes de seguir a execução
    await dynamodb.put(params).promise();
    
    // JSON com a resposta da execução do método
    const response = {
        statusCode: 200,
        body: name
    };

    return response;
};
