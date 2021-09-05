//-----------------------------------------------------------------------
// <copyright file="EventoValidationException.cs" company="Amazon.com, Inc">
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
using System.Text;
using System.Text.Json.Serialization;

namespace BuildingModernAppsNet.Model
{
    /// <summary>
    /// POCO with some attributes to match the format the data is in.
    /// </summary>
    public class Evento
    {
#pragma warning disable CS1591
        [JsonPropertyName("description_str")]
        public string Description { get; set; }

        [JsonPropertyName("evento_name_str")]
        public string EventoName { get; set; }

        [JsonPropertyName("type_str")]
        public string Type { get; set; }

        [JsonPropertyName("local_str")]
        public string LocationCity { get; set; }
#pragma warning restore CS1591
    }
}
