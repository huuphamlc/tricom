jQuery ->
  oTable = $('.kikantable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "aoColumnDefs": [ 
      # { "bSortable": false, "aTargets": [ 2,3 ]},
      # {
      #   "targets": [2,3],
      #   "width": '5%'
      # }
    ],
    "oSearch": {"sSearch": queryParameters().search},

    "buttons": [{
                "extend":    'copyHtml5',
                "text":      '<i class="fa fa-files-o"></i>',
                "titleAttr": 'Copy'
            },
            {
                "extend":    'excelHtml5',
                "text":      '<i class="fa fa-file-excel-o"></i>',
                "titleAttr": 'Excel'
            },
            {
                "extend":    'csvHtml5',
                "text":      '<i class="fa fa-file-text-o"></i>',
                "titleAttr": 'CSV'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kikan").attr("disabled", true);
                  $("#destroy_kikan").attr("disabled", true);
                else
                  $("#destroy_kikan").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_kikan").attr("disabled", false);
                  else
                    $("#edit_kikan").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kikan").attr("disabled", true);
                  $("#destroy_kikan").attr("disabled", true);
                else
                  $("#destroy_kikan").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_kikan").attr("disabled", false);
                  else
                    $("#edit_kikan").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })  
  $("#edit_kikan").attr("disabled", true);
  $("#destroy_kikan").attr("disabled", true); 


  $(document).bind('ajaxError', 'form#new_kikanmst', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  
  $('.kikantable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_kikan").attr("disabled", true);
        # $("#destroy_kikan").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')       
        #$("#edit_kikan").attr("disabled", true);
        # $("#edit_kikan").attr("disabled", false);
        # $("#destroy_kikan").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_kikan").attr("disabled", true);
      $("#destroy_kikan").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_kikan").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_kikan").attr("disabled", false);
      else
        $("#edit_kikan").attr("disabled", true);

  )

  $('#destroy_kikan').click () ->
    kikans = oTable.rows('tr.selected').data()
    kikanIds = new Array();
    if kikans.length == 0
      swal($('#message_confirm_select').text())
    else

      swal({
        title: $('#message_confirm_delete').text(),
        text: "",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "OK",
        cancelButtonText: "キャンセル",
        closeOnConfirm: false,
        closeOnCancel: false
      }).then(() ->
        len = kikans.length
        for i in [0...len]
          kikanIds[i] = kikans[i][0]

        $.ajax({
          url: '/kikanmsts/ajax',
          data:{
            focus_field: 'kikan_削除する',
            kikans: kikanIds
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              oTable.rows('tr.selected').remove().draw()
            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("kikan_削除する keydown Unsuccessful")

        })
        $("#edit_kikan").attr("disabled", true);
        $("#destroy_kikan").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_kikan").attr("disabled", true);
            $("#destroy_kikan").attr("disabled", true);
          else
            $("#destroy_kikan").attr("disabled", false);
            if selects.length == 1
              $("#edit_kikan").attr("disabled", false);
            else
              $("#edit_kikan").attr("disabled", true);
      );
  $('#new_kikan').click ()->
    $('#kikan-new-modal').modal('show')
    #$('#jpt_holiday_mst_id').val('');
    $('#kikanmst_機関コード').val('')
    $('#kikanmst_機関名').val('')
    $('#kikanmst_備考').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
  $('#edit_kikan').click () ->      
    kikan = oTable.row('tr.selected').data()
    $('.form-group.has-error').each () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    if (kikan == undefined)
      swal("行を選択してください。")
    else
      $('#kikan-edit-modal').modal('show')
      $('#kikanmst_機関コード').val(kikan[0])
      $('#kikanmst_機関名').val(kikan[1])
      $('#kikanmst_備考').val(kikan[2])    