# 🛒 Online Shop Mobile App

A cross-platform e-commerce mobile app built with **Flutter**, connecting to a custom **ASP.NET Core** backend API.

## Overview

This app lets users browse products by category, manage a cart and wishlist, authenticate via email or social login, and chat with an AI assistant. It was built as a personal/learning project to practice Flutter development alongside a real backend integration, and this is the final delivered version.

---

## ✨ Features

- **Authentication** — email/password sign up & login, Google Sign-In, Facebook Login, forgot/reset password flow with verification codes
- **Shop & Categories** — browse products by category and subcategory, with branch-based filtering
- **Cart** — add/remove items, adjust quantities, persistent cart state
- **Wishlist** — save items for later
- **Offers** — dedicated offer bundles (e.g. seasonal promotions) with included products and pricing
- **Order Tracking** — view order history and detail, cancel pending orders
- **AI Chat** — in-app AI assistant (powered by `googleai_dart`)
- **User Profile** — view/edit user data, change password, see recent orders
- **Multi-language support** — powered by `easy_localization`, with an in-app English/Arabic toggle
- **Backend integration** — talks to an ASP.NET Core REST API for auth, products, orders, and branch/location data

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** ASP.NET Core (separate repo/service, hosted on Azure)
- **Key packages:**
  - `http` — API communication
  - `flutter_secure_storage` — secure token storage
  - `google_sign_in`, `flutter_facebook_auth` — social login
  - `cached_network_image` — image loading/caching
  - `easy_localization` — localization
  - `googleai_dart` — AI chat
  - `google_fonts`, `chat_bubbles`, `pinput`, `grouped_list` — UI

---

## 📂 Project Structure

```
lib/
├── data/            # Static/local data (branches, categories)
├── managers/        # API service, auth, and social-auth logic
├── screens/         # App screens (home, shop, cart, wishlist, profile, auth flows, chat, etc.)
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

---

## 📱 Screenshots

<table>
<tr>
<td align="center"><b>Home</b><br><img src="screenshots/home.png" width="220"></td>
<td align="center"><b>Shop</b><br><img src="screenshots/shop.png" width="220"></td>
<td align="center"><b>Filter</b><br><img src="screenshots/filter.png" width="220"></td>
</tr>
<tr>
<td align="center"><b>Cart</b><br><img src="screenshots/cart.png" width="220"></td>
<td align="center"><b>Product Details</b><br><img src="screenshots/product_details.png" width="220"></td>
<td align="center"><b>Wishlist</b><br><img src="screenshots/wishlist.png" width="220"></td>
</tr>
<tr>
<td align="center"><b>Offer</b><br><img src="screenshots/offer_screen1.png" width="220"></td>
<td align="center"><b>Offer Details</b><br><img src="screenshots/offer_screen2.png" width="220"></td>
<td align="center"><b>Order</b><br><img src="screenshots/order.png" width="220"></td>
</tr>
<tr>
<td align="center"><b>Login</b><br><img src="screenshots/login.png" width="220"></td>
<td align="center"><b>Sign Up</b><br><img src="screenshots/signup.png" width="220"></td>
<td align="center"><b>Forgot Password</b><br><img src="screenshots/forgot_password.png" width="220"></td>
</tr>
<tr>
<td align="center"><b>Search</b><br><img src="screenshots/search.png" width="220"></td>
<td align="center"><b>Profile</b><br><img src="screenshots/profile.png" width="220"></td>
<td align="center"><b>AI Chat</b><br><img src="screenshots/ai_chat.png" width="220"></td>
</tr>
</table>

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK ^3.11.0)
- A configured `.env` file (required for API keys / endpoints — not included in the repo)
- Access to the corresponding ASP.NET Core backend API

### Installation

```bash
git clone https://github.com/abdelrahman00204/Online-shop-Mobile-App.git
cd Online-shop-Mobile-App
flutter pub get
flutter run
```

### Notes

- Social login (Google/Facebook) requires your own OAuth credentials and platform configuration (key hashes, app IDs, etc.).
- The backend API is hosted on Azure. The app's `.env` file needs to point to that endpoint for auth, products, and other data to load.

---

## ⚠️ Known Limitations

- No automated CI/CD or release builds yet

---

## 📄 License

No license specified yet.
