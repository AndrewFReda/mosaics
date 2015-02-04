$(document).ready(function() {

    for(i=0; i<composition_pictures.length; i++) {
        var id = '#cimage-' + composition_pictures[i].id;

        $(id).on('click', function(click){
            var $$ = $(this)
            // Split id name on '-', and take just final ID from it
            // We know structure will be 'cimage-' followed by the ID of the picture
            // We can now construct the check ID from these pieces
            var id = "#user_composition_picture_ids_" + click.currentTarget.id.split("-")[1]

            if(!$$.is('.checked')){
                $$.addClass('checked');
                $(id).prop('checked', true);
            } else {
                $$.removeClass('checked');
                $(id).prop('checked', false);
            }
        })
    };

    for(i=0; i<base_pictures.length; i++) {

        var id = '#bimage-' + base_pictures[i].id;
        $(id).on('click', function(click){

            if(!$(this).is('.checked')){
                // Split id name on '-', and take just final ID from it
                // We know structure will be 'bimage-' followed by the ID of the picture
                // We can now construct the check ID from these pieces
                var id = "#user_base_picture_ids_" + click.currentTarget.id.split("-")[1]
                $(id).prop('checked', true).change();
            }
        })
    };

    $('input:radio[name="user[base_picture_ids]"]').on('change', function(change) {
        // Split the id name on '_', and take just the final piece from it.
        // We know structure will be 'user_base_picture_ids_' followed by the ID 
        // of the picture, so the final is [4]
        var radio_btns = $('input:radio[name="user[base_picture_ids]"]');
        var active_btn  = change.currentTarget.id;
        for(i=0; i<radio_btns.length; i++) {
            var cur_btn = radio_btns[i].id;
            var cur_img = '#bimage-' + cur_btn.split("_")[4];
            if(cur_btn == active_btn){
                $(cur_img).addClass('checked');
            } else {
                $(cur_img).removeClass('checked');
            }
        }
    })
});