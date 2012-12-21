$ ->
  $("[data-behavior='batch-tools']").removeClass('hidden')

  window.batch_edits_options = {}  if typeof window.batch_edits_options is "undefined"
  default_options =
          checked_label: "Selected",
          unchecked_label: "Select",
          css_class: "batch_toggle"

  options = $.extend({}, default_options, window.batch_edits_options)
      
  $("[data-behavior='batch-add-form']").bl_checkbox_submit(options)

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
    })
    # TODO check-all

  # ajax manager to queue ajax calls so all adds or removes are done in sequence
  queue = ->
    requests = []
    addReq: (opt) ->
      requests.push opt
  
    removeReq: (opt) ->
      requests.splice $.inArray(opt, requests), 1  if $.inArray(opt, requests) > -1
  
    run: ->
      self = this
      orgSuc = undefined
      if requests.length
        oriSuc = requests[0].complete
        requests[0].complete = ->
          oriSuc()  if typeof oriSuc is "function"
          requests.shift()
          self.run.apply self, []
  
        $.ajax requests[0]
      else
        self.tid = setTimeout(->
          self.run.apply self, []
        , 1000)
  
    stop: ->
      requests = []
      clearTimeout @tid
  
  ajaxManager = (queue())
  
  ajaxManager.run()

  #override the default blacklight checkbox behavior to queue ajax calls
  $("input[type='checkbox'].batch_toggle").click ->
    checked = not this["checked"]
    checkbox = $(this)
    form = $(checkbox.closest('form')[0])
    label = $('label[for="'+$(this).attr('id')+'"]')
    label.text(options.progress_label).attr "disabled", "disabled"
    checkbox.attr "disabled", "disabled"
    ajaxManager.addReq
      queue: "add_doc"
      url: form.attr("action")
      dataType: "json"
      type: form.attr("method").toUpperCase()
      data: form.serialize()
      error: ->
        alert "Error  Too Many results Selected"
        update_state_for checked, checkbox, label, form
        label.removeAttr "disabled"
        checkbox.removeAttr "disabled"
  
      success: (data, status, xhr) ->
        unless xhr.status is 0
          checked = not checked
          update_state_for checked, checkbox, label, form
          label.removeAttr "disabled"
          checkbox.removeAttr "disabled"
        else
          alert "Error Too Many results Selected"
          update_state_for checked, checkbox, label, form
          label.removeAttr "disabled"
          checkbox.removeAttr "disabled"
  
    false
  
  # complete the override by overriding update_state_for  
  update_state_for = (state, checkbox, label, form) ->
    checkbox.attr "checked", state
    label.toggleClass "checked", state
    if state
      form.find("input[name=_method]").val "delete"
      label.text options.progress_label
    else
      form.find("input[name=_method]").val "put"
      label.text options.progress_label
