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
    public class RelTipoController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public RelTipoController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }
        // GET: api/RelTipo
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                Dictionary<int, int> dic = new Dictionary<int, int>();

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSProprietario"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_GetRelTipo";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = 0;
                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = 0;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    dic.Add(Convert.ToInt32(reader["IdP"]),Convert.ToInt32(reader["IdT"]));
                    

                }

                con.Close();



                return Ok(dic);
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // GET: api/RelTipo/5
        [HttpGet("{idp}/{idt}")]
        public ActionResult Get(int idp,int idt)
        {
            try
            {
                Dictionary<int, int> dic = new Dictionary<int, int>();

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSProprietario"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_GetRelTipo";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;
                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = idt;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    dic.Add(Convert.ToInt32(reader["IdP"]), Convert.ToInt32(reader["IdT"]));


                }

                con.Close();



                return Ok(dic);
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/RelTipo
        [HttpPost]
        public ActionResult Post([FromBody] string values)
        {
            try
            {

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSProprietario"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_CreateRelTipo";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = Convert.ToInt32(values[0]);
                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = Convert.ToInt32(values[1]);

                con.Open();

                cmd.ExecuteNonQuery();

                con.Close();

                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        // PUT: api/RelTipo/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult Delete(int id, [FromBody] int idp)
        {
            try
            {

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSProprietario"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_DeleteRelTipo";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;
                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = id;

                con.Open();

                cmd.ExecuteNonQuery();

                con.Close();

                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }
    }
}
