import mysql.connector
from collections import OrderedDict


def connect_to_db(user, password):
    try:
        # here
        db = mysql.connector.connect(
            host="127.0.0.1",
            port="3306",
            user=user,
            password=password,
            database="ARTMUSEUM"
        )
        if db.is_connected():
            print("\n-----Connected to Art Database-----\n")
            return db
        else:
            print("\nFailed to connect to Art Database.")
        return None
    
    except mysql.connector.Error as err:
        print(f"\nYou got an Error! {err}\n")
        return None

def search_request(cur, sql):
    try:
        cur.execute(sql)
        col_names = list(OrderedDict.fromkeys(cur.column_names))
        search_result = cur.fetchall()
        new_search_result = []
        for i in search_result:
            temp = []
            for j in i:
                if j not in temp:
                    temp.append(j)
            new_search_result.append(temp)
        search_result = new_search_result
        print("\nSearch found ",len(search_result)," Entries:\n")
        for i in range(len(search_result)):
            if len(search_result) > 1:
                print(f"Entry {i+1}:")
            for j in range(len(col_names)):
                print(f'{col_names[j]}: {search_result[i][j]}')
            print()

    except mysql.connector.Error as err:
        print(f"\nYou got an Error! {err}\n")


def search_database(cur):
    while True:
        print("What are you looking for?")
        print("1. Search Art Pieces")
        print("2. Search Exhibitions")
        print("3. Search Artists")
        print("4. Quit")
        option = input("Enter your option: ")
        print()

        if option == '1':
            print("1. Search by Painting")
            print("2. Search by Sculpture")
            print("3. Search Other Art Pieces")
            print("4. Search by Artist")
            print("5. Quit")
            option = input("Enter your option: ")
            print()
            if option == '1':
                search_term = input("Enter the painting's uniqueID to search: ")
                sql = f"SELECT * FROM ART_OBJECT, PAINTING WHERE PAINTING.uniqueID = '{search_term}' AND ART_OBJECT.uniqueID = '{search_term}';"
                search_request(cur, sql)

            elif option == '2':
                search_term = input("Enter the sculpture's uniqueID to search: ")
                sql = f"SELECT * FROM ART_OBJECT, SCULPTURE_OBJECT WHERE SCULPTURE_OBJECT.uniqueID = '{search_term}' AND ART_OBJECT.uniqueID = '{search_term}';"
                search_request(cur, sql)
                
            elif option == '3':
                search_term = input("Enter the art piece's uniqueID to search: ")
                sql = f"SELECT * FROM ART_OBJECT, OTHER WHERE OTHER.uniqueID = '{search_term}' AND ART_OBJECT.uniqueID = '{search_term}';"
                search_request(cur, sql)

            elif option == '4':
                search_term = input("Enter the artist's name to search: ")
                sql = f"""SELECT distinct art_object.uniqueID, year, art_object.countryOrigin, art_object.epoch, title, art_object.description, style FROM art_object 
                          JOIN made_by ON art_object.uniqueID = made_by.UID 
                          JOIN artist ON made_by.artistName = artistName 
                          WHERE artistName = '{search_term}';"""
                search_request(cur, sql)

            elif option == '5':
                return
            else:
                print("Invalid option.")


        elif option == '2':
            search_term = input("Enter the exhibition name to search: ")
            sql = f"SELECT * FROM EXHIBITION WHERE name = '{search_term}';"
            print("\nExhibition details:")
            search_request(cur, sql)
            sql = f"""SELECT distinct art_object.uniqueID, year, art_object.countryOrigin, art_object.epoch, title, art_object.description, style , exhibition.name, startDate, enddate
                      FROM art_object, exhibition, displayed_IN
                      where objectID = uniqueID and name = '{search_term}';"""
            print("List of art pieces displayed in this exhibition:")
            search_request(cur, sql)
        elif option == '3':
            search_term = input("Enter the artist's name to search: ")
            sql = f"SELECT * FROM ARTIST WHERE name = '{search_term}';"
            search_request(cur, sql)

        elif option == '4':
            return
        
        else:
            print("Invalid option.")


def admin_consol(db, cur):
    while True:
        print("1. Execute SQL command")
        print("2. Run SQL script file")
        print("3. Search Art Database")
        print("4. Add new user")
        print("5. Add user privileges")
        print("6. Remove user privileges")
        print("7. Block or unblock user")
        print("8. Quit")
        option = input("Enter your option: ")
        print()

        if option == '1':
            sql = input("Enter your SQL command: ")
            execute_sql(db, sql)
        elif option == '2':
            file_path = input("Enter the path of the SQL script file: ")
            run_sql_script(db, file_path)
        elif option == '3':
            search_database(cur)
        elif option == '4':
            username = input("Enter the new user's username: ")
            password = input("Enter the new user's password: ")
            sql = f"CREATE USER '{username}'@'localhost' IDENTIFIED WITH mysql_native_password BY '{password}';"
            execute_sql(db, sql)
            sql = f"GRANT SELECT, INSERT, UPDATE, DELETE ON ARTMUSEUM.* TO '{username}'@'localhost';"
            execute_sql(db, sql)
        elif option == '5':
            username = input("Enter the username of the user to change privileges: ")
            privileges = input("Enter the privileges (e.g., SELECT, INSERT, UPDATE, DELETE) to add: ")
            sql = f"GRANT {privileges} ON ARTMUSEUM.* TO '{username}'@'localhost';"
            execute_sql(db, sql)
        elif option == '6':
            username = input("Enter the username of the user to change privileges: ")
            privileges = input("Enter the privileges (e.g., SELECT, INSERT, UPDATE, DELETE) to remove: ")
            sql = f"REVOKE {privileges} ON ARTMUSEUM.* FROM '{username}'@'localhost';"
            execute_sql(db, sql)
        elif option == '7':
            username = input("Enter the username of the user to block or unblock: ")
            action = input("Enter 'block' to block the user, or 'unblock' to unblock the user: ")
            if action == 'block':
                sql = f"REVOKE ALL PRIVILEGES ON *.* FROM '{username}'@'localhost';"
            elif action == 'unblock':
                sql = f"GRANT SELECT, INSERT, UPDATE, DELETE ON ARTMUSEUM.* TO '{username}'@'localhost';"
            execute_sql(db, sql)
        elif option == '8':
            print("Goodbye!")
            return
        else:
            print("Invalid option.")


def data_entry(db, cur):
    while True:
        print("1. Execute SQL command")
        print("2. Search Art Database")
        print("3. Quit")
        option = input("Enter your option: ")
        print()
        if option == '1':
            sql = input("Enter your SQL command: ")
            execute_sql(db, sql)
        elif option == '2':
            search_database(cur)
        elif option == '3':
            print("Goodbye!")
            return
        else:
            print("Invalid option.")

def guest_view(cur):
    print("\nWelcome Guest!")
    search_database(cur)
    print("Goodbye!")
    return


def execute_sql(db, sql):
    try:
        cursor = db.cursor()
        cursor.execute(sql)
        if cursor.with_rows:
            results = cursor.fetchall()
            for row in results:
                print(row)
        else:
            db.commit()
        print("\nSQL command executed successfully.\n")
    except mysql.connector.Error as err:
        print(f"\nYou got an Error! {err}\n")

def run_sql_script(db, file_path):
    try:
        cursor = db.cursor()
        with open(file_path, 'r') as file:
            sql_script = file.read()
        commands = sql_script.split(';')
        for command in commands:
            if command.strip() != '':
                cursor.execute(command)
                if cursor.with_rows:
                    results = cursor.fetchall()  # Fetch all rows of the result set
                    if 'SELECT' in command.upper():
                        for row in results:
                            print(row)
        db.commit()
        print("\nSQL script executed successfully.")
        print()
        
    except mysql.connector.Error as err:
        print(f"\nYou got an Error! {err}\n")
    except FileNotFoundError:
        print("File not found.")


def print_box_message():
    message = "Welcome to the Museum Database"
    border = '+' + '-' * (len(message) + 2) + '+'
    print(border)
    print('| ' + message + ' |')
    print(border)

def main():
    print_box_message() 
    print("Please select your role:")
    print("1. DB Admin")
    print("2. Employee")
    print("3. Browse as guest\n")

    role = input("Please enter 1, 2, or 3 to select your role:")

    if role in ['1','2']:
        username = input("Enter your username: ")
        password = input("Enter your password: ")
    elif role == '3':
        username="guest"
        password=None
    else:
        print("\nInvalid role.")
        return

    db = connect_to_db(username, password)
    if db is None:
        return
    
    cur = db.cursor()
    cur.execute("use ARTMUSEUM")
    
    if role == '1':
        admin_consol(db, cur)
    elif role == '2':
        data_entry(db, cur)
    else:
        guest_view(cur)


    db.close()

if __name__ == "__main__":
    main()