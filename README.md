Codepath Group Project - README Template
===

# FoodShare

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The FoodShare app is an app to help nearby on-campus students share excess food with each other. They can post excess food that they have and request food from others on-campus. If someone has something they would like to share, they can private message the student and collaborate on when and where to meet up. This app is meant to help students get to know their neighbors and to help those in need on-campus.

### App Evaluation

- **Category:** Food and Lifestyle
- **Mobile:** iOS app
- **Story:** Connects users with neighbors in order to share excess food. The user can message other students to request/offer their excess food
- **Market:** On-campus college students
- **Habit:** This app can be used whenever they are cooking food, probably using the app every week or more
- **Scope:** All campus students, apartment residents, condominiums

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [X] Users can login/logout 
* [X] Users can create an account
* [X]Users can post that they have excess food
* Users can directly message each other to request/offer food
* [X]Users can scroll through lists of existing requests/offers
* Users can filter the existing requests/offers
* Users can close their post when it is accepted

**Optional Nice-to-have Stories**

* Nice to be able to friend other users so they can appear first
* Nice to have categories for popular items
* Nice to restrict access to .edu emails only
* Nice to search offers based on proximity or type

### 2. Screen Archetypes

* Login Screen
* Register Screen
   * Users can create an account
* Scroll Screen
   * Users can scroll through lists of existing posts
* Creation Screen
   * Users can post that they have excess food
* Messaging Screen
   * Users can directly message each other to request/offer food
   * Users can close their post when it is accepted

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Scroll Screen
* Messaging Screen
* Creation Screen
* Settings Screen

**Flow Navigation** (Screen to Screen)

* Forced Login -> Account creation if no login is available
* Post selection -> Messaging screen to accept the offer
* Messaging selection -> Individual messaging chats
* Logout -> Login screen

## Wireframes
<img src="https://imgur.com/4sZ0U1G.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://imgur.com/t94De0E.jpg" width=600>

### [BONUS] Interactive Prototype
<img src="https://recordit.co/wtq8vnR2Dx.gif" width=300>

## Schema 

### Models
Post

| Property | Type | Description |
| -------- | ---- | ----------- |
| objectId | String | unique id for the user post |
| imageFood | file | food image that user posts |
| description | String | post description that user posts |
| createdAt | DateTime | date when post is created |
| author | Pointed to User | author of post |
| authorImage | file | author's profile picture |
| givingFood | boolean | boolean for if they are giving or requesting food |

### Networking
**Login**

* Create/POST: Verify login credentials
* API/GET: Use API to verify UCSD email

**Sign-up**

* Create/POST: Verify login credentials
* API/GET: Use API to verify UCSD email
* Update/PUT: Choose Avatar from selection of images

**Home(Give/Request Food)**

* Read/GET: Update user’s feed 
* DELETE: User had option to delete their own post
* Create/POST: User has the abity to create new post

**Home(Your Posts)**

* Read/GET: Update user’s feed 
* DELETE: User had option to delete their own post 
* Create/POST: User has the abity to create new post
* Update/PUT: Update Sold Status

**Messages Screen**

* Read/GET: Update user’s feed 
* DELETE: User had option to delete conversations with others

**Individual Messages**

* Read/GET: Update user’s feed 
* DELETE: User had option to delete conversation or invidual texts from either the recipiant or the sender
* Create/POST: Create and send new Messages

**Add Post**
* Create/POST: User can create new post
* Create/POST: User can type in text bars and specify what foods they have or need and
* User can choose to give or request food
* Update/PUT: If giving food, user can upload picture of it
* Read/GET: Update feed with user’s new post

**Settings**

* Create/POST: User can logout
* Create/POST: User can update their name, email, password, college
* API/GET: Use API to verify UCSD email if they are updating their email
* Update/PUT: Choose and update Avatar from selection of images

### Gifs
**Milestone 1**
https://imgur.com/n7TAjWW

**Milestone 2**
https://vimeo.com/411536698

**Milestone 3**
https://imgur.com/a/w4PKAtq

**Final Video**
https://www.youtube.com/watch?v=PlzyGif91xQ
