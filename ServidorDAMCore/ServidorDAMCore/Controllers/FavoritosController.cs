using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
    public class FavoritosController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public FavoritosController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Favoritos
        [HttpGet]
        public ActionResult Get()
        {
            return BadRequest();
        }

        // GET: api/Favoritos/5
        [HttpGet("{idc}/{idp}")]
        public ActionResult Get(int idc, int idp)
        {
            try
            {
                Favoritos fav = new Favoritos();

                return Ok(fav.GetFavoritos(configuration.GetConnectionString("CSCliente"),idc,idp).ToList());
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Favoritos
        [HttpPost]
        public ActionResult Post([FromBody] Favoritos fav)
        {
            try
            {

                fav.CreateFavoritos(configuration.GetConnectionString("CSCliente"), fav);

               
                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/Favoritos/5
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
