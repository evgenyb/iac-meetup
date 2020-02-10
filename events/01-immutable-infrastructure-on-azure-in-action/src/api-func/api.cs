using System;
using System.Threading.Tasks;
using aapi_funcpi.CosmosClients;
using api_func.CosmosClients;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Documents.Client;
using Microsoft.Extensions.Logging;

namespace api_func
{
    public static class api
    {
        [FunctionName("values")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            var connectionString = Environment.GetEnvironmentVariable("DOCDBCONNSTR_DocDb");
            var cosmosDBConnectionString = new CosmosDBConnectionString(connectionString);

            using (var client = new DocumentClient(cosmosDBConnectionString.ServiceEndpoint, cosmosDBConnectionString.AuthKey))
            {
                var feedOptions = new FeedOptions { MaxItemCount = -1 };
                var documents = client.CreateDocumentQuery<Sample>(UriFactory.CreateDocumentCollectionUri("ToDoList", "Items"), feedOptions);

                foreach (var document in documents)
                {
                    log.LogInformation($"{document.Id} - {document.Content}");
                }
            }
            var environment = Environment.GetEnvironmentVariable("IAC_ENVIRONMENT");
            var response = $"{environment} - {Environment.MachineName}";
            return new OkObjectResult(response);
        }
    }
}
