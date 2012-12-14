# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new(email: 'bparanj@gmail.com', password: 'secret')
user.primary_paypal_email = 'lookup-receiver-email-from-orders-or-transaction'
user.password_confirmation = 'secret'
user.products << Product.new(price: 2.00, name: 'Essential TDD') 
affiliate = Affiliate.new
user.affiliate = affiliate
user.save!

affiliate.referrer_code = 'nibj5o3q4m'
affiliate.save!



