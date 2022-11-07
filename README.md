# FaceGestureDetection
CocoaPod Library for swift 

## Setup
###  How to Use?
Open terminal at your project directory path 

### How to Start Working?
1. The `master` branch should have the latest stable code. And the `Dev-Backend` is being used to merge everyday code between developers.
2. Open shell window/terminal and navigate to project folder
4. Run `pod install`
5. Open `CarrierApp.xcworkspace` and run the project on selected device or simulator

### Environment Variables
##### 1. API BaseUrl
The `baseUrl` can be changed from `Constants.swift` file to point to stagging, production or live enviroments. 
**Stagging** is for Developent
**Production** is for Client Testing
**Live** is for the Live App Store
##### 2. Firebase
`GoogleService-Info.plist` file is already installed from Firebase, which can be replaced by downloading form Firebase Console
##### 3. Google Maps
Google Maps is already integrated. Its API Key is assigned `googleAPIKey` in `Constants.swift` file, and can be changed by getting a new key from Google Developer API Console

### Deployment
##### How to publish the app:
1. You need to first Sign-In to your apple developer account into the xCode
2. After successful Sign-In you will need to select the project file from left navigation for files. Then you need to select Signing and Capabilities
3. Here you need to select your LLC. This LLC will start to appear after connecting your apple developer account with xCode. 
4. Now You need to select the general tab from which is on the left side of the Sign-in Capabilities tab. Update the version number as apple does not accept older versions.
5. Now select the product options from the top menu bar. Here you need to select Archive. Now wait sometime as it is going to take a while.
6. After successful archiving, the Organizer window will show up.
7. Select your archived build from here and click on the Distribute App button.
8. On clicking the Distribute App you need to select the distribution method as “AppStore Connect ” is the correct method. Then new window will appear
9. If the certificates are correctly installed in your system no problem will appear and things will work perfectly fine. But in case you do not have the correct certificate, you’ll need to create a new distribution certificate and automatic signing will do everything for you. 
10. You need to select all the options here and Click next. This will take sometime.
11. In this new Window select upload and click on next. 
12. Now after some time the Upload window will appear. Now click on Upload button the application will start to upload and progress bar will appear.

In a few mintues, the App should be available under the TestFlight section on [App Store Connect](https://appstoreconnect.apple.com/ 'App Store Connect') for Beta Testing and Publishing to the App Store.


## TEST CASES
The Test Cases are majorly distributed amongst 2 Targets:
1. UI Test Cases
`EnMassTransitUITests`
2. API Test Cases
`EnMassTransitAPITests`

#### API Tests
The API Tests have 2 files:
##### Onboarding APIs
`EnMassTransitAPIOnboardTests`
##### Tests after Log-In
`EnMassTransitAPITests`
To run these tests that require a logged-in user, the user AuthToken should be set in the `setUpWithError()` function
```bash
DataManager.shared.saveAuthToken("a96201bf94444ba5ee1757bc66cbb782dd80838a")
```
The **Listing Test functions** can be run directly.
But the **Details Test Functions** that fetch details of a particular entity (e.g dispatch, quotation, etc) require that entity's ID be set within that function for which we intend to fetch the details of:
1. `testDispatchesDetailAPI()`
2. `testQuotationsDetailAPI()`
