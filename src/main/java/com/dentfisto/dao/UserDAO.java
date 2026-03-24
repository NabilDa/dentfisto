package com.dentfisto.dao;

import com.dentfisto.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data access object for the users table.
 */
public class UserDAO {

    /**
     * Finds a user by username and role.
     * Returns null if no match is found.
     */
    public User findByUsernameAndRole(String username, String role) {
        String sql = "SELECT id, username, password_hash, role, full_name "
                   + "FROM users WHERE username = ? AND role = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, role);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("role"),
                        rs.getString("full_name")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
