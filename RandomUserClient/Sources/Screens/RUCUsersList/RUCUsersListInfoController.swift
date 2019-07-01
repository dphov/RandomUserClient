//
//  RUCUsersListInfoController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import Foundation

protocol RUCUsersListInfoController {
  func fetchUsersData(forPage page: Int, completion: @escaping (RandomUsersDataRoot?) -> Void)
  var lastPage: Int { get }
  var firstPage: Int { get }
  var fetchingMore: Bool { get set }
}

class RUCUsersListInfoControllerImpl: RUCUsersListInfoController {
  init() {}
  var lastPage: Int = 10000
  var firstPage: Int = 1
  var fetchingMore: Bool = false
  func fetchUsersData(forPage page: Int, completion: @escaping (RandomUsersDataRoot?) -> Void) {
    guard let baseURL = URL(string: "https://randomuser.me/api") else {return}
    let query: [String: String] = [
      "seed": "qwerty",
      "results": "10",
      "page": String(page)
    ]
    guard let url = baseURL.withQueries(query) else {return}
    let task = URLSession.shared.dataTask(with: url) { (data, response, _) in
      let jsonDecoder = JSONDecoder()
      guard let data = data else {return}
      let response = response as? HTTPURLResponse
      if response?.statusCode != 200 {
        print("No data or status code not OK")
        return
      }
      guard let usersData = try? jsonDecoder.decode(RandomUsersDataRoot.self, from: data) else {
        print("Either no data was returned, or data was not serialized.")
        completion(nil)
        return
      }
      completion(usersData)
    }
    task.resume()
  }
}

