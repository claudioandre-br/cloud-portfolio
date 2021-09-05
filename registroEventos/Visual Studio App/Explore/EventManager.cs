//-----------------------------------------------------------------------
// <copyright file="EventManager.cs" company="ClaudioAndréInc">
//     Copyright (c) 2021 Claudio André <claudioandre.br at gmail.com>
//
//     This program comes with ABSOLUTELY NO WARRANTY; express or implied.
//
//     This program is free software: you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as published by
//     the Free Software Foundation, as expressed in version 2, seen at
//     http://www.gnu.org/licenses/gpl-2.0.html
// </copyright>
//-----------------------------------------------------------------------
namespace App
{
    using System;
    using System.IO;
    using System.Text;
    using System.Threading.Tasks;
    using Amazon.S3;
    using Amazon.S3.Model;
    using Amazon.SimpleSystemsManagement;
    using Amazon.SimpleSystemsManagement.Model;

    /// <summary>
    /// App de gestão de eventos ou ocorrências em produção.
    /// </summary>
    public class EventManager
    {
        /// <summary>
        /// Ponto de entrada do aplicativo.
        /// </summary>
        /// <param name="args">Not used.</param>
        public static void Main(string[] args)
        {
            var eventData = ReadEventData();
            Console.WriteLine(eventData.Result);
        }

        private static async Task<string> ReadEventData()
        {
            // Parâmetros do aplicativo salvos no Systems Manager.
            AmazonSimpleSystemsManagementClient ssm = new AmazonSimpleSystemsManagementClient();
            GetParameterResponse bucketResponse = await ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_bucket_name" });
            var bucketName = bucketResponse.Parameter.Value;
            GetParameterResponse fileResponse = await ssm.GetParameterAsync(new GetParameterRequest { Name = "modern_app_db_name" });
            var key = fileResponse.Parameter.Value;

            var query = GetQuery();
            var request = new SelectObjectContentRequest
            {
                Bucket = bucketName,
                Key = key,
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
            var dragonData = QueryS3(request);
            return dragonData.Result;
        }

        private static async Task<string> QueryS3(SelectObjectContentRequest request)
        {
            AmazonS3Client s3 = new AmazonS3Client();
            var selectObjectContentResponse = await s3.SelectObjectContentAsync(request);

            // see also https://github.com/aws-samples/aws-netcore-webapp-using-amazonpersonalize/blob/main/AWS.Samples.Amazon.Personalize.Demo/Support/StorageService.cs
            var payload = selectObjectContentResponse.Payload;

            var stringBuilder = new StringBuilder();
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
                                stringBuilder.Append(result);
                            }
                        }
                    }
                }
            }

            string currentTime = DateTime.UtcNow.ToString("o");
            var response = await s3.PutObjectAsync(new PutObjectRequest
            {
                ContentBody = "Acessado em: " + currentTime,
                BucketName = request.Bucket,
                Key = "last-queried.txt",
            });

            return stringBuilder.ToString();
        }

        private static string GetQuery()
        {
            // later on this method will return different results based
            // on query string parameters. For now, we will hardcode the results
            // to select *, which isn't the best showcase of S3 select
            // but don't worry we will get there
            return "select * from s3object s";
        }
    }
}
