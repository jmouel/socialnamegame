class GameController < ApplicationController

  # Initialize a new game.
  def begin_game
    session[:score] = 0
    session[:roundsRemaining] = 10
    session[:streak] = 0
    redirect_to '/game/begin_round'
  end

  def end_game
    Score.create(user_id: current_user.id,
                 value: session[:score],
                 created_at: Time.now())
  end

  # Initialize a new round and start its timer. Return names, photos for the round.
  def begin_round
    if session[:roundsRemaining] == 0
      redirect_to '/game/end_game'
      return
    end

    people = Person.where(user_id: current_user.id)
    needle = people[rand(people.size)]
    all_except_needle = people.collect { |p| p unless p.id == needle.id }.compact.shuffle
    haystack = all_except_needle.sample(4)

    @names = {}
    @names[needle.id] = needle.name
    @photos = [ needle.photo_url ]

    haystack.each do |h|
      @names[h.id] = h.name
      photo_person = all_except_needle.find do |p|
        !@names.include?(p.name) and !@photos.include?(p.photo_url)
      end
      @photos.push photo_person.photo_url
      # Remove the name corresponding to the photo to make sure we don't end up with > 1 correct pair.
      all_except_needle.delete(photo_person)
    end

    # Save the answer in the session because we need to send it back to the client if their response is wrong.
    session[:answer_id] = needle.id
    session[:answer_photo] = needle.photo_url

    @names.sort_by { rand } #shuffle!
    @photos.shuffle!
  end

  # Evaluate user's answer, update score.
  def eval_answer
    id = params[:id]
    photo = params[:photo]

    p = Person.find(id)
    correct = p.photo_url == photo

    response = { correct: correct }
    if not correct
      response[:answer] = {
              id: session[:answer_id],
              photo_url: session[:answer_photo]
      }
      session[:streak] = 0
    else
      increase_score
    end
    decrease_rounds_remaining
    render json: response
  end

  # High scores
  def scores
    @scores = Score.order('value desc').first(5)
  end

  helper_method :score, :roundsRemaining

  private
  def increase_score
    session[:score] += 10
    session[:streak] += 1
    # Get 3 correct in a row for a bonus 5 rounds
    if session[:streak] > 2
      session[:roundsRemaining] += 5
    end
  end

  def decrease_rounds_remaining
    session[:roundsRemaining] -= 1
  end

  def score
    session[:score]
  end

  def roundsRemaining
    session[:roundsRemaining]
  end
end
