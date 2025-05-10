// Fetch method post
function postFetch(url = "", data = {}) {
  return fetch(url, {
    method: "post",
    cache: "no-cache",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
    },
    body: getFormData(data),
  });
}

// Object to FormData
function getFormData(data) {
  let formData = "";
  for (let key in data) {
    formData += key + "=" + data[key] + "&";
  }
  return formData.slice(0, -1);
}

function isMobile() {
  const user = navigator.userAgent;
  let is_mobile = false;
  if (user.indexOf("iPhone") > -1 || user.indexOf("Android") > -1) {
    is_mobile = true;
  }
  return is_mobile;
}
