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

// KaTex Rendering 함수
function renderKaTex(target) {
  renderMathInElement(target, {
    delimiters: [
      { left: "$$", right: "$$", display: true },
      { left: "$", right: "$", display: false },
    ],
    trust: true,
    trust: (context) =>
      ["\\htmlId", "\\href", "\\includegraphics"].includes(context.command),
    macros: {
      "\\eqref": "\\href{###1}{(\\text{#1})}",
      "\\ref": "\\href{###1}{\\text{#1}}",
      "\\label": "\\htmlId{#1}{}",
      "\\for": "\\text{ for }",
      "\\and": "\\text{ and }",
      "\\or": "\\text{ or }",
      "\\st": "\\text{ s.t. }",
      "\\by": "\\text{ by }",
      "\\on": "\\text{ on }",
      "\\if": "\\text{ if }",
      "\\with": "\\text{ with }",
      "\\sgn": "\\operatorname{sgn}",
      "\\sign": "\\operatorname{sign}",
      "\\sinc": "\\operatorname{sinc}",
      "\\diag": "\\operatorname{diag}",
      "\\diam": "\\operatorname{diam}",
      "\\trace": "\\operatorname{Tr}",
      "\\Re": "\\operatorname{Re}",
      "\\Im": "\\operatorname{Im}",
      "\\Poi": "\\operatorname{Poi}",
      "\\span": "\\operatorname{span}",
      "\\supp": "\\operatorname{supp}",
      "\\rank": "\\operatorname{rank}",
      "\\nullity": "\\operatorname{nullity}",
      "\\Ric": "\\operatorname{Ric}",
      "\\rcurs":
        "\\includegraphics[height=0.4em, width=0.45em, alt=KA logo]{https://upload.wikimedia.org/wikipedia/commons/a/a9/Script-r.png}",
    },
    throwOnError: false,
  });
}
