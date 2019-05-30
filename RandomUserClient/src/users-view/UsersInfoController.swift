//
//  UsersInfoController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 30/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import Foundation

struct UsersInfoController {
  func fetchUsersData(completion: @escaping (RandomUsersDataRoot?) -> Void) {
    let baseURL = URL(string:"https://randomuser.me/api")!
    let query: [String: String] = [
      "seed": "qwerty",
      "results": "10",
      "page": "1"
    ]
    let url = baseURL.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
      let jsonDecoder = JSONDecoder()
      guard let data = data else {return}
      let response = response as? HTTPURLResponse
      if (response?.statusCode != 200) {
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
