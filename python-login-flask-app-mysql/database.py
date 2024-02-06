import mysql.connector

# Database Configuration - Replace with your actual database credentials
db_config = {
    'host': 'localhost',  
    'user': 'root',       
    'password': 'root',       
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

# import mysql.connector
# from mysql.connector import Error

# # Database Configuration - Without specifying the database
# db_config = {
#     'host': 'localhost',
#     'user': 'root',
#     'password': 'root'  
# }

# def create_database():
#     try:
#         connection = mysql.connector.connect(**db_config)
#         cursor = connection.cursor()
#         cursor.execute("CREATE DATABASE IF NOT EXISTS test_db")
#     except Error as e:
#         print(f"Error creating database: {e}")
#     finally:
#         if connection.is_connected():
#             cursor.close()
#             connection.close()
#             print("MySQL connection is closed")

# # Update db_config to include the database name for subsequent connections
# db_config['database'] = 'test_db'

# def get_db_connection():
#     try:
#         connection = mysql.connector.connect(**db_config)
#         return connection
#     except Error as e:
#         print(f"Error connecting to the database: {e}")

# # Existing function to create user table, no changes needed here
# def create_user_table():
#     connection = get_db_connection()
#     cursor = connection.cursor()
#     cursor.execute('''
#         CREATE TABLE IF NOT EXISTS users (
#             id INT AUTO_INCREMENT PRIMARY KEY,
#             username VARCHAR(255),
#             password VARCHAR(255)
#         )
#     ''')
#     connection.commit()
#     cursor.close()
#     connection.close()
