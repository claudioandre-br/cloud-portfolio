//-----------------------------------------------------------------------
// <copyright file="Function.cs" company="Amazon.com, Inc">
//
// Copyright (c) 2021 Claudio André claudioandre.br at gmail.com
// - Derivative work based upon:
// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//  http://aws.amazon.com/apache2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
// </copyright>
//-----------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.SimpleSystemsManagement;
using Amazon.SimpleSystemsManagement.Model;
using BuildingModernAppsNet.Model;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace BuildingModernAppsNet.Lambda.ListEventos
{
    /// <summary>
    /// Lambda function to list Eventos.
    /// </summary>
    public class Function
    {
        private AmazonSimpleSystemsManagementClient ssm = new AmazonSimpleSystemsManagementClient();
        private AmazonS3Client s3 = new AmazonS3Client();

        /// <summary>
        /// Lambda function handler.
        /// </summary>
        /// <param name="input">Query string parameters.</param>
        /// <param name="context">Lambda context.</param>
        /// <returns>API gateway response.</returns>
        public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest input, ILambdaContext context)
        {
            GetParameterResponse bucketResponse = await this.ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_bucket_name" });
            string bucketname = bucketResponse.Parameter.Value;

            GetParameterResponse fileResponse = await this.ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_db_name" });
            string filename = fileResponse.Parameter.Value;

            var query = this.GetQuery(input.QueryStringParameters);
            var request = new SelectObjectContentRequest
            {
                Bucket = bucketname,
                Key = filename,
                Expression = query,
                ExpressionType = ExpressionType.SQL,
                InputSerialization = new InputSerialization()
                {
                    JSON = new JSONInput()
                    {
                        JsonType = JsonType.Document,
                    },
                    CompressionType = CompressionType.None,
                },
                OutputSerialization = new OutputSerialization()
                {
                    JSON = new JSONOutput(),
                },
            };
            var eventoData = await this.QueryS3(request);

            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers.Add("access-control-allow-origin", "*");
            var response = new APIGatewayProxyResponse
            {
                Headers = headers,
                StatusCode = (int)HttpStatusCode.OK,
                Body = JsonSerializer.Serialize(eventoData),
            };

            return response;
        }

        private async Task<List<Evento>> QueryS3(SelectObjectContentRequest request)
        {
            var selectObjectContentResponse = await this.s3.SelectObjectContentAsync(request);

            // see also https://github.com/aws-samples/aws-netcore-webapp-using-amazonpersonalize/blob/main/AWS.Samples.Amazon.Personalize.Demo/Support/StorageService.cs
            var payload = selectObjectContentResponse.Payload;
            var eventos = new List<Evento>();

            using (payload)
            {
                foreach (var ev in payload)
                {
                    if (ev is RecordsEvent records)
                    {
                        using (var reader = new StreamReader(records.Payload, Encoding.UTF8))
                        {
                            while (reader.Peek() >= 0)
                            {
                                string result = reader.ReadLine();
                                Evento evento = JsonSerializer.Deserialize<Evento>(result);
                                eventos.Add(evento);
                            }
                        }
                    }
                }
            }

            string currentTime = DateTime.UtcNow.ToString("o");

            await this.s3.PutObjectAsync(new PutObjectRequest
            {
                ContentBody = "Acessado em: " + currentTime,
                BucketName = request.Bucket,
                Key = "last-queried.txt",
            });

            return eventos;
        }

        private string GetQuery(IDictionary<string, string> queryStringParameters)
        {
            var query = "select * from S3Object[*][*] s";
            var condition = string.Empty;

            // Some different querystrings for testing:
            // { "queryStringParameters": { "eventoName": "Deploy do Sistema" } }
            // { "queryStringParameters": { } }
            // { "queryStringParameters": { "type": "Festa" } }

            // Worried about concatenating SQL strings, and injection attacks?  In our case we allow users to see
            // all of the data, there's also np UPDATE, INSERT or DELETE commands in S3 select
            // https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-glacier-select-sql-reference-select.html
            if (queryStringParameters != null && queryStringParameters.Count > 0)
            {
                if (queryStringParameters.ContainsKey("type"))
                {
                    condition += $" where s.type_str = '{queryStringParameters["type"]}'";
                }

                if (queryStringParameters.ContainsKey("eventoName"))
                {
                    condition += string.IsNullOrEmpty(condition) ? " where " : " or ";
                    condition += $"s.evento_name_str =  '{queryStringParameters["eventoName"]}'";
                }
            }

            return query + condition;
        }
    }
}