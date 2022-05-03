using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("[controller]")]
public class HomeController : ControllerBase
{
    private IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Get()
        => Ok(new {
            Message = _configuration["Message"],
            Secret = _configuration["TEST_SECRET"]
        });
}