class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list == nil or ratings_list.size == 0
      Movie.all
    else
      Movie.where(:rating => ratings_list)
    end
  end
  
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  
  def self.get_order(movies, orderBy)
    if orderBy != nil
      movies.order(orderBy)
    else
      movies
    end
  end
end
