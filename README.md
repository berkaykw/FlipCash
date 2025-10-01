# FlipCash

**FlipCash** is a mobile application designed for travelers.  
It allows you to view real-time currency exchange rates, quickly convert between different currencies, and easily track your expenses.  
Built with Flutter, it provides a modern and user-friendly interface.

## Features
-  Real-time currency conversion UI  
-  Quick swap between base and spent currencies  
-  Easy country and currency selection using **`country_picker`** package  
-  Save user preferences locally using **Shared Preferences**  
-  Dark Mode & Light Mode toggle  
-  Responsive and intuitive mobile interface  
-  **Expenses tracking & management**  
    - Add and save expenses  
    - List expenses by country and currency  
    - Store expenses locally (via `ExpenseStorage`)  
    - View total expenses  

## Tech Stack
- **Application:** Flutter (Dart)  
  - Packages used:
    - `country_picker` → for selecting countries and currencies  
    - `shared_preferences` → for storing user selections locally  
    - `provider: ^6.0.5` → for state management (e.g., theme switching, expenses handling)  
- **Backend:** Node.js server providing currency rates via ExchangeRate API  
