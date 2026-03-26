-- ============================================
-- DentFisto – Database Initialization Script
-- ============================================

USE dentfisto;

-- ----------------------------------------
-- Users table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    role        ENUM('ADMIN', 'DENTIST', 'ASSISTANT') NOT NULL,
    full_name   VARCHAR(100) NOT NULL
);

-- ----------------------------------------
-- Appointments table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS appointments (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    dentist_id   INT          NOT NULL,
    date_time    DATETIME     NOT NULL,
    status       ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
    notes        TEXT,
    FOREIGN KEY (dentist_id) REFERENCES users(id)
);

-- ----------------------------------------
-- Seed data (password = 'password123')
-- SHA-256 hash of 'password123' = ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
-- ----------------------------------------
INSERT INTO users (username, password_hash, role, full_name) VALUES
    ('admin',      'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'ADMIN',     'Admin User'),
    ('dentist1',   'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'DENTIST',   'Dr. Smith'),
    ('assistant1', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'ASSISTANT', 'Jane Doe');
