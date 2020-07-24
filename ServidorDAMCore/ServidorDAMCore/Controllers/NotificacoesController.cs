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
    public class NotificacoesController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public NotificacoesController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }
        // GET: api/Notificacoes
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                Notificacoes not = new Notificacoes();

                return Ok(not.GetNotificacoes(configuration.GetConnectionString("CSProprietario"),0,0).ToList());
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // GET: api/Notificacoes/5
        [HttpGet("{idc}/{idp}")]
        public ActionResult Get(int idc, int idp)
        {
            try
            {
                Notificacoes not = new Notificacoes();

                return Ok(not.GetNotificacoes(configuration.GetConnectionString("CSProprietario"),idc, idp).ToList());
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Notificacoes
        [HttpPost]
        public ActionResult Post([FromBody] Notificacoes value)
        {
            try
            {
                Notificacoes not = new Notificacoes();

                not.CreateNotificacao(configuration.GetConnectionString("CSProprietario"), value);

                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/Notificacoes/5
        [HttpPut("{id}")]
        public ActionResult Put(int idc, [FromBody] int idp)
        {
            try
            {
                Notificacoes not = new Notificacoes();

                not.UpdateNotificacoes(configuration.GetConnectionString("CSCliente"), idc, idp);

                return Ok();
            }
            catch (Exception e)
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
