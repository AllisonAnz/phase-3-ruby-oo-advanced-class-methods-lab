# Advance Class Methods 
# Build advanced class methods to work with the @@all class variable 

# Intro 
# Consider the method .all on the Song class 
# This method acts as a reader for the @@all class variable 
# This method exposes this piece of data to the rest of out application 
# Class methods provide an interface for the data held within a class 
# This data, stored in a class variable, would otherwise be inaccessible outside of the class 

class Song
  attr_accessor :name
  @@all = []

  def initialize(name)
    @name = name
  end

  def self.all
    @@all
  end

end 

# self.all is a class method for reading the data stored in the class variable @@all 
# This is a class reader, similar to an instance reader method that reads an instance property 
# tim = Person.new("Tim")
# tim.name #=> "Tim" 

#---------------------------------------------------------------------------------------
# Class Finders 
# How would you find a specific person by name given this Person Model 
class Person
  attr_accessor :name
  @@all = []

  def initialize(name)
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end

end

Person.new("Grace Hopper")
Person.new("Sandi Metz")

sandi_metz = Person.all.find { |person| person.name == "Sandi Metz" }
sandi_metz #=> #<Person @name="Sandi Metz">

grace_hopper = Person.all.find { |person| person.name == "Grace Hopper" }
grace_hopper #=> #<Person @name="Grace Hopper">

avi_flombaum = Person.all.find { |person| person.name == "Avi Flombaum" }
avi_flombaum #=> nil 

#------------------------------------------------------------------------------------
# There is a better way 
# Instead of writing #find every time we want to search for an object 
# We can encapsulate this logic into a class method 
# Person.find_by_name 

# We teach our Person class to serach by defining a class method 
class Person
  attr_accessor :name
  @@all = []

  def initialize(name)
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find_by_name(name)
    @@all.find { |person| person.name == name}
  end
end

Person.new("Grace Hopper")
Person.new("Sandi Metz")

sandi_metz = Person.find_by_name("Sandi Metz")
sandi_metz #=> #<Person @name="Sandi Metz">

grace_hopper = Person.find_by_name("Grace Hopper")
grace_hopper #=> #<Person @name="Grace Hopper">

avi_flombaum = Person.find_by_name("Avi Flombaum")
avi_flombaum #=> nil 

#------------------------------------------------------------------------------------------------------
# Slight Digression On Abstraction 
# We can improve the code above slightly 
# Code that relies on abstraction is more maintainable and extendable over time 

# What we could abstract away 
# Our current implementation of Person.find_by_name reads the instance data for the class directly 
# out of the class variable @@all 

# The code would break if we renamed the @@all variable 
# Variable names are very low level abstraction 
# Methods that read out of a variable provide an abstaraction for the literal variable name 

# Using a reader method is almost always better and more reliable than using the variable 

# We already have a method to read @@people, Person.all 
# So why not use that method in Person.find_by_name?

class Person
  attr_accessor :name
  @@people = []

  def initialize(name)
    @name = name
    # self in the initialize method is our new instance
    # self.class is Person
    # self.class.all == Person.all
    self.class.all << self
  end

  def self.all
    @@people
  end

  def self.find_by_name(name)
    self.all.find { |person| person.name == name }
  end
end 

#What's happening Above:
# Recall that #initialize is an instance method, so self will refer to an instance, not the entire class 
# In order to accesss Person.all we need to go from the instance, self, to its class by using self.class 
# So using self.class.all << self is the same as using @@people << self 
# But we have abstracted away the use of the variable 
# if the @@people variable changes names, we only have to update it in one place the Person.all reader



# In additon to improving the maintainable of our code class 
# class methods also provide a more readable API for the rest of our application 

# Person.all.find { |p| p.name == "Ada Lovelace" }
# literal implementation, no abstraction or encapsulation
# our program would be littered with this

# Person.find_by_name("Ada Lovelace")
# abstract implementation with logic entirely encapsulated. 
#----------------------------------------------------------------------------------------------------------

# Custom Class Constructors 
# A team provided us with a list of people in comma-separated values (CSV)

# Elon Musk, 45, Tesla/SpaceX
# Mark Zuckerberg, 32, Facebook
# Martha Stewart, 74, MSL 

# They tell us they will often need to upload CSVs of people data 
# Create a person instance from the CSV 
class Person 
    attr_accessor :name, :age, :company 

    def initialize(name, age, company)
        @name = name
        @age = age
        @company = company
        end
    end

csv_data = "Elon Musk, 45, Tesla
Mark Zuckerberg, 32, Facebook
Martha Stewart, 74, MSL"

rows = csv_data.split("\n")
people = rows.map do |row|
    data = row.split(", ")
    name = data[0]
    age = data[1]
    company = data[2]
    Person.new(name, age, company)
end
p people
#=> [#<Person:0x00007fffcfc6eb08 @name="Elon Musk", @age="45", @company="Tesla">, 
    #<Person:0x00007fffcfc6e928 @name="Mark Zuckerberg", @age="32", @company="Facebook">, 
    #<Person:0x00007fffcfc6e7c0 @name="Martha Stewart", @age="74", @company="MSL">]

# Above is pretty Complex 
# We don't want to do that throughout our application 
puts "" 


# Instead we could build something like Person.new_from_csv 

class Person
  attr_accessor :name, :age, :company

  def initialize(name, age, company)
    @name = name
    @age = age
    @company = company
  end

  def self.new_from_csv(csv_data)
    rows = csv_data.split("\n")
    people = rows.map do |row|
        data = row.split(", ")
        name = data[0]
        age = data[1]
        company = data[2]

        self.new(name, age, company)  # This is an important line.
    end
    people 
  end
end

csv_data = "Elon Musk, 45, Tesla
Mark Zuckerberg, 32, Facebook
Martha Stewart, 74, MSL"

people = Person.new_from_csv(csv_data)
p people
#=> [#<Person:0x00007ffff1ca4d58 @name="Elon Musk", @age="45", @company="Tesla">, 
    #<Person:0x00007ffff1ca4c68 @name="Mark Zuckerberg", @age="32", @company="Facebook">, 
    #<Person:0x00007ffff1ca4b50 @name="Martha Stewart", @age="74", @company="MSL">]

new_csv_data = "Avi Flombaum, 31, Flatiron School
Payal Kadakia, 30, ClassPass"

people << Person.new_from_csv(new_csv_data)
people.flatten
people #=> [
#<Person @name="Elon Musk"...>,
#<Person @name="Mark Zuckerberg"...>
#<Person @name="Martha Stewart"...>,
#<Person @name="Avi Flombaum"...>,
#<Person @name="Payal Kadakia"...>
# ] 

# A closer look at the code above
class Person
  attr_accessor :name, :age, :company

  def self.new_from_csv(csv_data)
    # Split the CSV data into an array of individual rows.
    rows = csv_data.split("\n")
    # For each row, let's map a Person instance based on the data
    people = rows.map do |row|
      # Split the row into 3 parts, name, age, company, at the ", "
      data = row.split(", ")
      name = data[0]
      age = data[1]
      company = data[2]

      # Make a new instance
      # self refers to the Person class. This is Person.new(name, age, company)
      # return the new person to .map
      self.new(name, age, company)
    end
    # Return the array of newly created people.
    people
  end
end 

# Like any class method, self refers to the class itself so we can call self.new to piggyback, wrap, 
# or extend functionality of Person.new 
# When we call Person.new_from_csv, The Person class itself is receiving the method call 

# We parse the raw data, create an instance and assign the data to the corresponding instance properties

#---------------------------------------------------------------------------------------------------
# A simplier custom constructor that wraps .new 

# When building objects that can be saved into a class variable @@all 
# we might now always want to save the newly instantiated instance 
class Person
  @@all = []

  def initialize
    @@all << self
  end
end 

# With the above code, no patter what, person instances will always be saved 
# We could instead implement a simple .create class method to provide the functionality 
# of instantiated and create the instance leave .new to function as normal 
class Person
  @@all = []

  def self.create
    @@all << self.new
  end
end 

#----------------------------------------------------------------------------------------------------------
# Class Operators 
# Beyond finders and custom constructors that return existing instance or create new instances, class methods 
# can also manupulate class-level data 

# A basic case would be printing out all the people in our application 
class Person
  attr_accessor :name
  @@all = []
  def self.all
    @@all
  end

  def self.create(name)
    person = self.new
    person.name = name
    @@all << person
  end
end

Person.create("Ada Lovelace")
Person.create("Grace Hopper")

# Printing each person
Person.all.each do |person|
  puts "#{person.name}"
end 

# Even this logic is worth encapsulating within a class method 
# .print_all 

class Person 
    attr_accessor :name 
    @@all = []

    def self.all 
        @@all 
    end 

    def self.create(name)
        person = self.new 
        person.name = name 
        @@all << person 
    end

    def self.print_all 
        self.all.each { |person| puts person.name }
    end
end

Person.create("Ada Lovelace")
Person.create("Grace Hopper")

p Person.print_all
    #<Person:0x00007fffc124adb0 @name="Ada Lovelace">, 
    #<Person:0x00007fffc124ac48 @name="Grace Hopper">]

#-------
# Additonaly, class methods might provide a global operation on data 
# Imagine that one of the CSVs we were provided with has perople's names in lower case letters 
# We want proper capitalization 
# We could build a method Person.normalize_names 

class Person
  attr_accessor :name
  @@all = []
  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @@all << self
  end

  def self.normalize_names 
    self.all.each.do |person| 
    person.name = person.name.split(" ").map { |w| w.capitalize}.join(" ")
    end
  end
end

# Given how complex normalzing a person's name is 
# We should actually encapulate that into the Person instance 

class Person
  attr_accessor :name
  @@all = []
  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @@all << self
  end

  def normalize_name
    self.name.split(" ").map { |w| w.capitalize }.join(" ")
  end

  def self.normalize_names
    self.all.each do |person|
      person.name = person.normalize_name
    end
  end
end 

#-----------------------------------------------------------------------------------------
# A final example of this type of global data manupulation might be deleting all the people 
# building a Person.destroy_all class method that will clear out the @@all array 

class Person
  attr_accessor :name
  @@all = []
  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @@all << self
  end

  def self.destroy_all
    self.all.clear
  end
end 