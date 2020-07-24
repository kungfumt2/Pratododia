using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace ServidorDAMCore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TipoDeComidaController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public TipoDeComidaController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }
        // GET: api/TipoDeComida
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                List<string> lista = new List<string>();

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSAdministrador"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_GetTipoDeComida";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = 0;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while(reader.Read())
                {
                    lista.Add(Convert.ToString(reader["Tipo"]));

                }

                con.Close();



              return Ok(lista);
            }
            catch(Exception e)
            {
                return BadRequest();
            }
            
        }

        // GET: api/TipoDeComida/5
        [HttpGet("{id}")]
        public ActionResult Get(int id)
        {
            try
            {
                string type = "";

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSAdministrador"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_GetTipoDeComida";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = id;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    if(Convert.ToInt32(reader["Id"]).Equals(id))
                    {
                        type = Convert.ToString(reader["Tipo"]);
                    }
                    
                }

                con.Close();

                return Ok(type);
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/TipoDeComida
        [HttpPost]
        public ActionResult Post([FromBody] string type)
        {
            try
            {
                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSAdministrador"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_CreateTipoDeComida";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@type", System.Data.SqlDbType.VarChar).Value = type;

                con.Open();

                cmd.ExecuteNonQuery();

                con.Close();

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest();
            }

        }

        // PUT: api/TipoDeComida/5
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
                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSAdministrador"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_DeleteTipoDeComida";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@id", System.Data.SqlDbType.VarChar).Value = id;

                con.Open();

                cmd.ExecuteNonQuery();

                con.Close();

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }
    }
}
