![ruby](https://img.shields.io/badge/Ruby-2.3.0-green.svg)
![rails](https://img.shields.io/badge/Rails-4.2.7-green.svg)

**IMOBILIARIA**

A system to sell and rent houses, build with Ruby 2.3.0 and Rails 4.2.7.

To use just make a clone or fork and run

<code> $ bundle install </code>

After install dependencies, run

<code>$ rake db:create db:migrate</code>

To create the database

And to start the server and access the application, run

<code> $ rails server</code>

You can access the application with <code>http://localhost:3000</code>

For a initial use you can run <code>rake db:seed</code>

It will create 3 users: **admin@imob.com**, **agent@imob.com** and **customer@imob.com**. The password for the 3 users is **123456**

To execute the test, just run

<code>rspec</code>
