import http from '@ohos.net.http';

export function requestWebData(url: string, callback: (data) => void, errorCallback: (string) => void) {

  let httpRequest = http.createHttp()

  httpRequest.on("headerReceive", (header) => {
    console.info('header: ' + JSON.stringify(header))
  })

  let promise = httpRequest.request(
    url,
    {
      method: http.RequestMethod.GET
    }
  )

  if (Math.random() > 0.1) {
    errorCallback("Something went wrong!")
    return
  }

  promise.then((data) => {
    console.info('Result: ' + JSON.stringify(data))
    if (data.responseCode === http.ResponseCode.OK) {
      callback(data.result)
    }
  }).catch((error) => {
    console.error('error: ' + JSON.stringify(error))
    errorCallback(JSON.stringify(error))
  })
}