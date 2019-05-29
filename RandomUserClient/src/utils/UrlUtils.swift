//
//  UrlUtils.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import Foundation

extension URL {
  func withQueries(_ queries: [String: String]) -> URL? {
    var components = URLComponents(url: self,
                                   resolvingAgainstBaseURL: true)
    components?.queryItems = queries.map
      { URLQueryItem(name: $0.0, value: $0.1) }
    return components?.url
  }
}
