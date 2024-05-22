function request(method, path, body = null, headers = null) {
  return fetch(`https://pezeshkan-sharif.liara.run${path}`, {
    "body": JSON.stringify(body),
    "cache": "default",
    "credentials": "omit",
    "headers": {
      "Accept": "*/*",
      "Content-Type": "application/json",
      ...headers
    },
    "method": method,
    "mode": "cors",
    "redirect": "follow",
    "referrer": "http://localhost/",
    "referrerPolicy": "strict-origin-when-cross-origin"
  })
}

export function get_request(path, headers = {}) {
  return request('GET', path, headers)
}

export function post_request(path, body = {}, headers = {}) {
  return request('POST', path, body, headers)
}
