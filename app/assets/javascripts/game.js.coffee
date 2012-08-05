jQuery(document).ready ($) ->
  $('.btn[data-action="select-photo"]').click (e) =>
    @selectedPhoto = $(e.target).closest('img').attr('src')
    checkAnswer()

  $('.btn[data-action="select-name"]').click (e) =>
    @selectedName = $(e.target).closest('button').text()
    checkAnswer()

  checkAnswer = =>
    if @selectedPhoto and @selectedName
      $.ajax
        url: 'eval_answer'
        type: 'post'
        headers:
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        data:
          name: @selectedName
          photo: @selectedPhoto
        success: (response) ->
          # TODO: Check success/failure and render some cool feedback.
          if response.correct
            alert('correct!')
          else
            alert('wrong!')

          if response.game_over
            # TODO: Go to leaderboard.
          else
            location.reload()
