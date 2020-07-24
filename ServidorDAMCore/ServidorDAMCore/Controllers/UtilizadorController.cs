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
    public class UtilizadorController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public UtilizadorController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }


        // GET: api/Utilizador
        [HttpGet]
        public ActionResult Get()
        {
         

            Utilizador user = new Utilizador();

            try
            {
                return Ok(user.GetUtilizadores(configuration.GetConnectionString("CSAdministrador"), 0).ToList());
            }

            catch (Exception e)
            {
                
                return BadRequest();
            }
        }

        // GET: api/Utilizador/5
        [HttpGet("{id}/{role}")]
        public ActionResult Get(int id,string role)
        {
            Utilizador user = new Utilizador();

            if (role.Equals("Cliente"))
            {
                user = user.GetUtilizadores(configuration.GetConnectionString("CSCliente"), id).ToList().FirstOrDefault();
            }
            else
            {
                user = user.GetUtilizadores(configuration.GetConnectionString("CSProprietario"), id).ToList().FirstOrDefault();
            }

            return Ok(user);
        }

        // POST: api/Utilizador
        [HttpPost]
        public ActionResult Post([FromBody] Utilizador user)
        {
           
            try
            {
                user.CreateUtilizador(configuration.GetConnectionString("CSAdministrador"), user);              

                return Ok();
            }
            catch(Exception e)
            {
                
                return BadRequest();
            }

            
        }

        // PUT: api/Utilizador/5
        [HttpPut("{id}")]
        public ActionResult Put(int id, [FromBody] string values)
        {
           
            Utilizador user = new Utilizador();

            try
            {
                if (values.Split('|')[0].Equals("Cliente"))
                    user.UpdateUtilizador(configuration.GetConnectionString("CSCliente"), values.Split('|')[0], values.Split('|')[1], id);
                else
                    user.UpdateUtilizador(configuration.GetConnectionString("CSProprietario"), values.Split('|')[0], values.Split('|')[1], id);

               

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
