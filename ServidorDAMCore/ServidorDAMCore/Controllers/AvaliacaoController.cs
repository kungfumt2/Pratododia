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
    public class AvaliacaoController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public AvaliacaoController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Avaliacao
        [HttpGet]
        public ActionResult Get()
        {
            return BadRequest();
        }

        // GET: api/Avaliacao/5
        [HttpGet("{idc}/{idp}")]
        public ActionResult Get(int idc, int idp)
        {
            try
            {
                Avaliacao ava = new Avaliacao();

                return Ok(ava.GetAvaliacoes(configuration.GetConnectionString("CSCliente"), idc, idp).ToList());

            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Avaliacao
        [HttpPost]
        public ActionResult Post([FromBody] Avaliacao value)
        {
            try
            {
                Avaliacao ava = new Avaliacao();

                ava.CreateAvaliacao(configuration.GetConnectionString("CSCliente"), value);

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/Avaliacao/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {

        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult Delete(int id,[FromBody] string value)
        {

            try
            {
                Avaliacao ava = new Avaliacao();

                ava.DeleteAvaliacao(configuration.GetConnectionString("CSCliente"), Convert.ToInt32(value.Split('|')[0]), Convert.ToInt32(value.Split('|')[1]), Convert.ToDateTime(value.Split('|')[2]));

                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }
    }
}
