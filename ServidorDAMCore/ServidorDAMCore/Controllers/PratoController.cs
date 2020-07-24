using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ServidorDAMCore.Models;

namespace ServidorDAMCore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PratoController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public PratoController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Prato
        [HttpGet]
        public ActionResult Get()
        {
            return BadRequest();
        }

        // GET: api/Prato/5
        [HttpGet("{id}/{values}")]
        public ActionResult Get(int id,string values)
        {
            try
            {
                Prato prato = new Prato();

              
                return Ok(prato.GetPratos(configuration.GetConnectionString("CSProprietario"), id, values.Split('|')[0], values.Split('|')[1], Convert.ToDateTime(values.Split('|')[2]), Convert.ToInt32(values.Split('|')[3]), values.Split('|')[4]).ToList());
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Prato
        [HttpPost]
        public ActionResult Post([FromBody] Prato value)
        {
            try
            {
                Prato prato = new Prato();

                prato.CreatePrato(configuration.GetConnectionString("CSProprietario"), value);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/Prato/5
        [HttpPut("{id}")]
        public ActionResult Put(int id, [FromBody] string value)
        {
            try
            {
                Prato prato = new Prato();

                byte[] conversion = Encoding.ASCII.GetBytes(value.Split('|')[3]);

                prato.UpdatePrato(configuration.GetConnectionString("CSProprietario"), value.Split('|')[0], Convert.ToDateTime(value.Split('|')[1]), Convert.ToSingle(value.Split('|')[2]), conversion, Convert.ToInt32(value.Split('|')[4]), value.Split('|')[5]);

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
