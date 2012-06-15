$ ->
  $("[data-behavior='batch-tools']").removeClass('hidden')     

  $("[data-behavior='batch-add-button']").bl_checkbox_submit({
          checked_label: "Selected",
          unchecked_label: "Select",
          css_class: "batch_toggle"
      })

  $("[data-behavior='batch-edit-activate']").click (e) ->
    e.preventDefault()
    if $(this).attr("data-state") == 'off'
      $(this).attr("data-state", 'on')
      $(this).find('a i').addClass('icon-ok')
      $("[data-behavior='batch-edit']").removeClass('hidden')
      $("[data-behavior='batch-add-button']").removeClass('hidden')
    else
      $(this).attr("data-state", 'off')
      $(this).find('a i').removeClass('icon-ok')
      $("[data-behavior='batch-edit']").addClass('hidden')
      $("[data-behavior='batch-add-button']").addClass('hidden')
    # TODO check-all

