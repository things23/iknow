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
    template = HandlebarsTemplates['comments/comment']({commentable: commentable, id: commentable_id})
    $("##{commentable}-#{commentable_id}").append(template)
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

