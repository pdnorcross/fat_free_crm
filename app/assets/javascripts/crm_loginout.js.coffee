
(($) ->

  window.crm ||= {}

  #----------------------------------------------------------------------------
  crm.toggle_open_id_login = (first_field = "#authentication_openid_identifier") ->
    $("#login").toggle()
    $("#openid").toggle()
    $("#login_link").toggle()
    $("#openid_link").toggle()
    $(first_field).focus()


  #----------------------------------------------------------------------------
  crm.toggle_open_id_signup = ->
    $("#login").toggle()
    $("#openid").toggle()
    $("#login_link").toggle()
    $("#openid_link").toggle()
    $("#user_email").focus()

) jQuery
