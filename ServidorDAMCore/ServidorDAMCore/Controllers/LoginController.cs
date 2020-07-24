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
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public LoginController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }
        // GET: api/Login
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/Login/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Login
        [HttpPost]
        public ActionResult Post([FromBody] Login login)
        {

            try
            {
                Utilizador user = new Utilizador();
                Administrador administrador = new Administrador();

                if (user.GetUtilizadores(configuration.GetConnectionString("CSAnonimo"), 0).Where(x => x.Username == login.username).Count() != 0)
                {
                    user = user.GetUtilizadores(configuration.GetConnectionString("CSAnonimo"), 0).Where(x => x.Username == login.username).FirstOrDefault();

                    if (user.Password.Equals(login.password))
                    {
                        HttpContext.Session.SetString("User", user.Id.ToString());

                        Cliente cliente = new Cliente();
                        Proprietario prop = new Proprietario();


                        if (cliente.GetClientes(configuration.GetConnectionString("CSCliente"), user.Id).Count() != 0)
                        {
                            HttpContext.Session.SetString("Role", "Cliente");
                        }
                        else if (prop.GetProprietarios(configuration.GetConnectionString("CSCliente"), user.Id, "").Count() != 0)
                        {
                            HttpContext.Session.SetString("Role", "Proprietario");
                        }
                    }
                    else if (administrador.GetAdministradores(configuration.GetConnectionString("CSCAdministrador"), login.username).Count() != 0)
                    {
                        if(administrador.GetAdministradores(configuration.GetConnectionString("CSCAdministrador"), login.username).First().Password == login.password)
                        HttpContext.Session.SetString("Role", "Administrador");
                    }
                    else
                    {
                        return BadRequest();
                    }
                }                

                return Ok();
            }
            catch(Exception e)
            {
               

                return BadRequest();
            }
        }

        // PUT: api/Login/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
