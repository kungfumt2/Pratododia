using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Avaliacao
    {
        public int IdCliente { get; set; }

        public int IdProp { get; set; }

        public DateTime DataAvaliacao { get; set; }

        public string Comentario { get; set; }

        public int AvaliacaoP { get; set; }

        public Avaliacao()
        {
            IdCliente = 0;
            IdProp = 0;
            DataAvaliacao = new DateTime();
            Comentario = string.Empty;
            AvaliacaoP = 0;
        }

        public Avaliacao ReadItem(SqlDataReader reader)
        {
            Avaliacao item = new Avaliacao();

            item.IdCliente = Convert.ToInt32(reader["IdCliente"]);
            item.IdProp = Convert.ToInt32(reader["IdProp"]);
            item.DataAvaliacao = Convert.ToDateTime(reader["DataAvaliacao"]);
            item.Comentario = Convert.ToString(reader["Comentario"]);
            item.AvaliacaoP = Convert.ToInt32(reader["Avaliacao"]);

            return item;
        }

        public void WriteItem(SqlCommand cmd, Avaliacao ava)
        {
            cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = ava.IdCliente;
            cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = ava.IdProp;
            cmd.Parameters.Add("@da", System.Data.SqlDbType.DateTime2).Value = ava.DataAvaliacao;
            cmd.Parameters.Add("@comment", System.Data.SqlDbType.VarChar).Value = ava.Comentario;
            cmd.Parameters.Add("@ava", System.Data.SqlDbType.Int).Value = ava.AvaliacaoP;

        }

        public List<Avaliacao> GetAvaliacoes(string strc, int idc, int idp)
        {
            List<Avaliacao> lista = new List<Avaliacao>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetAvaliacao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;
                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Avaliacao av = new Avaliacao();

                        av = ReadItem(reader);

                        lista.Add(av);

                    }

                    con.Close();
                }
            }

            return lista;
        }

        public void CreateAvaliacao(string strc, Avaliacao ava)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateAvaliacao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, ava);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void DeleteAvaliacao(string strc, int Idc, int IdP, DateTime DA)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_DeleteAvaliacao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }
}