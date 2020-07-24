using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ServidorDAMCore.Models
{
    public class Proprietario
    {
        public int IdUser { get; set; }

        public string NomeRestaurante { get; set; }

        public int Avaliacao { get; set; }

        public List<string> TipoDeComida { get; set; }

        public List<double> Coordenadas { get; set; }

        public string Descricao { get; set; }

        public List<byte[]> Fotografias { get; set; }

        public bool Premium { get; set; }

        private readonly IConfiguration configuration;


        public Proprietario()
        {
            IdUser = 0;
            NomeRestaurante = string.Empty;
            Avaliacao = 0;
            TipoDeComida = new List<string>();
            Coordenadas = new List<double>();
            Descricao = string.Empty;
            Fotografias = new List<byte[]>();
            Premium = false;
        }

        public Proprietario ReadItem(SqlDataReader reader)
        {
            Proprietario item = new Proprietario();

            item.IdUser = Convert.ToInt32(reader["IdUser"]);
            item.NomeRestaurante = Convert.ToString(reader["NomeRestaurante"]);
            item.Avaliacao = Convert.ToInt32(reader["Avaliacao"]);
            item.TipoDeComida = GetTiposDeComida(configuration.GetConnectionString("CSProprietario"), item.IdUser, 0);
            item.Coordenadas = GetCoordenadas(configuration.GetConnectionString("CSProprietario"), item.IdUser);
            item.Descricao = Convert.ToString(reader["Descricao"]);
            item.Fotografias = GetFotografiasR(configuration.GetConnectionString("CSProprietario"), item.IdUser);
            item.Premium = Convert.ToBoolean(reader["Premium"]);

            return item;
        }

        public void WriteItem(SqlCommand cmd, Proprietario prop)
        {
            cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = prop.IdUser;
            cmd.Parameters.Add("@NR", System.Data.SqlDbType.VarChar).Value = prop.NomeRestaurante;
            cmd.Parameters.Add("@ava", System.Data.SqlDbType.Int).Value = prop.Avaliacao;
            cmd.Parameters.Add("@dsc", System.Data.SqlDbType.VarChar).Value = prop.Descricao;
            cmd.Parameters.Add("@pre", System.Data.SqlDbType.Bit).Value = prop.Premium;

        }

        public List<Proprietario> GetProprietarios(string strc, int idp, string name)
        {
            List<Proprietario> lista = new List<Proprietario>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetProprietario";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;
                    cmd.Parameters.Add("@name", System.Data.SqlDbType.VarChar).Value = name;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        Proprietario prop = new Proprietario();

                        prop = ReadItem(reader);

                        lista.Add(prop);
                    }

                    con.Close();
                }
            }

            return lista;
        }

        public void CreateProprietario(string strc, Proprietario item)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_CreateProprietario";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    WriteItem(cmd, item);

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void UpdateProprietario(string strc, string what, int intev, string Svalue, int IdP)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_UpdateProprietario";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@what", System.Data.SqlDbType.VarChar).Value = what;
                    cmd.Parameters.Add("@intev", System.Data.SqlDbType.Int).Value = intev;
                    cmd.Parameters.Add("@Svalue", System.Data.SqlDbType.VarChar).Value = Svalue;
                    cmd.Parameters.Add("@IdP", System.Data.SqlDbType.Int).Value = IdP;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        public void GoPremium(string strc, int idp)
        {
            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GoPremium";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }


        private List<string> GetTiposDeComida(string strc, int idp, int idt)
        {
            Dictionary<int, int> lista = new Dictionary<int, int>();
            Dictionary<int, string> result = new Dictionary<int, string>();


            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetRelTipo";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;
                    cmd.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = idt;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        int key = Convert.ToInt32(reader["IdP"]);
                        int value = Convert.ToInt32(reader["IdT"]);

                        if(key == idp)
                        lista.Add(key,value);
                    }

                    con.Close();


                    foreach (var a in lista)
                    {

                        SqlConnection con2 = new SqlConnection();

                        SqlCommand seccomand = new SqlCommand();

                        seccomand.CommandText = "stp_GetTipoDeComida";
                        seccomand.Connection = con2;
                        seccomand.CommandType = System.Data.CommandType.StoredProcedure;


                        seccomand.Parameters.Add("@idt", System.Data.SqlDbType.Int).Value = a.Value;

                        con2.Open();

                        SqlDataReader reader2 = cmd.ExecuteReader();

                        while(reader2.Read())
                        {
                            result.Add(Convert.ToInt32(reader2["Id"]), Convert.ToString(reader2["Tipo"]));
                        }


                        con2.Close();
                    }


                }
            }

            List<string> listafinal = new List<string>();


            foreach(var b in result)
            {
                listafinal.Add(b.Value);
            }

            return listafinal;

        }


        private List<byte[]> GetFotografiasR(string strc, int idp)
        {
            List<byte[]> fotos = new List<byte[]>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetFotografiasR";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        byte[] foto = (byte[])(reader["Foto"]);

                        fotos.Add(foto);
                    }

                    con.Close();
                }
            }

            return fotos;
        }

        private List<double> GetCoordenadas(string strc, int idp)
        {
            List<double> lista = new List<double>();

            using (SqlConnection con = new SqlConnection(strc))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "stp_GetCoordenadas";
                    cmd.Connection = con;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@idp", System.Data.SqlDbType.Int).Value = idp;

                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        double[] value = { Convert.ToDouble(reader["Clong"]), Convert.ToDouble(reader["Clat"]) };

                        lista.Add(value[0]);
                        lista.Add(value[1]);
                        
                    }

                    con.Close();
                }
            }

            return lista;
        }
    }
}