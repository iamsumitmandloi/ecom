# Project Documentation & Implementation Summary

This document provides a comprehensive overview of the E-commerce Flutter application's architecture, design patterns, and implementation details. Its purpose is to serve as a guide for developers to understand the project's structure and contribute effectively.

---

## 1. Core Architectural Philosophy: Clean Architecture

This project is built upon the principles of **Clean Architecture**. This architectural style separates the codebase into distinct layers, enforcing a clear separation of concerns. This makes the application:

-   **Independent of Frameworks & UI:** The core business logic doesn't depend on Flutter.
-   **Testable:** Each layer can be tested in isolation.
-   **Maintainable & Scalable:** Changes in one layer (e.g., swapping a database) have minimal impact on others.

Our implementation of Clean Architecture is organized by **features**, with each feature containing three layers:

### **a. Data Layer**

-   **Location:** `lib/features/<feature_name>/data`
-   **Responsibility:** Handles all interactions with external data sources. It knows *how* to get or store data.
-   **Contents:**
    -   **Repository Implementations:** Concrete implementations of the repository contracts defined in the Domain layer (e.g., `AuthRepositoryImpl`).
    -   **API Clients:** Classes responsible for making network requests to specific backends (e.g., `AuthApi` which uses the `dio` package to talk to Firebase's REST API).
    -   **Data Models:** Data Transfer Objects (DTOs) that exactly match the structure of the backend API responses. These are typically suffixed with `Model`.

### **b. Domain Layer**

-   **Location:** `lib/features/<feature_name>/domain`
-   **Responsibility:** Contains the core business logic and rules of the application. This layer is pure Dart and has **no dependencies on Flutter or any external packages**. It defines *what* the application can do.
-   **Contents:**
    -   **Entities:** Plain Dart objects representing the core business concepts (e.g., `AuthSession`, `Product`).
    -   **Repository Contracts (Abstract Classes):** Defines the interfaces for our data layer (e.g., `AuthRepository`). The Presentation layer depends on this contract, not the implementation.
    -   **Custom Exceptions:** Defines the specific business-related errors that can occur (e.g., `EmailAlreadyInUse`).

### **c. Presentation Layer**

-   **Location:** `lib/features/<feature_name>/presentation`
-   **Responsibility:** Handles everything related to the UI and user interaction. It knows *what* to show the user and how to handle their input.
-   **Contents:**
    -   **Pages/Widgets:** The Flutter widgets that make up the UI screens (e.g., `AuthPage`, `ProductsPage`).
    -   **State Management (Cubits/Blocs):** Classes that manage the state of the UI, respond to user events, and interact with the Domain layer (e.g., `AuthCubit`).

---

## 2. Key Technologies & Packages

The following packages were chosen to build a robust and modern application:

-   **State Management (`flutter_bloc`):** Chosen for its clear separation of business logic from the UI and its excellent testability. It enforces a predictable, event-driven state flow.
-   **Dependency Injection (`get_it`):** Used as a simple and efficient Service Locator to decouple classes. It allows us to easily provide dependencies (like Repositories and Cubits) wherever they are needed without using `BuildContext`. The setup is centralized in `lib/di/service_locator.dart`.
-   **Routing (`go_router`):** The official Flutter routing package. It provides a declarative, URL-based API that is perfect for handling deep linking and complex navigation scenarios, such as authentication-based redirection. All routing logic is centralized in `lib/core/router/app_router.dart`.
-   **Data Modeling (`freezed` & `json_serializable`):** Used to create immutable data classes (Entities and Models). `freezed` reduces boilerplate by generating `copyWith`, `==`, and `toString` methods, while `json_serializable` automates the creation of `fromJson`/`toJson` methods, preventing manual parsing errors.
-   **Networking (`dio`):** A powerful HTTP client chosen over the standard `http` package for its advanced features like interceptors, request cancellation, and global configuration.
-   **Security (`flutter_secure_storage`):** Used to securely persist sensitive user data, such as authentication tokens, on the device's keychain/keystore.
-   **Configuration (`flutter_dotenv`):** Used to manage environment-specific variables and secrets (like API keys) by loading them from a `.env` file, which is excluded from version control.

---

## 3. Recent Refactoring (Completed)

To improve focus and ensure core functionality is robust, a major refactoring was performed on the **Product Catalog** feature.

*   **Removed Features:** All UI and business logic for **Search** and **Category Filtering** were removed from the application. This was a strategic decision to simplify the feature set and postpone complex features that were not yet scalable (e.g., the client-side search implementation).
*   **Implemented Pagination:** A robust, production-ready infinite scroll (pagination) system was implemented. The `ProductsCubit` now manages loading subsequent pages of products, and the `ProductsPage` UI triggers this logic when the user scrolls to the end of the list.

---

## 4. Feature Status & Implementation Details

### a. Authentication
**Status: 100% Complete & Production-Ready**

The authentication feature is a perfect example of how all the architectural pieces work together:

1.  **UI Interaction:** The user enters their credentials into the `AuthPage`.
2.  **State Management:** The `AuthPage` calls a method on the `AuthCubit` (e.g., `signIn(email, password)`).
3.  **Business Logic:** The `AuthCubit` emits a `loading` state, then calls the `signIn` method on its `AuthRepository` (the abstract contract from the Domain layer).
4.  **Data Fetching:** `get_it` provides the `AuthRepositoryImpl` to the Cubit. This implementation calls the `AuthApi` to make the actual REST API request to Firebase.
5.  **Error Handling:** If the API returns an error, the `AuthApi` catches the `DioException`, maps it to a specific, typed `AuthException` (e.g., `InvalidCredentials`), and throws it.
6.  **State Update (Failure):** The `AuthRepositoryImpl` catches this `AuthException` and re-throws it. The `AuthCubit` catches it and emits an `unauthenticated` state containing the specific error message, which the `AuthPage` then displays to the user.
7.  **Data Processing (Success):** If the API call is successful, the `AuthRepositoryImpl` uses the `AuthSession.fromJson` factory (generated by `freezed`) to convert the API response into a clean `AuthSession` entity.
8.  **Secure Storage:** The `AuthRepositoryImpl` saves the `AuthSession` to the device using `SecureSessionStorage`. A crash on first launch due to corrupted data was fixed by making the `readSession` method more resilient.
9.  **State Update (Success):** The `AuthSession` is returned to the `AuthCubit`, which emits an `authenticated` state.
10. **Reactive Navigation:** The `AppRouter`, which is listening to the `AuthCubit`'s stream, detects the new `authenticated` state and automatically redirects the user from `/login` to the `/products` page.

### b. Product Catalog
**Status: Core Functionality Complete**

This feature handles the display of products to the user.

*   **Domain Layer (100% Complete):** A rich `Product` entity is defined, encapsulating business logic for stock status, pricing, etc. A comprehensive `ProductsRepository` contract defines the data flow.
*   **Data Layer (100% Complete for Core Features):** The `ProductsRepositoryImpl` correctly fetches data from the `ProductsApi`, which communicates with the Firebase REST API. It correctly handles parsing and error mapping.
*   **Presentation Layer (90% Complete):** The `ProductsCubit` manages the state for displaying a paginated list of products. The `ProductsPage` UI correctly implements infinite scrolling to provide a seamless browsing experience.
*   **Postponed Features:** Scalable Search and Favorites management have been removed from the current plan to maintain focus.

### c. Shopping Cart
**Status: Logic & Data Layers 100% Complete & Production-Ready**

This feature manages the user's shopping cart. The underlying logic is complete and demonstrates advanced domain-driven design patterns. The UI widgets are the only remaining component to be fully analyzed.

*   **Domain Layer (100% Complete):** The `Cart` and `CartItem` entities are implemented as rich domain models. They are immutable and contain all business logic for adding/removing items, updating quantities, and calculating totals (subtotal, tax, shipping, etc.). This keeps the rest of the app clean and ensures business rules are enforced consistently.
*   **Data Layer (100% Complete):** The `CartRepositoryImpl` provides a clean API for cart operations. It uses an in-memory cache (`_cachedCart`) for high performance and delegates all business logic to the `Cart` entity. The `CartStorageImpl` handles the actual persistence of the cart to the device's local storage.
*   **Presentation Layer (Logic - 100% Complete):** The `CartCubit` is a production-ready state manager. It depends on specific use cases (e.g., `AddToCartUseCase`) and provides convenient helper methods for the UI (e.g., `incrementQuantity`). Its error handling is robust, preserving the user's cart state even if an operation fails.
