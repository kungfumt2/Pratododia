using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Notificacoes
    {
        public string Titulo { get; set; }

        public DateTime DataNotificacao { get; set; }

        public int IdC { get; set; }

        public int IdP { get; set; }

        public string Mensagem { get; set; }

        public bool Visto { get; set; }



        public Notificacoes()
        {
            Titulo = string.Empty;
            DataNotificacao = new DateTime();
            IdC = 0;
            IdP = 0;
            Mensagem = string.Empty;
            Visto = false;
        }

        private Notificacoes ReadItem(SqlDataReader reader)
        {
            Notificacoes item = new Notificacoes();

            item.Titulo = Convert.ToString(reader["Titulo"]);
            item.DataNotificacao = Convert.ToDateTime(reader["DataNotificacao"]);
            item.IdC = Convert.ToInt32(reader["IdC"]);
            item.IdP = Convert.ToInt32(reader["IdP"]);
            item.Mensagem = Convert.ToString(reader["Mensagem"]);
            item.Visto = Convert.ToBoolean(reader["Visto"]);

            return item;
        }

        private void WriteItem(SqlCommand cmd, Notificacoes not)
        {
            cmd.Parameters.Add("@title", System.Data.SqlDbType.VarChar).Value = not.Titulo;
            cmd.Parameters.Add("@DN", System.Data.SqlDbType.DateTime2).Value = not.DataNotificacao;
            cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = not.IdC;
            cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = not.IdP;
            cmd.Parameters.Add("@message", System.Data.SqlDbType.VarChar).Value = not.Mensagem;
            cmd.Parameters.Add("@visto", System.Data.SqlDbType.Bit).Value = not.Visto;

        }

        public List<Notificacoes> GetNotificacoes(string strc, int idc, int idp)
        {
            List<Notificacoes> lista = new List<Notificacoes>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetNotificacoes";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;
                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Notificacoes not = new Notificacoes();

                        not = ReadItem(reader);

                        lista.Add(not);
                    }

                    con.Close();
                }
            }

            return lista;
        }

        public void CreateNotificacao(string strc, Notificacoes not)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateNotificacao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, not);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void UpdateNotificacoes(string strc, int idc, int idp)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_UpdateNotificacoes";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;
                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }

    
}