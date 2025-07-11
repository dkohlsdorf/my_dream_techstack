from flask import Flask, render_template, request
import mysql.connector
from mysql.connector import Error
import os
from datetime import datetime

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'flask_app'),
    'user': os.getenv('DB_USER', 'flask'),
    'password': os.getenv('DB_PASSWORD', 'flask_test'),
    'port': int(os.getenv('DB_PORT', 3306))
}

def get_db_connection():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/users')
def users():
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
        cursor.close()
        connection.close()
        return render_template('users.html', users=users)
    return "Database connection failed", 500

@app.route('/add_user', methods=['POST'])
def add_user():
    name = request.form.get('name')
    email = request.form.get('email')
    
    if not name or not email:
        return "Name and email are required", 400
    
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("INSERT INTO users (name, email, created_at) VALUES (%s, %s, %s)", 
                      (name, email, datetime.now()))
        connection.commit()
        cursor.close()
        connection.close()
        return render_template('user_row.html', user={'name': name, 'email': email, 'created_at': datetime.now()})
    return "Database connection failed", 500

if __name__ == '__main__':
    app.run(debug=True)
