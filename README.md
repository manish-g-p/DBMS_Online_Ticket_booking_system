# Online shopping Management sytsem

## Project Overview
 ![image](https://github.com/user-attachments/assets/2b61dc1a-c655-4913-b1df-7c4a2c18543c)

A Flask-based web application for managing an e-commerce platform with:
- Customer management
- Product catalog
- Shopping cart functionality
- Payment processing
- Account management

## Technologies Used
- **Backend**: Python Flask
- **Database**: Microsoft SQL Server (MSSQL)
- **Frontend**: HTML templates
- **Database Driver**: pyodbc

## Database Schema
The system uses the following tables:
- `CUSTOMER`: Stores customer information
- `ACCOUNT`: Manages customer accounts and balances
- `PRODUCTS`: Product catalog
- `BRAND`: Product brands
- `CATEGORY`: Product categories
- `PAYMENT`: Payment records
- `CART`: Shopping cart items

## Key Features
### Customer Management
 ![image](https://github.com/user-attachments/assets/70a2c0c6-be81-4497-91f3-60fc4c62983a)

- Add new customers
- View all customers
- Customer types (Convenience shoppers, Brand advocates, etc.)

### Product Management
![image](https://github.com/user-attachments/assets/754abab4-349b-4d60-a7f4-3b84ae0701af)

 - Add new products
- Categorize products
- Brand management

### Shopping Cart
- View cart contents
- Add items to cart
- Calculate total amounts

### Payment Processing
 ![image](https://github.com/user-attachments/assets/ae212f85-c804-4b53-af17-8f4cdbd5f40e)

- Record payments
- Payment type tracking (online/offline)
- Account balance updates

## Installation & Setup
1. **Prerequisites**:
   - Python 3.x
   - MSSQL Server
   - ODBC Driver 17 for SQL Server

2. **Database Setup**:
   - Run `SHOOping.sql` to create database schema and sample data

3. **Application Setup**:
   - Install requirements: `pip install flask pyodbc`
   - Update connection string in `app.py` with your server details
   - Run application: `python app.py`


## Business Logic Highlights
1. **Triggers**:
   - Automatically updates account status when payments exceed $50
   - Prevents payments that would result in negative balance

2. **Stored Procedures**:
   - `ViewCart`: Retrieves cart items for a customer
   - `GetAccountBalance`: Checks current account balance
   - `AddToCart`: Adds items to cart with automatic total calculation

3. **Analytical Queries**:
   - Average product quantities in carts
   - Payment comparisons (above/below average)
   - Product price analytics by category

## Usage Instructions
1. Start the application: `python app.py`
2. Access the web interface at `http://localhost:5000`
3. Use the navigation to access different features

## Future Enhancements
- User authentication
- Order history tracking
- Product search functionality
- Admin dashboard

