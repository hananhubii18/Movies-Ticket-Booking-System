# Movie Ticket Booking System

A MySQL database project designed to manage movies, theatres, screens, seats, show schedules, customer bookings, and payments. This project demonstrates relational database design and practical SQL concepts.

## Overview

The **Movie Ticket Booking System** uses MySQL to organize movie information, manage show timings, allocate seats, record customer bookings, and track payments.

The project includes sample data, SQL queries, views, stored procedures, triggers, and transaction examples.

## Features

- Manage movies, customers, theatres, screens, and seats.
- Schedule movie shows with ticket prices and show statuses.
- Store customer bookings and payment information.
- Display available seats for each show.
- Calculate ticket prices according to seat type.
- Prevent duplicate seat allocation for the same show.
- Create and cancel bookings using stored procedures.
- Automatically confirm bookings when payment becomes successful.
- Generate booking, revenue, payment, and seat-allocation reports.
- Demonstrate transaction management using COMMIT, ROLLBACK, and SAVEPOINT.

## Database Tables

| Table | Description |
|---|---|
| `Movies` | Stores movie details, genre, language, and duration. |
| `Customers` | Stores customer names, email addresses, and phone numbers. |
| `Theatres` | Stores theatre names, cities, and addresses. |
| `Screens` | Stores screens belonging to theatres. |
| `Seats` | Stores seat numbers and seat types. |
| `Shows` | Stores movie show schedules and base ticket prices. |
| `Bookings` | Stores customer bookings and their statuses. |
| `Booking_Seats` | Records seats allocated to bookings and ticket prices. |
| `Payments` | Stores payment amounts, methods, and statuses. |

## SQL Concepts Used

- Database and table creation
- Primary keys and foreign keys
- Constraints: NOT NULL, UNIQUE, CHECK, and ENUM
- INSERT, SELECT, UPDATE, and DELETE
- WHERE and ORDER BY
- Aggregate functions: COUNT, SUM, and AVG
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- Subqueries
- Views
- Stored procedures
- Triggers
- Transactions and savepoints

## Views

The project includes three views:

- `vw_booking_details` — Displays customer, movie, theatre, seat, and booking information.
- `vw_movie_revenue` — Summarizes confirmed bookings and successful payment revenue by movie.
- `vw_available_seats` — Displays available seats and their calculated ticket prices.

## Stored Procedures

- `sp_show_available_seats` — Displays available seats for a selected show.
- `sp_book_seat` — Validates a booking request and creates a booking, seat allocation, and pending payment.
- `sp_cancel_booking` — Cancels a booking, updates applicable payment statuses, and releases its seat allocations.

## Triggers

- `trg_booking_seat_before_insert` — Checks whether the selected seat belongs to the screen assigned to the show.
- `trg_payment_after_insert` — Confirms a pending booking when a payment is inserted with a successful status.
- `trg_payment_after_update` — Confirms a pending booking when its payment status changes to successful.

## Requirements

- MySQL Server
- MySQL Workbench or another compatible MySQL client

## Future Improvements

- Develop a web-based booking interface.
- Integrate a real payment gateway.
- Add customer and administrator authentication.
- Improve concurrency handling for simultaneous seat bookings.
- Add automated testing and advanced reporting.

## Author

**Hanan Hubi**

**Academic project developed using MySQL.**
