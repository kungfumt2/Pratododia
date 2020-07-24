using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Favoritos
    {
        public int IdCliente { get; set; }

        public int IdProp { get; set; }

        public DateTime DataAdd { get; set; }

        public Favoritos()
        {
            IdCliente = 0;
            IdProp = 0;
            DataAdd = new DateTime();
        }

        private Favoritos ReadItem(SqlDataReader reader)
        {
            Favoritos item = new Favoritos();

            item.IdCliente = Convert.ToInt32(reader["IdCliente"]);
            item.IdProp = Convert.ToInt32(reader["IdProp"]);
            item.DataAdd = Convert.ToDateTime(reader["DataAdd"]);

            return item;
        }

        private void WriteItem(SqlCommand cmd, Favoritos fav)
        {
            cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = fav.IdCliente;
            cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = fav.IdProp;
            cmd.Parameters.Add("@da", System.Data.SqlDbType.DateTime2).Value = fav.DataAdd;
        }

        public List<Favoritos> GetFavoritos(string strc, int idc, int idp)
        {
            List<Favoritos> lista = new List<Favoritos>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetFavoritos";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = idc;
                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Favoritos fav = new Favoritos();

                        fav = ReadItem(reader);

                        lista.Add(fav);
                    }
                }
            }

            return lista;
        }

        public void CreateFavoritos(string strc, Favoritos fav)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateFavoritos";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = fav.IdProp;
                    cmd.Parameters.Add("@idc", System.Data.SqlDbType.Int).Value = fav.IdCliente;
                    cmd.Parameters.Add("@da", System.Data.SqlDbType.DateTime2).Value = fav.DataAdd;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }
    }
}