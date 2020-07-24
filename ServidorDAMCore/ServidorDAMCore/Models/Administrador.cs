using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Administrador
    {
        public int Id { get; set; }

        public string Username { get; set; }

        public string Password { get; set; }

        public Administrador()
        {
            Id = 0;
            Username = string.Empty;
            Password = string.Empty;
        }

        public Administrador ReadItem(SqlDataReader reader)
        {
            Administrador admin = new Administrador();

            admin.Id = Convert.ToInt32(reader["Id"]);
            admin.Username = Convert.ToString(reader["Username"]);
            admin.Password = Convert.ToString(reader["PW"]);

            return admin;
        }

        public void WriteItem(SqlCommand cmd, Administrador admin)
        {
            cmd.Parameters.Add("@usern", System.Data.SqlDbType.VarChar).Value = admin.Username;
            cmd.Parameters.Add("@pw", System.Data.SqlDbType.VarChar).Value = admin.Password;


        }

        public List<Administrador> GetAdministradores(string strc, string usrn)
        {
            List<Administrador> administradores = new List<Administrador>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetAdministrador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@usrn", System.Data.SqlDbType.VarChar).Value = usrn;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Administrador admin = new Administrador();

                        admin = ReadItem(reader);

                        administradores.Add(admin);
                    }

                    con.Close();
                }
            }

            return administradores;
        }

        public void CreateAdministrador(string strc, Administrador admin)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateAdministrador";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, admin);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }
}