using DatabaseSecriptExecuter;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Text.Json;
using Microsoft.Data.SqlClient;
namespace MultiDbSqlExecutorWithJson
{
    class Program
    {
        static void Main(string[] args)
        {
            string basePath = AppDomain.CurrentDomain.BaseDirectory;
            string jsonPath = Path.Combine(basePath, "dbconfig.json");// JSON file path
            string scriptsFolder = Path.Combine(basePath, "SqlScripts");// SQL scripts folder
            string[] sqlFiles = Directory.GetFiles(scriptsFolder, "*.sql");
            Array.Sort(sqlFiles); // Ensure sequential execution

            // Read JSON1
            List<DbConfig> dbList = JsonSerializer.Deserialize<List<DbConfig>>(File.ReadAllText(jsonPath))!;

            foreach (var db in dbList)
            {
                Console.WriteLine($"Executing scripts on {db.Database} @ {db.Server}");
                string connStr = $"Server={db.Server};Database={db.Database};User Id={db.User};Password={db.Password};";

                try
                {
                    using (SqlConnection connection = new SqlConnection(connStr))
                    {
                        connection.Open();

                        foreach (var file in sqlFiles)
                        {
                            Console.WriteLine($"  Executing script: {Path.GetFileName(file)}");

                            string script = File.ReadAllText(file);

                            using (SqlCommand cmd = new SqlCommand(script, connection))
                            {
                                cmd.ExecuteNonQuery();
                            }

                            Console.WriteLine("  Done.");
                        }

                        connection.Close();
                    }

                    Console.WriteLine($"All scripts executed on {db.Database}\n");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error on {db.Database}: {ex.Message}");
                }
            }

            Console.WriteLine("All scripts executed on all databases!");
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}