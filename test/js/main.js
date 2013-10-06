$(function () {
    $('[name=submit]').click(function () {
        $.post('http://localhost:9900/lead', {email: $('[name=email]').val()}).success(function() {
            $('#controls').html('Thanks')
        })
    })
});
