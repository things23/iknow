# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $(document).on('click', '.delete-answer-link', ( (e) ->
    e.preventDefault()
    $(@).closest(".answer").fadeOut()
  ))

  $("#new_answer").bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append("<div class='answer' id='answer-#{answer.id}'><p>#{answer.body}</p></div>")
    $("#answer-#{answer.id}").append("<cite>#{answer.user.email}</cite>")
    $("#answer-#{answer.id}").append("<a class='delete-answer-link' data-method='delete' data-remote='true' href='/answers/#{answer.id}' rel='nofollow'>Delete</a>")
    $.each answer.attachments, (index, a) ->
      $("#answer-#{answer.id}").append("<a href='#{a.url}'>#{a.filename}</li>")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(".answer-errors").append(value)
  .bind 'ajax:complete', ->
    $("#new_answer").find('#answer_body').val("")
