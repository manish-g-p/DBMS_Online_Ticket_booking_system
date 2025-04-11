# DBMS Online Ticket Booking System

A full-stack web application for managing online ticket bookings built with Python Flask and MySQL.

## Features
- Customer registration and management
- Ticket booking functionality
- Payment processing
- Admin dashboard for managing bookings
- Responsive web interface

## Technologies Used
- Backend: Python Flask
- Database: MySQL
- Frontend: HTML, CSS, JavaScript
- Templates: Jinja2

## Quick Access
- **Live Demo**: [http://localhost:5000](http://localhost:5000) (after starting server)
- Admin Panel: [http://localhost:5000/admin](http://localhost:5000/admin)
- Customer Login: [http://localhost:5000/login](http://localhost:5000/login)

## Setup Instructions

1. **Prerequisites**:
   - Python 3.x
   - MySQL Server
   - pip package manager

2. **Installation**:
   ```bash
   git clone https://github.com/manish-g-p/DBMS_Online_Ticket_booking_system.git
   cd DBMS_Online_Ticket_booking_system
   pip install -r requirements.txt
Database Setup:

Import SHOOping.sql to your MySQL server
Configure database credentials in app.py
Running the Application:

python app.py
The application will start at: http://localhost:5000

Accessing the Website
After starting the application, access these endpoints:

Home Page: http://localhost:5000
Customer Registration: http://localhost:5000/register
Booking Page: http://localhost:5000/book
Payment Page: http://localhost:5000/payment
Admin Dashboard: http://localhost:5000/admin
Project Structure
.
├── app.py             # Main application file
├── SHOOping.sql       # Database schema
├── templates/         # HTML templates
│   ├── index.html
│   ├── customer_form.html
│   ├── payment_form.html
│   ├── product_form.html
│   ├── view_cart.html
│   └── view_customers.html
├── README.md          # This file
└── requirements.txt   # Python dependencies
Usage Guide
For Customers:

Register at http://localhost:5000/register
Browse tickets at http://localhost:5000
Make bookings at http://localhost:5000/book
For Admins:

Access dashboard at http://localhost:5000/admin
Manage tickets and customers
Screenshots
Home Page: Home
Booking Page: Booking
Admin Panel: Admin
Troubleshooting
If port 5000 is busy, change in app.py:
if __name__ == '__main__':
    app.run(port=5001)  # Change to available port
Then access at: http://localhost:5001.

