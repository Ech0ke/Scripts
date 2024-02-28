# Print to console
puts 'Hello, World!'

# Local variable
str = "variable"

# Global variable
$str = "variable"

# Constants
STR = "variable"

# Method paranthesis are optional
name = "John".upcase


=begin
puts "Hi!"
puts "Hi!"
puts "Hi!"
puts "Hi!"
=end


result = "Happy Birthday!".include?("Happy")
puts result # True



number = 8
puts "I have #{number} oranges." # I have 8 oranges

myHash={
    Key: "value",
    Key2: "value2",
}
puts myHash[:Key] # value


num = -5

if num > 0
    puts "Number is positive"
elsif num < 0
    puts "Number is negative"
else
    puts "Nuber is neither positive, neither negative"
end

unless num <= 0
    puts "Number is positive"
  else
    unless num == 0
      puts "Number is negative"
    else
      puts "Number is neither positive nor negative"
    end
  end

def sum2(num1, num2)
    num1 + num2
end

num1 = 5
num2 = 3

result = sum2(num1, num2)
puts result

x = 0
while x < 5 do
  puts "Value of x: #{x}"
  x += 1
end

x = 0
until x == 5 do
  puts "Value of x: #{x}"
  x += 1
end

class Car
    @@total_cars = 0
    
    attr_accessor :make, :model
    
    def initialize(make, model)
      self.make = make
      self.model = model
      @@total_cars += 1  
    end
    
    def display_info
      puts "Make: #{make}, Model: #{model}"
    end
    
    def self.total_cars
      @@total_cars
    end
  end

  
car1 = Car.new("Toyota", "Camry")
car1.model = "GR86"

puts Car.total_cars # 1

car1.display_info # Make: Toyota, Model: GR86

car2 = Car.new("Honda", "Accord")
puts Car.total_cars # 2

class Animal
    def speak
      puts "Animal speaks"
    end
  end
  
  class Dog < Animal
    def speak
      puts "Dog barks"
    end
  end

  
animal = Animal.new

animal.speak

class ElectricCar < Car
    attr_accessor :battery_capacity
    
    def initialize(make, model, battery_capacity)
      super(make, model) 
      self.battery_capacity = battery_capacity
    end
    
    def display_info
      super
      puts "Battery Capacity: #{battery_capacity} kWh"
    end
  end

tesla = ElectricCar.new("Tesla", "Model S", 100)

tesla.display_info # Make: Tesla, Model: Model S Battery Capacity: 100 kWh

puts Car.total_cars # 3

