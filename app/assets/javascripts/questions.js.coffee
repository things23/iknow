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
    $("form#add-comment-#{commentable}-#{commentable_id}").show()
    $("form#add-comment-#{commentable}-#{commentable_id}").submit ->
      $(@).hide()
      comment_link.show()