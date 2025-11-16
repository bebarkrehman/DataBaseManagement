using DatabaseSecriptExecuter;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Text.Json;

namespace MultiDbSqlExecutorWithJson
{
    class Program
    {
        static void Main(string[] args)
        {
            string basePath = AppDomain.CurrentDomain.BaseDirectory;
            string jsonPath = Path.Combine(basePath, "Config.json");  // JSON file
            string scriptsFolder = Path.Combine(basePath, "Scripts"); // SQL Scripts folder
            string[] sqlFiles = Directory.GetFiles(scriptsFolder, "*.sql");
            Array.Sort(sqlFiles);

            // Read JSON
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
                            
                            Console.WriteLine($"Start scripts executed successfully on {db.Database}\n");
                            // Start Transaction
                            SqlTransaction transaction = connection.BeginTransaction();
                            try
                            {
                                Console.WriteLine($"  Executing script: {Path.GetFileName(file)}");

                                string script = File.ReadAllText(file);

                                using (SqlCommand cmd = new SqlCommand(script, connection, transaction))
                                {
                                    cmd.ExecuteNonQuery();
                                }

                                Console.WriteLine("  -> Executed");

                                // All scripts OK → COMMIT
                                transaction.Commit();
                                Console.WriteLine($"Close scripts executed successfully on {db.Database}\n");
                            }
                            catch (Exception ex)
                            {
                                // Error → ROLLBACK
                                transaction.Rollback();
                                Console.WriteLine($"Error in {db.Database}. All changes rolled back!");
                                Console.WriteLine($"Message: {ex.Message}\n");
                                break;
                            }
                        }
                        connection.Close();
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Connection Error on {db.Database}: {ex.Message}");
                }
            }

            Console.WriteLine("All databases processed!");
            Console.ReadKey();
        }
    }
}
