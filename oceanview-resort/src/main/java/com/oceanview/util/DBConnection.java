package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton pattern for database connection.
 * Compatible with MySQL 8.0.44 running on port 3308
 */
public class DBConnection {

    // Volatile for thread-safety in multi-threaded environments
    private static volatile Connection instance;

    // ────────────────────────────────────────────────
    // IMPORTANT: Your MySQL is on PORT 3308 (not 3306)
    // ────────────────────────────────────────────────
    private static final String URL = 
        "jdbc:mysql://localhost:3308/oceanview_resort" +
        "?useSSL=false" +
        "&allowPublicKeyRetrieval=true" +
        "&serverTimezone=UTC" +
        "&useUnicode=true" +
        "&characterEncoding=UTF-8";

    private static final String USER = "root";
    private static final String PASS = "Hiru#990";

    // Private constructor prevents instantiation
    private DBConnection() {
        // Prevent instantiation from outside
    }

    /**
     * Returns a database connection (thread-safe lazy initialization)
     */
    public static Connection getConnection() throws SQLException {
        if (instance == null || instance.isClosed()) {
            synchronized (DBConnection.class) {
                if (instance == null || instance.isClosed()) {
                    try {
                        // Explicit driver load (safety net for some environments)
                        Class.forName("com.mysql.cj.jdbc.Driver");
                    } catch (ClassNotFoundException e) {
                        throw new SQLException("MySQL JDBC Driver not found. " +
                            "Make sure mysql-connector-java is in WEB-INF/lib", e);
                    }

                    // Establish connection
                    instance = DriverManager.getConnection(URL, USER, PASS);
                    System.out.println("Database connection established successfully.");
                }
            }
        }
        return instance;
    }

    /**
     * Optional: Close the connection when application shuts down
     * (can be called from ServletContextListener)
     */
    public static void closeConnection() {
        if (instance != null) {
            try {
                instance.close();
                instance = null;
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}