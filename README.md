# Incubit code assessment

## Overview

This is ruby on rails application built for [code assessment](https://hackmd.io/@IncWebTeam/SkJyknsSN?type=view) from Incubit company interview process. 


## How to run

* Please be prepared with `ruby-2.7.1` if you don't have. 
  You can use any ruby version manager(fyi, i'm using [asdf](https://github.com/asdf-vm/asdf))
* Clone the repo and update the [database connection info](./config/database.yml#L23-L25)
    You will need the database user with db creation permission.

```bin/bash
$ cd incubit-assessment
$ bundle install # install all required dependencies
$ rails db:create db:migrate # Create database and run migration
$ rails s # start server
``` 

You can run testing with ```bundle exec rspec``` command.

## Goals 

Here's the list of completed goals

- [X] As a user, I can visit sign up page and sign up with my email (with valid format and unique in database) and password (with confirmation and at least eight characters).
- [X] When I sign up successfully, I would see my profile page.
- [X] When I sign up successfully, I would receive a welcome email.
- [X] When I sign up incorrectly, I would see error message in sign up page.
- [X] As a user, I can edit my username and password in profile page. I can also see my email in the page but I can not edit it.
- [X] When I first time entering the page, my username would be my email prefixing, e.g. (email is “user@example.com” , username would be “user”)
- [X] When I edit my username, it should contain at least five characters. (Default username does not has this limitation)
- [X] As a user, I can log out the system.
- [X] When I log out, I would see the login page.
- [X] As a user, I can visit login page and login with my email and password.
- [X] As a user, I can visit login page and click “forgot password” if I forgot my password.
- [X] When I visit forgot password page, I can fill my email and ask the system to send reset password email.
- [X] As a user, I can visit reset password page from the link inside reset password email and reset my password (with confirmation and at least eight characters).
- [X] The link should be unique and only valid within six hours.

Also it meets the demand of following concerns

- [X] Use PostgreSQL
- [X] Do not use third party library for user registration. (e.g. Devise)
- [X] Please use https://github.com/ryanb/letter_opener for the email in development environment.
- [X] Write test code in any test suite you like.
- [X] Use Git for version control with WELL commit message.
- [X] Write README about how to get start for the project.
