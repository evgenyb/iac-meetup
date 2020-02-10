using Newtonsoft.Json;

namespace api_func.CosmosClients
{
    public class Sample
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        public string Content { get; set; }
    }
}