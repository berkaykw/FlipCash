# FlipCash - Frontend

This is the **frontend of FlipCash**, a mobile application built using **Flutter**. It enables users to quickly convert currencies while traveling and provides a smooth, interactive experience.

## Features
- 💱 Real-time currency conversion UI
- 🔄 Quick swap between base and spent currencies
- 🌍 Easy country and currency selection using **`country_picker`** package
- 💾 Saves user preferences locally using **Shared Preferences**
- 🌓 Dark Mode & Light Mode toggle
- 📱 Responsive and intuitive mobile interface
- 🧾 **Expenses tracking & management**  
  - Add and save expenses  
  - List expenses by country and currency  
  - Store expenses locally (via `ExpenseStorage`)  
  - View total expenses 

## Tech Stack
- **Frontend:** Flutter (Dart)  
  - Packages used:
    - `country_picker` → selecting countries and currencies
    - `shared_preferences` → storing user selections locally
    - `provider: ^6.0.5` → state management (e.g. theme switching, expenses handling)
- **Backend:** Node.js server providing currency rates via ExchangeRate API
