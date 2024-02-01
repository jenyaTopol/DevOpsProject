import mysql.connector

# Database Configuration - Replace with your actual database credentials
db_config = {
    'host': 'localhost',  
    'user': 'root',       
    'password': '',       
    'database': 'test_db' 
}

# Initialize database connection
def get_db_connection():
    connection = mysql.connector.connect(**db_config)
    return connection

# Create table - This should be run once to set up the table
def create_user_table():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255),
            password VARCHAR(255)
        )
    ''')
    connection.commit()
    cursor.close()
    connection.close()
