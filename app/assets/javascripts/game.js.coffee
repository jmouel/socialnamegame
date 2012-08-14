jQuery(document).ready ($) ->
  $('.btn[data-action="select-photo"]').click (e) =>
    target = $(e.target).attr('src')
    if not target?
      target = $(e.target).find('img').attr('src')

    @selectedPhoto = target
    $(e.target).closest('.photos').addClass('selected')
    checkAnswer()

  $('.btn[data-action="select-name"]').click (e) =>
    @selectedName = $(e.target).closest('button').text()
    $(e.target).closest('.names').addClass('selected')
    checkAnswer()

  checkAnswer = =>
    if @selectedPhoto and @selectedName
      $('.photos').hide()
      $('.names').hide()
      $('.result').append("<img src='#{@selectedPhoto}' /><span class='name'>#{@selectedName}</span>")

      $.ajax
        url: 'eval_answer'
        type: 'post'
        headers:
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        data:
          name: @selectedName
          photo: @selectedPhoto

        success: (response) =>
          # TODO: Check success/failure and render some cool feedback.
          if response.correct
            $('.correct').removeClass('hidden')
          else
            $('.incorrect').removeClass('hidden')

          if response.game_over
            # TODO: Go to leaderboard.
          else
#            location.reload()
