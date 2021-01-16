function getFormatDate(date) {
    let year = date.getFullYear();
    let month = (1 + date.getMonth());
    month = month >= 10 ? month : '0' + month;
    let day = date.getDate();
    day = day >= 10 ? day : '0' + day;
    return year + '-' + month + '-' + day;
}

$(document).ready(function () {
    let today = getFormatDate(new Date());
    let last_visit;
    last_visit = sessionStorage.getItem("last_visit");

    if (today != last_visit) {
        sessionStorage.setItem("last_visit", today);
        $.ajax({
            type: "POST",
            url: "http://threedo29.cafe24.com/ajax/ajax.visit_count.php",
            data: {
                today: today
            },
            dataType: "json",
            success: function (data) {
                let msg = data['msg'];
                if (!msg) {
                    console.log("disables the session.");
                }
            },
            error: function (xhr, status, error) {
                console.log(error);
            }
        });
    }
    else {
    }
});