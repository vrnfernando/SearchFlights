# SearchFlights Readme
Sample App using Swift 5

## Overview

This Flight Search iOS app is a simple tool that allows users to search for flights by specifying their departure and arrival locations, along with the date of travel and the number of adults, teenagers, and children in the group. The app utilizes Alamofire for making network requests and CocoaPods for managing third-party libraries.

## Features

1. **Select Departure and Arrival Locations**: Users can choose their departure and arrival locations from a list of available options.

2. **Select Travel Date**: Users can pick the date they wish to travel on using a date picker.

3. **Specify Passenger Count**: Users can specify the number of adults, teenagers, and children in their travel group.

4. **Search for Flights**: The app provides a button to initiate a flight search based on the selected criteria.

5. **Network Request**: Alamofire is used to handle the network requests to retrieve flight search results.

## Installation

To run this app on your iOS device or simulator, follow these steps:

1. Clone the repository to your local machine.

2. Navigate to the project directory.

3. Run `pod install` to install the required CocoaPods dependencies.

4. Open the `.xcworkspace` file in Xcode.

5. Build and run the app on your preferred iOS device or simulator.

## Usage

1. Launch the app on your iOS device or simulator.

2. On the main screen, select your departure and arrival locations from the available options.

3. Choose your travel date using the date picker.

4. Specify the number of adults, teenagers, and children in your group.

5. Tap the "Search Flights" button to initiate the search.

6. The app will make a network request using Alamofire to retrieve flight search results.

7. Display the search results to the user, showing available flights based on the selected criteria.

## Dependencies

This app relies on the following third-party libraries, which are managed using CocoaPods:

- **Alamofire**: Used for making network requests to fetch flight search results. More information can be found [here](https://github.com/Alamofire/Alamofire).

## Contributing

If you'd like to contribute to this project, feel free to fork the repository and submit a pull request with your changes. We welcome contributions to improve and enhance the app.


**Happy flight searching! 🛫**
