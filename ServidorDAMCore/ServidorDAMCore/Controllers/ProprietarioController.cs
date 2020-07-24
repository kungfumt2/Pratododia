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
    public class ProprietarioController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public ProprietarioController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Proprietario
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                Proprietario prop = new Proprietario();

                List<Proprietario> proplist = prop.GetProprietarios(configuration.GetConnectionString("CSAdministrador"), 0, "").ToList();

                return Ok(proplist);
            }
            catch (Exception E)
            {
                return BadRequest();
            }
        }

        // GET: api/Proprietario/5
        [HttpGet("{id}/{name}")]
        public ActionResult Get(int id,string name)
        {
            try
            {
                Proprietario prop = new Proprietario();

                prop = prop.GetProprietarios(configuration.GetConnectionString("CSAdministrador"), id, name).FirstOrDefault();

                return Ok(prop);
            }
            catch(Exception ex)
            {
                return BadRequest();
            }
        }

        // POST: api/Proprietario
        [HttpPost]
        public ActionResult Post([FromBody] Proprietario value)
        {
           

            try
            {
                Proprietario prop = value;

                prop.CreateProprietario(configuration.GetConnectionString("CSAnonimo"), prop);


                return Ok();
            }
            catch(Exception e)
            {
                

                return BadRequest();
            }
        }

        // PUT: api/Proprietario/5
        [HttpPut("{id}")]
        public ActionResult Put(int id, [FromBody] string value)
        {
            

            try
            {

                Proprietario prop = new Proprietario();

                if (value.Split('|')[3].Equals("NO"))
                {
                    prop.UpdateProprietario(configuration.GetConnectionString("CSAnonimo"), value.Split('|')[0], Convert.ToInt32(value.Split('|')[1]), value.Split('|')[2], id);

                   

                    return Ok();
                }

                else
                {
                    prop.GoPremium(configuration.GetConnectionString("CSProproietario"), id);

                   

                    return Ok();
                }

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
