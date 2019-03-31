# PhoneValidation

This gem is a phone number validator using [numverify.com API](https://www.numverify.com).

In order to use this gem, first you need to create an account (there are free accounts) to get an access token, which will be required everytime you request a validation for a new phone number.

#DONE: Request phone number validations

#TODO: send country_code parameter on request

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phone_validation', :git => 'https://github.com/dantgn/phone_validation.git'
```

And then execute:

    $ bundle


## Usage

Initialize PhoneValidation Client with your token from [numverify.com](https://www.numverify.com).


```ruby
phone = PhoneValidation::Client.new('token', '+34977123123')
```

ask the client for

```ruby
phone.valid? # => true
phone.number # => '34977123123'
phone.local_format # => '977123123'
phone.international_format # => '+34977123123'
phone.country_prefix # => '+34'
phone.country_code # => '34'
phone.country_name # => 'Spain'
phone.location # => 'Tarragona'
phone.carrier # => ''
phone.line_type # => 'landline'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phone_validation.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
