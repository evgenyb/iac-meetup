using System;
using System.Threading.Tasks;
using api.CosmosClients;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    
    public class ValuesController : Controller
    {
        private readonly CosmosDbClient _cosmosClient;
        public ValuesController(CosmosDbClient cosmosClient)
        {
            _cosmosClient = cosmosClient;
        }

        // GET api/values
        [HttpGet]
        public async Task<string> Get()
        {
            var samples = await _cosmosClient.GetSamplesAsync();
            var environment = Environment.GetEnvironmentVariable("IAC_ENVIRONMENT");
            var response = $"{environment} - {Environment.MachineName}";
            return response;
        } 
        
        [HttpPost]
        public async Task<IActionResult> Post()
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
    }
}
