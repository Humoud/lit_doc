# Lit Doc
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

## Development

run tests with `rake spec`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Humoud/lit_doc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
