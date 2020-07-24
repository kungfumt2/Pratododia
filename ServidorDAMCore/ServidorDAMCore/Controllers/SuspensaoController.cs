using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ServidorDAMCore.Models;

namespace ServidorDAMCore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SuspensaoController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public SuspensaoController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Suspensao
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                Suspensao susp = new Suspensao();

                return Ok(susp.GetSuspensao(configuration.GetConnectionString("CSAdministrador"), 0, 0).ToList());

            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // GET: api/Suspensao/5
        [HttpGet("{ida}/{idu}")]
        public ActionResult Get(int ida,int idu)
        {
            try
            {
                Suspensao susp = new Suspensao();

                return Ok(susp.GetSuspensao(configuration.GetConnectionString("CSAdministrador"),ida, idu).ToList());

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Suspensao
        [HttpPost]
        public ActionResult Post([FromBody] Suspensao value)
        {
            try
            {
                Suspensao susp = new Suspensao();

                susp.CreateSuspensao(configuration.GetConnectionString("CSAdministrador"),value);

                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/Suspensao/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult Delete(int idu,[FromBody] string values)
        {
            try
            {
                Suspensao susp = new Suspensao();

                susp.DeleteSuspensao(configuration.GetConnectionString("CSAdministrador"),Convert.ToInt32(values.Split('|')[0]),idu, Convert.ToDateTime(values.Split('|')[1]));

                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }
    }
}
