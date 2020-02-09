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
       // private readonly ILogger<ValuesController> _logger;

        //public ValuesController(CosmosDbClient cosmosClient, ILogger<ValuesController> logger)
        public ValuesController(CosmosDbClient cosmosClient)
        {
            _cosmosClient = cosmosClient;
            //_logger = logger;
        }

        // GET api/values
        [HttpGet]
        public async Task<string> Get()
        {
            var samples = await _cosmosClient.GetSamplesAsync();
            var response = $"{Environment.MachineName}: fetched documents. OK.";
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
