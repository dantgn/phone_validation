# PhoneValidation

This gem is a phone number validator using [numverify.com API](https://www.numverify.com).

In order to use this gem, first you need to create an account (there are free accounts) to get an access token, which will be required everytime you request a validation for a new phone number.

#DONE: Request phone number validations

#TODO: use API ability to specify country_code parameter on request

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

## Error handling

Errors on initialize

```ruby
PhoneValidation::Client.new(nil,'+34977123123')
    # => PhoneValidation::Errors::InvalidToken: Token can't be nil

PhoneValidation::Client.new('token',nil)
    # => PhoneValidation::Errors::InvalidNumber: Phone number can't be nil    
```

Errors from 3rd party API (numverify.com)

```ruby
phone = PhoneValidation::Client.new('wrong_token', '+34977123123')
phone.valid?
    # => PhoneValidation::Errors::ApiInternalError: You have not supplied a valid API Access Key. [Technical Support: support@apilayer.com]

# Original API response
{
  "success":false,
  "error":{
    "code":101,
    "type":"invalid_access_key",
    "info":"You have not supplied a valid API Access Key. [Technical Support: support@apilayer.com]"
  }
}

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dantgn/phone_validation.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
