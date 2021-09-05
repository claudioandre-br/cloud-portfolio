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
using System.Text;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.SimpleSystemsManagement;
using Amazon.SimpleSystemsManagement.Model;
using BuildingModernAppsNet.Model;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace BuildingModernAppsNet.Lambda.ValidateEvento
{
    /// <summary>
    /// Lambda function to validate if an Evento exists.
    /// </summary>
    /// <remarks>Called from step functions.</remarks>
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
        public async Task<string> FunctionHandler(Evento input, ILambdaContext context)
        {
            GetParameterResponse bucketResponse = await this.ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_bucket_name" });
            string bucketname = bucketResponse.Parameter.Value;

            GetParameterResponse fileResponse = await this.ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_db_name" });
            string filename = fileResponse.Parameter.Value;

            var query = this.GetQuery(input.EventoName);
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

            // query the s3 object to see if the evento exists
            // some concurrency concerns here: fine for now, let's consider a different data store when the project grows
            await this.QueryS3(request);
            return "Evento validated";
        }

        private async Task QueryS3(SelectObjectContentRequest request)
        {
            var selectObjectContentResponse = await this.s3.SelectObjectContentAsync(request);

            // see also https://github.com/aws-samples/aws-netcore-webapp-using-amazonpersonalize/blob/main/AWS.Samples.Amazon.Personalize.Demo/Support/StorageService.cs
            var payload = selectObjectContentResponse.Payload;
            var Eventos = new List<Evento>();

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
                                // if we get any results throw an error
                                throw new EventoValidationException("Duplicate Evento reported");
                            }
                        }
                    }
                }
            }
        }

        private string GetQuery(string EventoName)
        {
            // Input for testing:
            // {  "evento_name_str": "Deploy do Sistema"  }

            // Worried about concatenating SQL strings, and injection attacks?  In our case we allow users to see
            // all of the data, there's also no UPDATE, INSERT or DELETE commands in S3 select
            // https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-glacier-select-sql-reference-select.html
            return $"select * from S3Object[*][*] s where s.Evento_name_str = '{EventoName}'";
        }
    }
}