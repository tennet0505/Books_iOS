# Books_iOS

A simple iOS application built with Swift that allows users to browse, search, and manage their favorite books. This app features a clean user interface and leverages the CoreData database for local storage of book information.

## Features

- **Browse Books**: View a list of available books with their cover images, titles, and authors.
- **Search Functionality**: Search for books by title or author.
- **Favorites**: Mark books as favorites and view them in a separate tab.
- **Light and Dark Themes**: Supports both light and dark mode themes.
- **Responsive UI**: Built using UIKit for a modern, responsive design.

## Table of Contents
1. [Architecture](#1-architecture)
2. [Design Decisions](#2-design-decisions)
3. [Setting Up the Project](#3-setting-up-the-project)
   - [Requirements](#requirements)
   - [Libraries/Frameworks Used](#librariesframeworks-used)
4. [Running the Project](#4-running-the-project)
   - [Clone the Repository](#clone-the-repository)
   - [Install CocoaPods](#install-cocoapods)
   - [Open the Project in Xcode](#open-the-project-in-xcode)
   - [Build & Run](#build--run)
5. [Unit Testing](#5-unit-testing)
   - [Unit Test Setup](#unit-test-setup)
   - [Running Tests](#running-tests)
6. [Future Improvements](#6-future-improvements)

---

## 1. Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture pattern, promoting separation of concerns and enhancing maintainability and testability.

- **Model**: 
  - Represents the data layer and business logic.
  - Includes the `Book` data model, `APIService` for fetching books, and `CoreDataManager` for local data storage.
  
- **ViewModel**: 
  - Acts as a mediator between the View and Model layers.
  - Handles data fetching, filtering, and state management (loading/error states).
  - The `BookViewModel` class publishes data updates for the View to observe.

- **View**: 
  - The user interface layer, represented by `MainViewController`.
  - Displays a collection of books and allows user searches.
  - Listens to the ViewModel for updates to reflect changes in the UI.

- **Combine Framework**: 
  - Manages reactive data flows and subscriptions between the ViewModel and View.
  - `@Published` properties in the ViewModel automatically update the View when data changes.

---

## 2. Design Decisions

- **Dependency Injection (DI)**: 
  - The ViewModel uses DI for the `APIServiceProtocol`, allowing easy swapping of implementations (e.g., mock services for testing).

- **Combine for State Management**: 
  - Combine is used to bind data updates from the ViewModel to the View, ensuring the UI responds to state changes automatically.

- **Separation of Concerns**: 
  - Each component (Model, ViewModel, View) has a distinct responsibility, making the code modular and easier to maintain.

- **Testability**: 
  - The ViewModel is designed for easy testing with mock services to simulate API responses.

---

## 3. Setting Up the Project

### Requirements
- **Xcode**: Version 14.0 or later
- **Swift**: Version 5.3 or later
- **iOS Deployment Target**: iOS 14.0 or later
- **CocoaPods**: For managing third-party libraries

### Libraries/Frameworks Used
- **Combine**: For managing reactive state and data flow.
- **CoreData**: For local storage of favorite books.

---

## 4. Running the Project

### Clone the Repository
git clone https://github.com/tennet0505/Books_iOS.git
cd Books_iOS

### Install CocoaPods
- **pod install

### Open the Project in Xcode
- **Open Books_iOS.xcodeproj in Xcode.

### Build & Run
- **Select your target device or simulator.
- **Click the Run button or press Cmd + R to build and run the app.

## 5. Unit Testing

### Unit Test Setup
- **The project includes unit tests using mock services to simulate API responses for testing the ViewModel.

### Running Tests
- **Select the Books_iOSTests target in Xcode.
- **Press Cmd + U to run the tests.
- **Test cases are located in the Books_iOSTests folder.

## 6. Future Improvements
- **Error Handling: Implement robust error handling with retry mechanisms.
- **UI Enhancements: Improve loading indicators and error state displays.
- **Offline Mode: Expand local caching to allow offline functionality.
