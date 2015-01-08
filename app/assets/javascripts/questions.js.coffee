# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(@).hide();
    $('.edit_question').show()

  $('.add_comment_link').click (e) ->
    comment_link = $(@)
    e.preventDefault()
    comment_link.hide()
    commentable_id = comment_link.data('commentableId')
    commentable =  comment_link.data('commentable')
    selector = $("form#add-comment-#{commentable}-#{commentable_id}")
    $(selector).show()

  $(".new_comment").bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    body = comment.body
    commentable = comment.commentable_type.toLowerCase()
    commentable_id = comment.commentable_id
    $("#comments-#{commentable}-#{commentable_id}").append("<p>#{body}</p>")
    $("#comment_body").val('')
    $(@).hide()
    $('.add_comment_link').show()
