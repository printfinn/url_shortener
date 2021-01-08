# Shortener Lite: A simple url shortener


* Ruby version: 2.7.0

* Rails version: 6.0.2.2

* System: Tested on MacOS, with rbenv

* Database: Tested with Mysql2 on MacOS, ClearDB on Heroku 

* How to run the test suite: WORKING IN PROGRESS

## A url shortener service with Ruby on Rails

### Online Demo 
Check this [HerokuApp](https://finn-url-shortener.herokuapp.com/)

### RESTful API Document
This app supplies not only a web page service, but also a RESTful API which you can use command line tools like cURL to interact with.

Here are some examples:

* To recover the original url from a shortened link:
```cmd
curl \
http://www.example.com/shortened_link \
-H "Content-Type: application/json" \
-H "Accept: application/json" 
```
* To generate a shortened link with full_link:
```cmd
curl -X POST \
http://www.example.com/api/v1/links \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
  "link": {
    "full_link": "www.example.com"
  }
}'
```

### Code Structure
* Controller:
  * StaticPages Controller 
  * Links Controller
  * api/v1/Links Controller
* Model:
  * Link Model
* View
  * Links
    * New
    * Show
  * static_pages
    * Home

### How this works
This service takes advantage of the increase only primary id of database. For every shortened link generated, it is a map from this database record's primary id to a dictionary.
The dictionary is consisted of only numbers and English characters, 0-9A-Za-z, 62 characters in total.
The shortened link is at most 6 chars, which means there can be at most 62^6 = 56,800,235,584 items. That's 56 billion links. (Theoretically, if database supports)
