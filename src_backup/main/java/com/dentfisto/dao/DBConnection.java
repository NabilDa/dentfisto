package com.dentfisto.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Provides a database connection using environment variables.
 *
 * Required env vars: DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS
 */
public class DBConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASS;

    static {
        String host = System.getenv().getOrDefault("DB_HOST", "localhost");
        String port = System.getenv().getOrDefault("DB_PORT", "3306");
        String name = System.getenv().getOrDefault("DB_NAME", "dentFistoDB");
        URL  = "jdbc:mysql://" + host + ":" + port + "/" + name + "?useSSL=false&allowPublicKeyRetrieval=true";
        USER = System.getenv().getOrDefault("DB_USER", "root");
        PASS = System.getenv().getOrDefault("DB_PASS", "root");
    }

    /**
     * Returns a new database connection.
     * Callers are responsible for closing the connection.
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }

    private DBConnection() {}
}
