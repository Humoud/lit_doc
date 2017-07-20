# Lit Doc 🔥
[![Build Status](https://travis-ci.org/Humoud/lit_doc.svg?branch=master)](https://travis-ci.org/Humoud/lit_doc)

**this gem hasn't been released yet**

This gem is a collection of Rake Tasks that make writing docs easier by
allowing you to write the docs inside ruby files.
It also makes documentation much less of a repetitive process.
That is done by using the Lit Doc code to generate the repetitive parts of the doc.

## Installation

this gem hasn't been released yet

## Usage

1. run `rails lit_doc:prepare` generate the following:
  1. doc/source/source.md
  2. doc/gen/generate.md
2. in source.md import the files that contain lit doc documentation like so:
  * `@import "app/controllers/application_controller.rb"`
3. run `rails lit_doc:generate` to generate a doc. You can find the result in doc/gen/generate.md.

## End Goal Usage Scenario
in source.md:

have a mixture of markdown syntax and "@import 'rails.root/path_to_file'" statements
the markdown syntax will be copied as it is to the generate.md while the imported files
will be scanned for Lit Doc code.

Lit Doc code example:
Let's say we have a controller that we want to document some actions/methods in it.
above each action that the user wishes to document, he/she will use the following syntax:

**NOTE:** Lit Doc syntax starts with 2 hashtags
``` ruby
## @h: header text
## @r: http method route
## @b-model: path to model
## @b-serializer: path to serializer
## @res-model: path to model
## @res-serializer: path to serializer
## regular markdown
def index
  ## do something
end

# Example:
# in app/controllers/users_controller.rb
class UsersController < ApplicationController
  ## @h: User Create
  ## @r: POST /users
  ## @b-model: User
  ## @res-model: User
  ## **NOTE:** This needs optimization
  def create
    ## do something
  end
end

# and in app/models/user.rb
class User < ApplicationRecord
  ## @b:
  ##  {
  ##    name: 'tim',
  ##    email: "tim@mailz.com"
  ##  }

  ## @res:
  ## {
  ##   name: 'tim',
  ##   email: "tim@mailz.com",
  ##   updated_at: "91231-543-157",
  ##   created_at: "123-1231-123"
  ## }
end
```

A brief example of the Lit Doc code/syntax:

* `@h` means header.
* `@r` means route.
* `@b` means body and `@res` means response.
* `@b-model` means generating body using model  and `@res-model` means generating
* response using model.

## Development

run tests with `rake spec`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Humoud/lit_doc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
