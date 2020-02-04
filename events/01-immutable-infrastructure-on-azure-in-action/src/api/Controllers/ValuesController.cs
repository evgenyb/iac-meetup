using System;
using System.Collections.Generic;
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
        public async Task<IEnumerable<Sample>> Get()
        {
            var samples = await _cosmosClient.GetSamplesAsync();
            return samples;
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
