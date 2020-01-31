using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.Documents.Linq;

namespace api.CosmosClients
{
    public class CosmosDbClient
    {
        private readonly string _databaseId;
        private readonly DocumentClient _client;

        public CosmosDbClient(Uri endpointUri, string primaryKey)
        {
            _databaseId = "ToDoList";
            _client = new DocumentClient(endpointUri, primaryKey);
        }

        public async Task SaveSampleAsync(Sample sample)
        {
            var documentCollectionUri = UriFactory.CreateDocumentCollectionUri(_databaseId, "Items");
            await _client.UpsertDocumentAsync(documentCollectionUri, sample);
        }

        public async Task<List<Sample>> GetSamplesAsync()
        {
            var documentCollectionUri = UriFactory.CreateDocumentCollectionUri(_databaseId, "Items");

            // build the query
            var feedOptions = new FeedOptions() { MaxItemCount = -1 };
            var query = _client.CreateDocumentQuery<Sample>(documentCollectionUri, "SELECT TOP 100 * FROM Sample", feedOptions);
            var queryAll = query.AsDocumentQuery();

            // combine the results
            var results = new List<Sample>();
            while (queryAll.HasMoreResults)
            {
                results.AddRange(await queryAll.ExecuteNextAsync<Sample>());
            }

            return results;
        }
    }
}