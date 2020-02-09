using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : Controller
    {
        [HttpGet(Name = "alive")]
        [Route("[action]")]
        public IActionResult Alive()
        {
            return Ok("alive");
        } 
        
        [HttpGet(Name = "ready")]
        [Route("[action]")]
        public IActionResult Ready()
        {
            return Ok("ready");
        }
    }
}