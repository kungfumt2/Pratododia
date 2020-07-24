using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Cliente
    {
        public int IdUser { get; set; }

        public Cliente()
        {
            IdUser = 0;
        }

        public Cliente ReadItem(SqlDataReader reader)
        {
            Cliente cliente = new Cliente();

            cliente.IdUser = Convert.ToInt32(reader["IdUser"]);

            return cliente;
        }

        public void WriteItem(SqlCommand cmd, Cliente cliente)
        {
            cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = cliente.IdUser;


        }

        public List<Cliente> GetClientes(string strc, int idc)
        {
            List<Cliente> lista = new List<Cliente>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetCliente";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Cliente cliente = new Cliente();

                        cliente = ReadItem(reader);

                        lista.Add(cliente);
                    }

                    con.Close();
                }
            }

            return lista;
        }

        public void CreateCliente(string strc, Cliente cliente)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateCliente";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, cliente);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void DeleteCliente(string strc, int Idc)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_DeleteCliente";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@Idc", System.Data.SqlDbType.Int).Value = Idc;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();

                }
            }
        }
    }
}