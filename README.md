


# Dooro Learning

## 1. Descriptions 

Dooro Learning is an IOS app developed for love of Dooro Bear and fun of programming. In this project, hangman game from software development course is incorporated with flashcard function for better learning objective. Multiple login method like email/password, facebook login and google login are employed here for realize independent learning purpose. Firebase is utlized to manage multiple user's login information. 

## 2. Features
- Sign up a new account with email address and self-defined password 

  - changing the visibility of the password by clicking on the eye icon
  - validating password format ( > 6 letters) and agreement with the previous input
  - checking whether the entered email address has already been registered
 
![signup and password validating](https://user-images.githubusercontent.com/42850817/125170343-4e3cde80-e174-11eb-8d12-32ecd1556533.gif)
<p align="center">
   Gif.1 sign up with a new email and validate the password
</p>

![prohibiting signup with existing email](https://user-images.githubusercontent.com/42850817/125170568-2601af80-e175-11eb-8636-5f77c30f33db.gif)

<p align="center">
   Gif.2 prohibiting users from signing up again using the existing emaill address
</p>

- Retreive an account when password is forgotten by sending a password reset link to the email address and check whether the input email is still valid

![forget your password](https://user-images.githubusercontent.com/42850817/125171922-703a5f00-e17c-11eb-82e2-cc7accfe6d0c.gif)

<p align="center">
   Gif.3 Retreive an account when password is forgotten
</p>

![password reset](https://user-images.githubusercontent.com/42850817/125172029-e8a12000-e17c-11eb-9b93-f21f2a22c600.gif)

<p align="center">
   Gif.4 Reset account password by following the instructions in the link
</p>

- Log in using email and password which have been registered, and vailidate whether the account is exisiting and whether the password matches the email

![sign in using password and email address](https://user-images.githubusercontent.com/42850817/125170529-07031d80-e175-11eb-9a3a-1d59be7d8c24.gif)

<p align="center">
   Gif.5 Sign in using email address and password
</p>

- Log in and log out using facebook account
  - grasp user information like first name, email address, profile photo, and login credential
  - display user information in the welcome message in the app
  - if facebook log in is not exited, auto log in with previous account information

![log in and log out with facebook](https://user-images.githubusercontent.com/42850817/125170179-47619c00-e173-11eb-9bc4-c910cd480e4d.gif)


<p align="center">
   Gif.6 Log in and log out using Facebook account
</p>

![autologin with facebook](https://user-images.githubusercontent.com/42850817/125170494-dde28d00-e174-11eb-8cb9-51156d310897.gif)

<p align="center">
   Gif.7 Autologin using Facebook when user didn't log out previously
</p>

- Log in and log out using Google account
  - grasp user information like first name, email address, profile photo, and login credential
  - display user information in the welcome message in the app
  - if facebook log in is not exited, auto log in with previous account information

![google login and logout](https://user-images.githubusercontent.com/42850817/125172802-3cae0380-e181-11eb-975f-f79a2d9cb69b.gif)

<p align="center">
   Gif.8 Log in and log out using Gmail account
</p>

![autologin with gmail](https://user-images.githubusercontent.com/42850817/125172994-556ae900-e182-11eb-9745-3309eb720ac3.gif)


<p align="center">
   Gif.9 Autologin using Gmail when user didn't log out previously
</p>

- Flashcard Mode has add, delete, search, guess, and explanation functionality
  - add functionality allows you to add new card of interest with hint and explanation
  - delete functionality allow you to delete the existing card which you don't want anymore
  - search functionality will enables you to find the word of interest
  
    - placeholder is utilized here to help user know what the field is for
  
  - In the guess mode, the hint will be shown firstly. 
    
    - When you swipe to the right, you will get the hints of the new word. 
    - When you swipe up, you will get the explanation of the word. 
    - When you swipe down, you will get the hints of the word.
    
  - In the explanation mode, the hint will be shown firstly. 
  
    - When you swipe to the right, you will get the hints of the new word. 
    - When you swipe up, you will get the explanation of the word. 
    - When you swipe down, you will get the hints of the word.
    
![flashcard display swipe search delete functions](https://user-images.githubusercontent.com/42850817/125173057-a8dd3700-e182-11eb-91be-12edf1e65ea2.gif)

<p align="center">
   Gif.10 demonstration of flashcard functionality
</p>

- manage each user's login information using firebase and corresponding database using core data
  - assign a unique id to each user
  - preset 15 flashcards for each user
  - the changes resulting from deletion and addition will be saved and reflected in the database

![each user has its own database](https://user-images.githubusercontent.com/42850817/125173820-d1ffc680-e186-11eb-97f4-27c6f0d5c5ad.gif)

<p align="center">
   Gif.11 demonstration of each user's database
</p>

- Hangman Mode allow users to play with the words they have already added
  - new game will start a new game for you
  
    - when there is no card to play with, you will be automatically redirected to the adding mode
    
![hangman final card](https://user-images.githubusercontent.com/42850817/125175721-80aa0400-e193-11eb-9df8-fa0be48c22a1.gif)
<p align="center">
   Gif.12 if there is only one card left, hangman will redirect to add new card mode
</p>
    
  - you only have 5 chances to enter a wrong letter
  - letters you have already entered will be saved in the letter bank label
  - view scroll is implemented here to enable users to see more when the label field is not enough to display everything
  - when you are entering letters, the keyboard will be enabled. Otherwise, the keyboard will be hidden.
  - when you win you will be automatically redirected to the win view controller. After that you will have three choices, they are starting a new game, exiting the game and seeing the explanations.

![hangman win](https://user-images.githubusercontent.com/42850817/125175491-2ceaeb00-e192-11eb-9700-f4e7dfe439a4.gif)

<p align="center">
   Gif.12 win the game and get redirected to hangman win view controller
</p>

![hangmanwin split 3](https://user-images.githubusercontent.com/42850817/125175538-7f2c0c00-e192-11eb-9a30-d08f5cd7ce46.gif)

<p align="center">
   Gif.13 avilable choices in hangman win view controller: new game, explanation, and exit
</p>

  - when you loose you will be automatically redirected to the loose view controller. After that you will have three choices, they are starting a new game, exiting the game and seeing the explanations.

![hangman loose explanation](https://user-images.githubusercontent.com/42850817/125174972-be585e00-e18e-11eb-96cd-2cd3ac5ceaa9.gif)

<p align="center">
   Gif.14 loose the game and get redirected to hangman loose view controller
</p>

![loose split three](https://user-images.githubusercontent.com/42850817/125174999-f364b080-e18e-11eb-9ba2-62a7ee70215d.gif)

<p align="center">
   Gif.15 avilable choices in hangman loose view controller: new game, explanation, and exit
</p>

  - In the explanation field, you have four choices which are deleting the word, adding a new word, starting a game, returning back to the choose mode view controller.




## 3. Requirements
- IOS 9.0
- Xcode 9.3
- CocoaPods 1.10.1

An Apple Developer Program account is required to run any sample app on a physical device. In order to provision your device, edit the sample app bundle identifier to make it unique to your organization.

## 4. Installation

- To ensure you are using the latest releases of the Dooro Learning software components, update your Podspec repository before building any of the sample applications by running the following on the command line:

`pod repo update`

- Unless otherwise instructed, samples can be run by following these steps:

  1. From the project directory, run `pod install`.
  2. Open the corresponding .xcworkspace file.
  3. There are README.md files in several of the samples that provide additional setup steps that are specific to those examples.
  - Note: If you intend to use these samples offline, be sure to run Cocoapods before going offline in order to download the required dependencies.


## 5. Contribute

Dooro Learning app is a free and open source project developed by volunteers. Any contributions are welcome. Here are a few ways you can help:

- [Report bugs and make suggestions.](https://github.com/berylxzhang/Dooro-Learning/issues)
- Write some code. Please follow the code style used in the project to make a review process faster.

## 6. License

This application is released under MIT (see [LICENSE](https://github.com/berylxzhang/Dooro-Learning/blob/main/LICENSE)). Some of the used libraries are released under different licenses.
