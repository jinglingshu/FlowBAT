Template.login.rendered = ->
  $signinForm = @$(".signin form")
  $signinForm.validate
    rules:
      email:
        required: true
        email: true
      password:
        required: true
        minlength: 4
    messages: i18n.t("forms.login.messages", {returnObjectTrees: true})
    submitHandler: (form) ->
      email = $(".email", form).val().toLowerCase()
      password = $(".password", form).val()
      Meteor.loginWithPassword email, password, (error) ->
        if error
          $signinForm.validate().showErrors
            password: i18n.t("serverErrors." + error.reason)
        else
          $(document.body).trigger("popup.hide")
          share.loginCallback()

  $signupForm = @$(".signup form")
  $signupForm.validate
    rules:
      email:
        required: true
        email: true
      password:
        required: true
        minlength: 4
      passwordAgain:
        required: true
        equalTo: ".signup .password"
    messages: i18n.t("forms.login.messages", {returnObjectTrees: true})
    submitHandler: (form) ->
      email = $(".email", form).val().toLowerCase()
      password = $(".password", form).val()
      Accounts.createUser { email: email, password: password }, (error) ->
        if (error)
          $signupForm.validate().showErrors
            password: i18n.t("serverErrors." + error.reason)
        else
          $(document.body).trigger("popup.hide")
          share.loginCallback()
  if share.isDebug
    $signupForm.find(".email").val(Random.id() + "@flowbat.com")
    $signupForm.find(".password").val("asdfasdf")
    $signupForm.find(".passwordAgain").val("asdfasdf")

Template.login.events
  "click .sign-in-with-google": grab (event, template) ->
    Meteor.loginWithGoogle({}, share.loginCallback)
  "click .forgot-password": grab (event, template) ->
    UI.insert(UI.renderWithData(Template.alert,
      name: i18n.t("forms.login.passwordForgot.alert.name")
      descriptionTemplateName: "forgotPasswordAlertDescription"
      descriptionTemplateData: {}
      buttonPanelTemplateName: "forgotPasswordAlertButtonsPanel"
      buttonPanelTemplateData: {}
    ), document.body)
