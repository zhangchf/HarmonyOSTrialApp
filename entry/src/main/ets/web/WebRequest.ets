import http from '@ohos.net.http';
import { User } from '../model/User';

export async function requestWebData(url: string) {

  let httpRequest = http.createHttp()

  httpRequest.on("headerReceive", (header) => {
    console.info('header: ' + JSON.stringify(header))
  })

  if (Math.random() > 0.5) {
    throw new Error("Something went wrong!")
  }

  try {
    let request = httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET
      }
    )
    let response = await request
    return response.result
  } catch (error) {
    throw error as Error
  }
}