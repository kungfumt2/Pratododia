using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Prato
    {
        public int Id { get; set; }

        public string Nome { get; set; }

        public string Descricao { get; set; }

        public string Tipo { get; set; }

        public string Refeicao { get; set; }

        public DateTime DataR { get; set; }

        public float Preco { get; set; }

        public byte[] Fotografia { get; set; }

        public int IdProp { get; set; }

        public Prato()
        {
            Id = 0;
            Nome = string.Empty;
            Descricao = string.Empty;
            Tipo = string.Empty;
            Refeicao = string.Empty;
            DataR = new DateTime();
            Preco = 0.00f;
            Fotografia = null;
            IdProp = 0;

        }

        private Prato ReadItem(SqlDataReader reader)
        {
            Prato prato = new Prato();

            prato.Id = Convert.ToInt32(reader["Id"]);
            prato.Nome = Convert.ToString(reader["Nome"]);
            prato.Descricao = Convert.ToString(reader["Descricao"]);
            prato.Tipo = Convert.ToString(reader["Tipo"]);
            prato.Refeicao = Convert.ToString(reader["Refeicao"]);
            prato.Preco = Convert.ToSingle(reader["Preco"]);
            prato.DataR = Convert.ToDateTime(reader["DataR"]);
            prato.Fotografia = (byte[]) reader["Fotografia"];
            prato.IdProp = Convert.ToInt32(reader["IdProp"]);

            return prato;
        }

        private void WriteItem(SqlCommand cmd, Prato prato)
        {
            cmd.Parameters.Add("@name", System.Data.SqlDbType.VarChar).Value = prato.Nome;
            cmd.Parameters.Add("@dsc", System.Data.SqlDbType.VarChar).Value = prato.Descricao;
            cmd.Parameters.Add("@type", System.Data.SqlDbType.VarChar).Value = prato.Tipo;
            cmd.Parameters.Add("@ref", System.Data.SqlDbType.VarChar).Value = prato.Refeicao;
            cmd.Parameters.Add("@dater", System.Data.SqlDbType.DateTime2).Value = prato.DataR;
            cmd.Parameters.Add("@price", System.Data.SqlDbType.Money).Value = prato.Preco;
            cmd.Parameters.Add("@photo", System.Data.SqlDbType.VarBinary).Value = prato.Fotografia;
            cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = prato.IdProp;

        }

        public List<Prato> GetPratos(string strc, int id, string type, string refe, DateTime datar, int idp, string what)
        {
            List<Prato> lista = new List<Prato>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetPrato";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;


                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;
                    cmd.Parameters.Add("@type", System.Data.SqlDbType.VarChar).Value = type;
                    cmd.Parameters.Add("@ref", System.Data.SqlDbType.VarChar).Value = refe;
                    cmd.Parameters.Add("@datar", System.Data.SqlDbType.DateTime2).Value = datar;
                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;
                    cmd.Parameters.Add("@what", System.Data.SqlDbType.VarChar).Value = what;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Prato p = new Prato();

                        p = ReadItem(reader);

                        lista.Add(p);
                    }
                }
            }
            return lista;
        }

        public void CreatePrato(string strc, Prato p)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreatePrato";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, p);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void UpdatePrato(string stc, string what, DateTime DR, float price, byte[] photo, int id, string value)
        {
            using (SqlConnection con = new SqlConnection(stc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_UpdatePrato";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@what", System.Data.SqlDbType.VarChar).Value = what;
                    cmd.Parameters.Add("@DR", System.Data.SqlDbType.DateTime2).Value = DR;
                    cmd.Parameters.Add("@price", System.Data.SqlDbType.Money).Value = price;
                    cmd.Parameters.Add("@photo", System.Data.SqlDbType.VarBinary).Value = photo;
                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = id;
                    cmd.Parameters.Add("@value", System.Data.SqlDbType.VarChar).Value = value;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }
}