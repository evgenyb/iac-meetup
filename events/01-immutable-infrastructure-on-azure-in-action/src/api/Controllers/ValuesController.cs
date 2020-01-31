using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using api.CosmosClients;

namespace api.Controllers
{
    public class ValuesController : ApiController
    {
        private readonly CosmosDbClient _cosmosClient;

        public ValuesController()
        {
            var connectionString = Environment.GetEnvironmentVariable("DOCDBCONNSTR_DocDb");
            var cosmosDBConnectionString = new CosmosDBConnectionString(connectionString);
            _cosmosClient = new CosmosDbClient(
                cosmosDBConnectionString.ServiceEndpoint,
                cosmosDBConnectionString.AuthKey);
        }

        // GET api/values
        public async Task<IEnumerable<Sample>> Get()
        {
            var samples = await _cosmosClient.GetSamplesAsync();
            return samples;
        } 
        
        [HttpPost]
        public async Task<IHttpActionResult> Post()
        {
            var guid = Guid.NewGuid();
            var sample = new Sample()
            {
                Id = guid.ToString(),
                Content = $"Foobar-{guid}"
            };
            await _cosmosClient.SaveSampleAsync(sample);
            
            return Ok();
        }

        // GET api/values/5
        public string Get(int id)
        {
            return "value";
        }
    }
}
