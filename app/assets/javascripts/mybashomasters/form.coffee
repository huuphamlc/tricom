jQuery ->
  $('.refer-kaisha').click ()->
    $('#kaisha-search-modal').trigger('show', [$('#mybashomaster_会社コード').val()])

  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#mybashomaster_会社コード').val(selected_data[0])
      $('#mybashomaster_会社コード').closest('.form-group').find('span.help-block').remove()
      $('#mybashomaster_会社コード').closest('.form-group').removeClass('has-error')
