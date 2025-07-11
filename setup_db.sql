-- Create database and user
CREATE DATABASE IF NOT EXISTS flask_app;

-- Create user and grant privileges
CREATE USER IF NOT EXISTS 'flask'@'localhost' IDENTIFIED BY 'flask_test';
GRANT ALL PRIVILEGES ON flask_app.* TO 'flask'@'localhost';
FLUSH PRIVILEGES;

-- Use the database
USE flask_app;

-- Create tables
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT IGNORE INTO users (name, email) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');