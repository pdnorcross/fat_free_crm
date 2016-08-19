
(($) ->

  $(document).on 'ajax:send', '.pagination, .per_page_options', ->
    $(this).find('a').prop('disabled', true)
    $(this).closest('#paginate').find('.spinner').show()

  $(document).on 'ajax:complete', '.pagination, .per_page_options', ->
    $(this).find('a').prop('disabled', false)
    $(this).closest('#paginate').find('.spinner').hide()

) jQuery
