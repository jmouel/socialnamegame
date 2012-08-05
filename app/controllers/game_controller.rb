class GameController < ApplicationController

  # Initialize a new game and start its timer.
  def begin_game
    render json: {}
  end

  # Initialize a new round and start its timer. Return names, photos for the round.
  def begin_round
    people = Person.all
    @needle = people[rand(people.size)]
    all_except_needle = people.collect { |p| p unless p.name == @needle.name }.compact.sort { rand }
    haystack = all_except_needle.sample(4)

    @names = []
    @photos = []

    haystack.each do |h|
      @names.push h.name
      # Find a random picture of the same gender that is not the needle.
      photo_person = all_except_needle.find do |p|
        !@names.include?(p.name) and !@photos.include?(p.photo_url) and p.gender == h.gender
      end
      @photos.push photo_person.photo_url
      # Remove the name corresponding to the photo to make sure we don't end up with > 1 correct pair.
      all_except_needle.delete(photo_person)
    end
  end

  # Evaluate user's answer, update score.
  # Do not allow multiple submissions within a round.
  # Do not allow submissions outside of a game.
  def submit_match

    render json: {}
  end

end
