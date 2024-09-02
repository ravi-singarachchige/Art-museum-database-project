# Art Museum Database Project

This project is designed to manage and query an art museum database using Python and MySQL.

## Prerequisites

- Python 3.x
- MySQL Server
- `mysql-connector-python` library

## Installation

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Install the required Python libraries**:
    ```sh
    pip install mysql-connector-python
    ```

3. **Set up the MySQL database**:
    - Start your MySQL server.
    - Create a database named `ARTMUSEUM`.
    - Execute the SQL script `artmuseum.sql` to create the necessary tables and insert initial data:
        ```sh
        mysql -u <username> -p ARTMUSEUM < artmuseum.sql
        ```

## Usage

1. **Connect to the Database**:
    - The `connect_to_db` function in `artmuseum.py` connects to the MySQL database.
    - Example usage:
        ```python
        from artmuseum import connect_to_db

        db = connect_to_db('your_username', 'your_password')
        if db:
            cursor = db.cursor()
        ```

2. **Search Requests**:
    - Use the `search_request` function to execute SQL queries.
    - Example usage:
        ```python
        from artmuseum import search_request

        sql = "SELECT * FROM artists"
        search_request(cursor, sql)
        ```

3. **Running Queries from `queries.sql`**:
    - You can run predefined queries from the `queries.sql` file.
    - Example:
        ```sh
        mysql -u <username> -p ARTMUSEUM < queries.sql
        ```

## Database Setup

The `artmuseum.sql` file contains the SQL commands to set up the database schema and insert initial data. Ensure you have created the `ARTMUSEUM` database before running this script.

## Running Queries

The `queries.sql` file contains various SQL queries that can be executed against the `ARTMUSEUM` database. You can run these queries using the MySQL command line or any MySQL client.

```sh
mysql -u <username> -p ARTMUSEUM < queries.sql
