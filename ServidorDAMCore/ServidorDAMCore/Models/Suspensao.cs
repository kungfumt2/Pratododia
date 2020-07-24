using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Suspensao
    {
        public DateTime DataDeSuspensao { get; set; }

        public int IdA { get; set; }

        public int IdU { get; set; }

        public int Tempo { get; set; }

        public string Motivo { get; set; }



        public Suspensao()
        {
            DataDeSuspensao = new DateTime();
            IdA = 0;
            IdU = 0;
            Tempo = 0;
            Motivo = string.Empty;
        }

        public Suspensao ReadItem(SqlDataReader reader)
        {
            Suspensao susp = new Suspensao();

            susp.DataDeSuspensao = Convert.ToDateTime(reader["DataDeSuspensao"]);
            susp.IdA = Convert.ToInt32(reader["IdA"]);
            susp.IdU = Convert.ToInt32(reader["IdU"]);
            susp.Tempo = Convert.ToInt32(reader["Tempo"]);
            susp.Motivo = Convert.ToString(reader["Motivo"]);

            return susp;
        }

        public void WriteItem(SqlCommand cmd, Suspensao susp)
        {
            cmd.Parameters.Add("@DS", System.Data.SqlDbType.DateTime2).Value = susp.DataDeSuspensao;
            cmd.Parameters.Add("@ida", System.Data.SqlDbType.Int).Value = susp.IdA;
            cmd.Parameters.Add("@idu", System.Data.SqlDbType.Int).Value = susp.IdU;
            cmd.Parameters.Add("@time", System.Data.SqlDbType.Int).Value = susp.Tempo;
            cmd.Parameters.Add("@motive", System.Data.SqlDbType.VarChar).Value = susp.Motivo;

        }

        public List<Suspensao> GetSuspensao(string strc, int ida, int idu)
        {
            List<Suspensao> lista = new List<Suspensao>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetSuspensao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ida", System.Data.SqlDbType.Int).Value = ida;
                    cmd.Parameters.Add("@idu", System.Data.SqlDbType.Int).Value = idu;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Suspensao suspensao = new Suspensao();

                        suspensao = ReadItem(reader);

                        lista.Add(suspensao);
                    }

                    con.Close();


                }
            }

            return lista;
        }

        public void DeleteSuspensao(string strc, int ida, int idu, DateTime DS)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_DeleteSuspensao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ida", System.Data.SqlDbType.Int).Value = ida;
                    cmd.Parameters.Add("@idu", System.Data.SqlDbType.Int).Value = idu;
                    cmd.Parameters.Add("@DS", System.Data.SqlDbType.DateTime2).Value = DS;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();


                }
            }
        }

        public void CreateSuspensao(string strc, Suspensao susp)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateSuspensao";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, susp);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    
    }
}