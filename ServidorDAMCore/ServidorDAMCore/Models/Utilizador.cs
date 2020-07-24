using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Utilizador
    {
        public int Id { get; set; }

        public string Username { get; set; }

        public string Nome { get; set; }

        public string Password { get; set; }

        public string Email { get; set; }

        public string Estado { get; set; }

        public DateTime DataAsesao { get; set; }


        public Utilizador()
        {
            Id = 0;
            Username = string.Empty;
            Nome = string.Empty;
            Password = string.Empty;
            Email = string.Empty;
            Estado = string.Empty;
            DataAsesao = new DateTime();
        }

        public Utilizador ReadItem(SqlDataReader reader)
        {
            Utilizador item = new Utilizador();

            item.Id = Convert.ToInt32(reader["Id"]);
            item.Username = Convert.ToString(reader["Username"]);
            item.Nome = Convert.ToString(reader["Nome"]);
            item.Password = Convert.ToString(reader["PW"]);
            item.Email = Convert.ToString(reader["Email"]);
            item.Estado = Convert.ToString(reader["Estado"]);
            item.DataAsesao = Convert.ToDateTime(reader["DataAsesao"]);


            return item;
        }

        public void WriteItem(SqlCommand cmd, Utilizador item)
        {
            cmd.Parameters.Add("@usern", System.Data.SqlDbType.VarChar).Value = item.Username;
            cmd.Parameters.Add("@name", System.Data.SqlDbType.VarChar).Value = item.Nome;
            cmd.Parameters.Add("@pw", System.Data.SqlDbType.VarChar).Value = item.Password;
            cmd.Parameters.Add("@email", System.Data.SqlDbType.VarChar).Value = item.Email;
            cmd.Parameters.Add("@state", System.Data.SqlDbType.VarChar).Value = item.Estado;
            cmd.Parameters.Add("@DA", System.Data.SqlDbType.DateTime2).Value = item.DataAsesao;
        }

        public List<Utilizador> GetUtilizadores(string strc, int id)
        {
            List<Utilizador> lista = new List<Utilizador>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetUilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", System.Data.SqlDbType.Int).Value = id;


                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Utilizador user = new Utilizador();

                        user = ReadItem(reader);

                        lista.Add(user);
                    }

                    con.Close();

                }
            }

            return lista;
        }

        public void CreateUtilizador(string strc, Utilizador item)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateUtilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, item);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();

                }
            }
        }

        public void UpdateUtilizador(string strc, string what, string value, int id)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_UpdateUtilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@what", System.Data.SqlDbType.VarChar).Value = what;
                    cmd.Parameters.Add("@value", System.Data.SqlDbType.VarChar).Value = value;
                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void SuspenderUtilizador(string strc, int id, string what)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_SuspenderUtilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;
                    cmd.Parameters.Add("@what", System.Data.SqlDbType.VarChar).Value = what;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void RecuperarUtilizador(string strc, int id)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_RecuperarUtilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void ValidarUtilizador(string strc, int id)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_ValidarUtilizador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }
}