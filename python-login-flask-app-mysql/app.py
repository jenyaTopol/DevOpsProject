from flask import Flask, request, render_template
import database

app = Flask(__name__)

# Application route for sign-in
@app.route('/', methods=['GET', 'POST'])
def signin():
    message = ''
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        # Insert into database
        connection = database.get_db_connection()
        cursor = connection.cursor()
        cursor.execute('INSERT INTO users (username, password) VALUES (%s, %s)', (username, password))
        connection.commit()
        cursor.close()
        connection.close()

        message = 'Sign In Successful'

    return render_template('signin.html', message=message)

if __name__ == "__main__":
    database.create_user_table()  # Create the table on startup
    app.run(debug=True)
