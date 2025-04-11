from flask import Flask, render_template, request
import pyodbc

app = Flask(__name__)

# Database connection string
conn_str = (
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=MANISH\SQLEXPRESS;'
    'DATABASE=SHOOping;'
    'Trusted_Connection=yes;'
)


@app.route('/')
def home():
    return render_template('index.html')

@app.route('/customer')
def customer_form():
    return render_template('customer_form.html')

@app.route('/add_customer', methods=['POST'])
def add_customer():
    try:
        data = request.form
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO CUSTOMER (CustomerID, CustomerName, CustomerType, AccountType, Address)
                VALUES (?, ?, ?, ?, ?)
            """, (
                data['CustomerID'],
                data['CustomerName'],
                data['CustomerType'],
                data['AccountType'],
                data['Address']
            ))
            conn.commit()
        return "Customer added successfully!"
    except Exception as e:
        return f"Error: {e}"

@app.route('/customers')
def view_customers():
    try:
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM CUSTOMER")
            rows = cursor.fetchall()
        return render_template('view_customers.html', customers=rows)
    except Exception as e:
        return f"Error: {e}"

@app.route('/product')
def product_form():
    return render_template('product_form.html')

@app.route('/add_product', methods=['POST'])
def add_product():
    try:
        data = request.form
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO PRODUCTS (ProductID, ProductName, ProductDescription, Price, CategoryID, BrandID)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                data['ProductID'],
                data['ProductName'],
                data['ProductDescription'],
                data['Price'],
                data['CategoryID'],
                data['BrandID']
            ))
            conn.commit()
        return "Product added successfully!"
    except Exception as e:
        return f"Error: {e}"

@app.route('/payment')
def payment_form():
    return render_template('payment_form.html')

@app.route('/view_cart', methods=['GET', 'POST'])
def view_cart():
    cart_items = []
    if request.method == 'POST':
        customer_id = request.form['customer_id']
        try:
            with pyodbc.connect(conn_str) as conn:
                cursor = conn.cursor()
                cursor.execute("EXEC ViewCart @CustomerID = ?", customer_id)
                rows = cursor.fetchall()
                cart_items = [
                    {'CartID': row.CartID, 'ProductName': row.ProductName, 'Quantity': row.Quantity, 'TotalAmount': row.TotalAmount}
                    for row in rows
                ]
        except Exception as e:
            return f"Error fetching cart: {e}"
    
    return render_template("view_cart.html", cart_items=cart_items)


@app.route('/add_payment', methods=['POST'])
def add_payment():
    try:
        data = request.form
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO PAYMENT (PaymentID, CustomerID, AccountID, PaymentAmount, PaymentType, PaymentDate)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                data['PaymentID'],
                data['CustomerID'],
                data['AccountID'],
                data['PaymentAmount'],
                data['PaymentType'],
                data['PaymentDate']
            ))
            conn.commit()
        return "Payment added successfully!"
    except Exception as e:
        return f"Error: {e}"

@app.route('/account_balance', methods=['POST'])
def get_account_balance():
    account_id = request.form['account_id']
    try:
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            cursor.execute("EXEC GetAccountBalance @AccountID = ?", account_id)
            result = cursor.fetchone()
            if result:
                return f"Account Balance: {result.Balance}"
            return "Account not found"
    except Exception as e:
        return f"Error: {e}"

if __name__ == '__main__':
    app.run(debug=True)
