# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $(document).on('click', '.edit-answer-link', ( (e) ->
    e.preventDefault()
    edit_link = $(@)
    answer_id = edit_link.data('answerId')
    answer = edit_link.closest(".answer").find("p").text()

    #$("form#edit-answer-#{answer_id}").show()
    $("#answer-#{answer_id}").append("<form id='edit-answer-#{answer_id}'></form")
    edit_answer_form = $("form#edit-answer-#{answer_id}")
    edit_answer_form.attr("accept-charset", "UTF-8")
    edit_answer_form.attr("action", "/answers/#{answer_id}")
    edit_answer_form.attr("class", "edit_answer")
    edit_answer_form.attr("data-remote", "true")
    edit_answer_form.attr("data-type", "json")
    edit_answer_form.attr("method", "post")
    edit_answer_form.attr("style", "display: block;")
    edit_answer_form.append("<div style='display:none'>
                              <input name='utf8' type='hidden' value='✓'>
                              <input name='_method' type='hidden' value='patch'>
                            </div>")
    edit_answer_form.append("<label for='answer_body'>Answer</label>")
    edit_answer_form.append("<textarea id='answer_body' name='answer[body]'>#{answer}</textarea>")
    edit_answer_form.append("<input class='btn btn-primary' name='commit' type='submit' value='Save'>")
    #<form accept-charset="UTF-8" action="/answers/298" class="edit_answer" data-remote="true" data-type="json" id="edit-answer-298" method="post" style="display: block;">
     # <div style="display:none">
        #<input name="utf8" type="hidden" value="✓">
        #<input name="_method" type="hidden" value="patch">
      #</div>
      #<label for="answer_body">Answer</label>
      #<textarea id="answer_body" name="answer[body]"> ccc c </textarea>
      #<input class="btn btn-primary" name="commit" type="submit" value="Save">
    #</form>
    #delete_edit_nav = edit_link.closest('.delete-edit-nav')
    edit_link.hide()
    $("#edit-answer-#{answer_id}").bind "ajax:success", (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      $("#answer-#{answer_id}").find('p').text(answer.body)
      $("#answer-#{answer_id}").find('cite').text(answer.user.email)
    .bind 'ajax:complete', ->
      edit_answer_form.remove()
      edit_link.show()
  ))

  $(document).on('click', '.delete-answer-link', ( (e) ->
    e.preventDefault()
    $(@).closest(".answer").fadeOut()
  ))

  $("#new_answer").bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append("<div class='answer' id='answer-#{answer.id}'><p>#{answer.body}</p></div>")
    #new_answer_div = $("#answer-#{answer.id}")
    $("#answer-#{answer.id}").append("<cite>#{answer.user.email}</cite>")
    $("#answer-#{answer.id}").append("<ul class='pull-right delete-edit-nav'></ul>")
    $("#answer-#{answer.id}").find(".delete-edit-nav").append("<li><a class='edit-answer-link' data-answer-id='#{answer.id}' href=''>Edit</a></li>")
    $("#answer-#{answer.id}").find(".delete-edit-nav").append("<li><a class='delete-answer-link' data-method='delete' data-remote='true' href='/answers/#{answer.id}' rel='nofollow'>Delete</a></li>")
    #$("#answer-#{answer.id}").append("<form id='edit-answer-#{answer.id}'></form")
    #$("form#edit-answer-#{answer.id}").attr("accept-charset", "UTF-8")
    #$("form#edit-answer-#{answer.id}").attr("action", "/answers/#{answer.id}")
    #$("form#edit-answer-#{answer.id}").attr("class", "edit_answer")
    #$("form#edit-answer-#{answer.id}").attr("data-remote", "true")
    #$("form#edit-answer-#{answer.id}").attr("data-type", "json")
    #$("form#edit-answer-#{answer.id}").attr("method", "post")
    #$("form#edit-answer-#{answer.id}").attr("style", "display: block;")
    #$("form#edit-answer-#{answer.id}").append("<label for='answer_body'>Answer</label>")
    #<form accept-charset="UTF-8" action="/answers/298" class="edit_answer" data-remote="true" data-type="json" id="edit-answer-298" method="post" style="display: block;">
     # <div style="display:none">
      #<input name="utf8" type="hidden" value="✓">
      #<input name="_method" type="hidden" value="patch">
      #</div>
      #<label for="answer_body">Answer</label>
      #<textarea id="answer_body" name="answer[body]"> ccc c </textarea>
      #<input class="btn btn-primary" name="commit" type="submit" value="Save">
    #</form>
    $.each answer.attachments, (index, a) ->
      $("#answer-#{answer.id}").append("<ul class='attachments'></ul>")
      $("#answer-#{answer.id}").find('.attachments').append("<li><a href='#{a.url}'>#{a.filename}</a></li>")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(".answer-errors").append(value)
  .bind 'ajax:complete', ->
    $("#new_answer").find('#answer_body').val("")
