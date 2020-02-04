using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : Controller
    {
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return Ok("Ok");
        }
    }
}