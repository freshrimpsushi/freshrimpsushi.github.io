const LATELY_VIEW_POST_EXPIRATION_DATE = 1;
const LATELY_VIEW_POST_MAX_SAVE_COUNT = 10;
const LATELY_VIEW_POST_PAGEING_SIZE = 1;

function isNull(obj) {
    if (obj == '' || obj == null || obj == undefined || obj == NaN) {
        return true;
    } else {
        return false;
    }
}

function setLocalStorage(name, obj) {
    localStorage.setItem(name, obj);
}

function removeLocalStorage(name) {
    localStorage.removeItem(name);
}

function getLocalStorage(name) {
    return localStorage.getItem(name);
}

$(document).ready(function() {
    if (isNull(getLocalStorage('latelyViewPostList'))) {

        //없을경우 공간 생성
        setLocalStorage('latelyViewPostList', null);
    }
});