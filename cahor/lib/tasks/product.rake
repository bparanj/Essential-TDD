namespace :zepho do
  desc "Create a sample product for testing"
  task :product => :environment do
    user = User.first
    user.products << Product.new(price: 2.00, name: 'Essential TDD') 
    user.save
  end
end
