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
    public class AdminActController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public AdminActController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/AdminAct
        [HttpGet]
        public ActionResult Get()
        {
            return BadRequest();
        }

        // GET: api/AdminAct/5
        [HttpGet("{usr}")]
        public ActionResult Get(string usr)
        {
            try
            {
                Administrador administrador = new Administrador();

                return Ok(administrador.GetAdministradores(configuration.GetConnectionString("CSAdministrador"), usr).ToList());
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/AdminAct
        [HttpPost]
        public ActionResult Post([FromBody] string value)
        {
            return Ok();
        }

        // PUT: api/AdminAct/5
        [HttpPut("{id}")]
        public ActionResult Put(int id, [FromBody] string value)
        {
            

            Utilizador user = new Utilizador();

            try
            {
                switch(value.Split('|')[0])
                {
                    case "Suspender":

                        user.SuspenderUtilizador(configuration.GetConnectionString("CSAdministrador"), id, value.Split('|')[1]);

                        break;

                    case "Recuperar":

                        user.RecuperarUtilizador(configuration.GetConnectionString("CSAdministrador"), id);

                        break;

                    case "Validar":

                        user.ValidarUtilizador(configuration.GetConnectionString("CSAdministrador"), id);
                        break;                 
                        
                }

                

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
