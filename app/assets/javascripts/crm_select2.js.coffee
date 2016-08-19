
(($) ->

  window.crm ||= {}

  crm.make_select2 = ->
    $(".select2").not(".select2-container, .select2-offscreen").each ->
    #$(".select2").each ->
      $(this).select2 'width':'resolve'

    $(".select2_tag").not(".select2-container, .select2-offscreen").each ->
    #$(".select2_tag").each ->
      $(this).select2
        'width':'resolve'
        tags: $(this).data("tags")
        placeholder: $(this).data("placeholder")
        multiple: $(this).data("multiple")

  $(document).ready ->
    crm.make_select2()

  $(document).ajaxComplete ->
    crm.make_select2()

) jQuery
