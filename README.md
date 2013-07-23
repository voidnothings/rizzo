# Avocado 
___Lonely Planet Javascript Library___

## Installation

Add this line to your application's Gemfile:

    gem 'avocado'

And then execute:

    $ bundle

## Running tests

To use grunt with avocado:

- To clean, compile and run all the tests headlessly
````bash
  $ grunt
````

- To run them headlessly without compiling them all, and to enable watching of files (like guard)
````bash
  $ grunt dev
````

- To spawn a server and rerun failed tests
````bash
  $ grunt wip
````

- To run plato (sourcecode analysis)
````bash
  $ grunt report
````