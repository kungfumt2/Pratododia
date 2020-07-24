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
    public class PreferenciaController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public PreferenciaController(IConfiguration cofig)
        {
            this.configuration = cofig;
        }

        // GET: api/Preferencia
        [HttpGet]
        public ActionResult Get()
        {
            return BadRequest();
        }

        // GET: api/Preferencia/5
        [HttpGet("{idc}/{idt}")]
        public ActionResult Get(int idc,int idt)
        {
            try
            {
                Dictionary<int, int> dic = new Dictionary<int, int>();

                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSCliente"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_GetPreferencia";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = idt;
                cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while(reader.Read())
                {
                    dic.Add(Convert.ToInt32(reader["IdT"]), Convert.ToInt32(reader["IdC"]));
                }

                con.Close();


                return Ok(dic);
            }
            catch(Exception e)
            {
                return BadRequest();
            }
        }

        // POST: api/Preferencia
        [HttpPost]
        public ActionResult Post([FromBody] string value)
        {
            try
            {
                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSCliente"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_CreatePreferencia";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = Convert.ToInt32(value.Split('|')[0]);
                cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = Convert.ToInt32(value.Split('|')[1]);
                cmd.Parameters.Add("@dadd", System.Data.SqlDbType.DateTime2).Value = Convert.ToDateTime(value.Split('|')[2]);

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

        // PUT: api/Preferencia/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult Delete(int id,[FromBody] string value)
        {
            try
            {
                SqlConnection con = new SqlConnection(configuration.GetConnectionString("CSCliente"));

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "stp_DeletePreferencia";
                cmd.Connection = con;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = Convert.ToInt32(value.Split('|')[0]);
                cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = Convert.ToInt32(value.Split('|')[1]);
                cmd.Parameters.Add("@DA", System.Data.SqlDbType.DateTime2).Value = Convert.ToDateTime(value.Split('|')[2]);

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
