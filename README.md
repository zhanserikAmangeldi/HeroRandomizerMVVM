# HeroApp

A SwiftUI application that displays information about superheroes using the Superhero API.

## Setup Instructions

1. Clone the repository:

```bash
git clone https://github.com/zhanserikAmangeldi/HeroRandomizerMVVM.git
```

2. Open `HeroApp.xcodeproj` in Xcode:

```bash
open HeroRandomizerMVVM.xcodeproj
```

3. Run the app using the simulator or a physical device.

## Architecture

This project uses the MVVM (Model-View-ViewModel) architecture with a Router for navigation:

* **Models** : Data structures for API responses and display
* **Views** : SwiftUI views for user interface
* **ViewModels** : Business logic and state management
* **Router** : Navigation between screens
* **Services** : API communication

### Key Features

* Hero list with search functionality
* Detailed hero information (power stats, biography, appearance)
* Error handling and loading states
* Clean, responsive UI

The app makes network requests to the **[Superhero API](https://akabab.github.io/superhero-api/)** using URLSession and Swift's async/await functionality.

## Video Demonstration

You can watch the demonstartion from youtbue: [https://youtube.com/shorts/XHk3A-kxwUk](https://youtube.com/shorts/XHk3A-kxwUk).
