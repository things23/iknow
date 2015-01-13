# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $(document).on('click', '.add_comment_link', ( (e) ->
    e.preventDefault()
    comment_link = $(@)
    commentable_id = comment_link.data('commentableId')
    commentable = comment_link.data('commentable')
    comment_link.hide()
    $("##{commentable}-#{commentable_id}").find("form").remove()
    $("##{commentable}-#{commentable_id}")
    .append("<div id='form_comment_#{commentable}-#{commentable_id}'></div>")
    commentable_div = $("#form_comment_#{commentable}-#{commentable_id}")
    commentable_div.append("<form id='add-comment-#{commentable}-#{commentable_id}'></form")
    new_comment_form = $("form#add-comment-#{commentable}-#{commentable_id}")
    new_comment_form.attr("accept-charset", "UTF-8")
    new_comment_form.attr("action", "/#{commentable}s/#{commentable_id}/comments")
    new_comment_form.attr("class", "new_comment")
    new_comment_form.attr("data-remote", "true")
    new_comment_form.attr("method", "post")
    new_comment_form.append("<div style='display:none'>
                              <input name='utf8' type='hidden' value='✓'>
                            </div>")
    new_comment_form.append("<label for='comment_body'>New Comment</label>")
    new_comment_form.append("<div class='comment-errors'>
                            </div>")
    new_comment_form.append("<textarea id='comment_body' name='comment[body]'></textarea>")
    new_comment_form.append("<input name='commit' type='submit' value='Add'>")
    $(new_comment_form).show()


    $("#add-comment-#{commentable}-#{commentable_id}").bind 'ajax:success', (e, data, status, xhr) ->
      comment = $.parseJSON(xhr.responseText)
      body = comment.body
      $("##{commentable}-#{commentable_id}")
      .find("#comments-#{commentable}-#{commentable_id}").append("<p>#{body}</p>")
    .bind 'ajax:complete', ->
      $("#form_comment_#{commentable}-#{commentable_id}").remove()
      $(@).find('#comment_body').val("")
      $(@).hide()
      $('.add_comment_link').show()
  ))

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(@).hide();
    $('.edit_question').show()

