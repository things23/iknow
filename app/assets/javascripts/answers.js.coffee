# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $(document).on('click', '.edit-answer-link', ( (e) ->
    e.preventDefault()
    edit_link = $(@)
    answer_id = edit_link.data('answerId')
    answer = edit_link.closest(".answer").find(".body_answ").text()
    edit_link.hide()
    template = HandlebarsTemplates['answers/edit_answer']({id: answer_id, body: answer})
    $("#answer-#{answer_id}").append(template)
    console.log(template)
    $("#edit-answer-#{answer_id}").bind "ajax:success", (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      $("#answer-#{answer_id}").find('.body_answ').text(answer.body)
      $("#answer-#{answer_id}").find('cite').text(answer.user.email)
    .bind 'ajax:complete', ->
      $("form#edit-answer-#{answer_id}").remove()
      edit_link.show()
  ))

  $("#new_answer").bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    template = HandlebarsTemplates['answers/answer'](answer)
    $('.answers').append(template)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(".answer-errors").append(value)
  .bind 'ajax:complete', ->
    $("form#new_answer").find('#answer_body').val("")



