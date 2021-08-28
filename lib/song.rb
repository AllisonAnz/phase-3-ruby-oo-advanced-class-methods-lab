class Song
  attr_accessor :name, :artist_name
  @@all = []

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  # .create returns a new song that was created
  # saves the song to the @@all class variable 
  def self.create 
    song = Song.new
    song.save 
    song 
  end

  # .new_by_name 
  # instantiates a song with a name property 
  def self.new_by_name(song_name)
    song = self.new 
    song.name = song_name 
    song
  end

  # .create_by_name 
  # instantiates and saves a song with a name property 
  # saves the song to the @@all class variable 
  def self.create_by_name(song_name)
    song = self.create 
    song.name = song_name 
    song 
  end

  # .find_by_name 
  # can find a song present in @@all by name 
  # returns 'nil' when a song name is not present in @@all 
  def self.find_by_name(song_name)
    self.all.find { |song| song.name == song_name }
  end 

  # .find_or_create_by_name 
  # invokes .find_by_name and .create_by_name instaed of repeating code 
  # returns the existing Song object (doesn't create a new one) when provided with the title of an exisintg Song 
  def self.find_or_create_by_name(song_name)
    self.find_by_name(song_name) || self.create_by_name(song_name)
  end

  # .alphabetical 
  # returns all the song instances in alphabetical order by song name 
  def self.alphabetical 
    self.all.sort_by { |song| song.name}
  end

  # .new_from_filename 
  # initializes a song and artist_name based on the filename format 
  def self.new_from_filename(filename)
    parts = filename.split(" - ")
    artist_name = parts[0]
    song_name = parts[1].gsub(".mp3", "")

    song = self.new 
    song.name = song_name 
    song.artist_name = artist_name 
    song 
  end 

  # .create_from_file 
  # Initializes and saves a song and artist_name based on the filename format 
  def self.create_from_filename(filename)
    song = self.new_from_filename(filename)
    song.save
    song
  end

  #.destory_all 
  # clears all the song instances from the @@all array 
  def self.destroy_all
    self.all.clear
  end

end
