# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  modal_holder_selector = "#modal-holder"
  $(document).on "click", "[data-behavior='modal']", ->
    location = $(this).attr("href")
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(".modal").modal("show")
    false

  $(document).on "ajax:success", "[data-behavior='modal-form']", (event, data, status, xhr) ->
    url = xhr.getResponseHeader("Location")
    if url
      window.location = url
    else
      $(".modal").modal("hide")
    false
