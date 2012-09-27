$ ->
  $("[data-behavior='batch-tools']").removeClass('hidden')     

  $("[data-behavior='batch-add-form']").bl_checkbox_submit({
          checked_label: "Selected",
          unchecked_label: "Select",
          css_class: "batch_toggle"
      })

  setState = (obj) ->
    activate = ->
      obj.find('a i').addClass('icon-ok')
      $("[data-behavior='batch-edit']").removeClass('hidden')
      $("[data-behavior='batch-add-button']").removeClass('hidden')
      $("[data-behavior='batch-select-all']").removeClass('hidden')

    deactivate = ->
      obj.find('a i').removeClass('icon-ok')
      $("[data-behavior='batch-edit']").addClass('hidden')
      $("[data-behavior='batch-add-button']").addClass('hidden')
      $("[data-behavior='batch-select-all']").addClass('hidden')

    if obj.attr("data-state") == 'off'
      deactivate(obj)
    else
      activate(obj)

  toggleState = (obj) ->
    if obj.attr('data-state') == 'off'
      obj.attr("data-state", 'on')
    else
      obj.attr("data-state", 'off')
    setState(obj)

  #set initial state
  setState($("[data-behavior='batch-edit-activate']"))

  $("[data-behavior='batch-edit-activate']").click (e) ->
    e.preventDefault()
    toggleState($(this))
    $.ajax({
      type: 'POST',
      url: '/batch_edits/state',
      data: {_method:'PUT', state: $(this).attr('data-state')},
    });
    # TODO check-all

