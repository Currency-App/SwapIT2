# SwapIt

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app allows users to exchange currency with those others that are traveling to avoid the unnecessary transaction fees at airports and other exchange centers.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Networking / Currency
- **Mobile:** This app would primarily be developed for mobile, since many of these transactions would be simple and on-the-go.
- **Story:** Avoids transaction fees in currency exchanges.
- **Market:** Any traveling individual could choose to use this app, and to maintain user trust, each user would have a reliability rating.
- **Habit:** This app can be used at any time the user prefers, especially while traveling, to exchange means of currency.
- **Scope:**Primarily, we would focus on getting people with those willing to exchange in their area. After, we would implement certain chat rooms and connections.


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can see the locations of other users for exchange through a map
* Users can contact other users for details in exchange
* Users can login to the app
* Users can sign up for an account
* Users can create their own profile

**Optional Nice-to-have Stories**

* Users can review other users regarding their exchange experience

### 2. Screen Archetypes

* Login
   * Users can choose to login or sign up for an account. 
* Registration screen
   * users can sign up for an account
* Profile Page
   * Users can establish a profile to determine their credibility and / or currency they are looking for / can provide for exchange. 
* Messages Page
   * Users can contact the person to exchange through the message function to negotiate price and to meet up.
* Exchange Search Screen
   * Users can view the locations of the people who can provide the desired currency exchange through the map

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Exchange page
* Profile page
* Message page


**Flow Navigation** (Screen to Screen)

* Sign up/Login => Exchange screen
* Exchange screen => Message screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="swappit-app.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups
https://xd.adobe.com/view/ca76cdc7-bab4-4807-488e-87034eac68da-bc47/

### [BONUS] Interactive Prototype
https://xd.adobe.com/view/ca76cdc7-bab4-4807-488e-87034eac68da-bc47/

## Schema 
### Models
#### Sending Messages

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | user’s username to identifies their account |
   | message        | String | message that the user sends |
   | timeSent         | DateTime    | time a message was sent |
#### Finding exchanges
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | user’s username |
   | amount      | Number | amount of money that the user wants to exchange |
   | currencyStart      | String    | currency that user has |
   | currencyEnd     | String    | currency that user would like to exchange to |
   | location      | Location    | User's location to find matches nearby |
   | timeExchange      | DateTime    |time exchange request was made |
#### Currency rates

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | base      | String   | the base currency type |
   | date        | Date | the date of the rate |
### Networking
#### List of network requests by screen
* Home Feed Screen
  * (Read/GET) Query the current currency rate from the network
* Create Message Screen
  * (Create/POST) Create a new message object
* Profile Screen
  * (Read/GET) Query logged in user object
    ```swift
         let query = PFQuery(className:"Post")
         query.whereKey("author", equalTo: currentUser)
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```
  * (Update/PUT) Update user profile image
* SwapIt Screen
  * (Read/GET) Query locations of swappers through the map function
  * (Read/GET) Query all available exchanges where user are swappers
#### OPTIONAL: List endpoints if using existing API such as Yelp
##### An API of currency rate
- Base URL = https://exchangeratesapi.io
HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /latest | latest exchange rate
    `GET`    | /latest?Base=USA | Base as USD exchange rate
