import { User } from '../model/User'
import { requestWebData } from '../web/WebRequest'

const URL_USERS = "https://jsonplaceholder.typicode.com/users"

class UserRepo {
  users?: User[]
  error?: String

  async getUsers() {
    if (this.users) {
      return this.users
    } else {
      return await this.fetchUsers()
    }
  }

  async fetchUsers() {
    let responseJson = await requestWebData(URL_USERS) as string
    let users = JSON.parse(responseJson) as User[]
    // this.users = users
    return users
  }
}

export const userRepo = new UserRepo()