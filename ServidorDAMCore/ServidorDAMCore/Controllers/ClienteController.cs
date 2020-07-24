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
    public class ClienteController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public ClienteController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Cliente
        [HttpGet]
        public ActionResult Get()
        {
            Cliente cliente = new Cliente();
            Utilizador user = new Utilizador();


            List<Utilizador> lista = new List<Utilizador>();

            try
            {
                foreach(Utilizador a in user.GetUtilizadores(configuration.GetConnectionString("CDAdministrador"), 0))
                {
                    if(cliente.GetClientes(configuration.GetConnectionString("CDAdministrador"),0).Where(x=>x.IdUser == a.Id).Count() != 0)
                    {
                        lista.Add(a);
                    }
                }

                return Ok(lista);
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // GET: api/Cliente/5
        [HttpGet("{id}")]
        public ActionResult Get(int id)
        {
            try
            {
                Utilizador user = new Utilizador();

                user = user.GetUtilizadores(configuration.GetConnectionString("CDAdministrador"), id).First();

                return Ok(user);

            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Cliente
        [HttpPost]
        public ActionResult Post([FromBody] Cliente value)
        {
            

            try
            {
                Cliente cliente = new Cliente();

                cliente.CreateCliente(configuration.GetConnectionString("CDAnonimo"), value);

               

                return Ok();
            }
            catch(Exception e)
            {
                
                return BadRequest();
            }
        }

        // PUT: api/Cliente/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {

        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult Delete(int id)
        {

            try
            {
                Cliente cliente = new Cliente();

                cliente.DeleteCliente(configuration.GetConnectionString("CSAdministrador"), id);               

                return Ok();
            }
            catch(Exception e)
            {
                
                return BadRequest();
            }
        }
    }
}
