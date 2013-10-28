# TowerData (Rails)

The `towerdata-rails` gem provides a Ruby wrapper to the [TowerData REST API](http://www.towerdata.com/api). In addition to a module, methods, and classes for explicit calls to the API, the gem provides an email validator and a phone number validator for ActiveModel classes.

## Installation

Add this line to your application's Gemfile:

    gem 'towerdata-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install towerdata-rails

## Configuration

TowerData requires an API token for all requests. ([Get one here](http://info.towerdata.com/real-time-free-trial).) To configure your app with your token, add this code in an initializer or somewhere similar.

    TowerData.configure do |c|
      c.token = 'MY_TOKEN'
    end

### Optional Config Settings

**These settings are used by the Email Validator**
* **c.show_corrections**:
  * function: if a record is invalid, the error report will include suggested corrections
  * default: true

* **c.auto_accept_corrections**:
  * function: if there are any suggested corrections, the validator will take the first one (record is reported as valid
  * default: false

## Usage

### Email Validation

    email = TowerData.validate_email('address@domain.com')

After this call, `email` will be an instance of [`TowerData::Email`](https://github.com/eLocal/towerdata-rails/blob/master/lib/tower_data.rb#L80-L101). This wrapper class exposes all the values from the JSON returned by TowerData. Use `email.ok` for a quick check if the email address is valid.

### Phone Validation

    phone = TowerData.validate_phone('123-456-7890')

After this call, `phone` will be an instance of [`TowerData::Phone`](https://github.com/eLocal/towerdata-rails/blob/master/lib/tower_data.rb#L104-L134). This wrapper class exposes all the values from the JSON returned by TowerData. Use `phone.ok` for a quick check if the phone number is valid.

### ActiveModel

    class ModelWithEmailAndPhone
      include ActiveModel::Model
      include ActiveModel::Validations
      include TowerData

      attr_accessor :email, :phone

      validates :email, email: true
      validates :phone, phone: true
    end

## Custom Providers

Although the gem was written to be a validation wrapper for TowerData, it also supports extension through other providers.

1. Create a new subclass of [`TowerData::Provider`](https://github.com/eLocal/towerdata-rails/blob/master/lib/tower_data/providers.rb#L8-L16), overriding the methods `validate_email` and `validate_phone` with whatever logic is appropriate. **NOTE:** these methods are intended to return `TowerData::Email` and `TowerData::Phone` objects. If you return something else, results may not be what you expect.
2. Immediately after your config block, add the following line:

    `TowerData.provider = CustomProviderClass.new`

3. Run validations as normal

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
