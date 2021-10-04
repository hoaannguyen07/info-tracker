# README

## Introduction ##

We are creating a web application which is used to keep track of other table tennis players’ strengths and weaknesses. It will store personal wins and losses against each player. It will allow users to create opponent entries, edit player information, delete players, and read player data.

## Requirements ##

This code has been run and tested on:

* Ruby - 3.0.2p107
* Rails - 6.1.4.1
* Ruby Gems - Listed in `Gemfile`
* PostgreSQL - 13.3 
* Nodejs - v16.9.1
* Yarn - 1.22.11


## External Deps  ##

* Docker - Download latest version at https://www.docker.com/products/docker-desktop
* Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
* Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

## Installation ##

Download this code repository by using git:

 git clone https://github.com/hoaannguyen07/info-tracker.git
 
## Tests ##

An RSpec test suite is available and can be ran using:
 


  rspec spec/models/. --format documentation
  rspec spec/routing/. --format documentation

## Execute Code ##

Run the following code in Powershell if using windows or the terminal using Linux/Mac

  `cd your_github_here`

  `docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 dmartinez05/ruby_rails_postgresql:latest`

  `cd rails_app`

Install the app

  `bundle install && rails webpacker:install && rails db:create && db:migrate`

Run the app
  `rails server --binding:0.0.0.0`

The application can be seen using a browser and navigating to http://localhost:3000/

## Environmental Variables/Files ##

Environment variables `GOOGLE_OAUTH_CLIENT_ID` and `GOOGLE_OAUTH_CLIENT_SECRET` will be put at the bottom of the `/config/environments/development.rb` file

## Deployment ##

Please go to this link and follow the directions:

https://docs.google.com/document/d/1_aoIk1Mjbw8vhL84O23qKoUy2tRveq27AsUUaJmcKsA/edit?usp=sharing


## CI/CD ##

Please go to this link and follow the directions:

https://docs.google.com/document/d/1_aoIk1Mjbw8vhL84O23qKoUy2tRveq27AsUUaJmcKsA/edit?usp=sharing

## Support ##

Please go to Piazza and raise your concern with the key phrase "info tracker" in your question and we will get back to you as soon as we can. 

