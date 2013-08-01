class Movie < ActiveRecord::Base
   def self.a_ratings
	['G', 'PG', 'PG-13', 'R']
   end
end
