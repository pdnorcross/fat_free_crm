
(($) ->

  $(document).on 'click focus', 'input.date', ->
    $(this).datepicker({
      showOn: 'focus',
      changeMonth: true,
      dateFormat: 'yy-mm-dd'})

  $(document).on 'click focus', 'input.datetime', ->
    $(this).datetimepicker({
      showOn: 'focus',
      changeMonth: true,
      dateFormat: 'yy-mm-dd'})

) jQuery
