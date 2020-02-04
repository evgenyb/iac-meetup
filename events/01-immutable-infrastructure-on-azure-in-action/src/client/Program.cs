using System;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;

namespace client
{
    class Program
    {
        static readonly HttpClient client = new HttpClient();
        static TelemetryConfiguration configuration = TelemetryConfiguration.CreateDefault();

        static async Task Main()
        {
            configuration.InstrumentationKey = "a6b2e925-97b5-445f-942a-4bdb9f125c32";
            var telemetryClient = new TelemetryClient(configuration);
            try
            {
                telemetryClient.TrackTrace("Calling http://iac-dev-api-appservice.azurewebsites.net/values",
                    SeverityLevel.Information);
                var response = await client.GetAsync("http://iac-dev-api-appservice.azurewebsites.net/values");
                response.EnsureSuccessStatusCode();
                var responseBody = await response.Content.ReadAsStringAsync();
                Console.WriteLine(responseBody);
            }
            catch (HttpRequestException e)
            {
                telemetryClient.TrackException(e);
                Console.WriteLine("\nException Caught!");
                Console.WriteLine("Message :{0} ", e.Message);
            }
            finally
            {
                telemetryClient.Flush();
            }
        }
    }
}
