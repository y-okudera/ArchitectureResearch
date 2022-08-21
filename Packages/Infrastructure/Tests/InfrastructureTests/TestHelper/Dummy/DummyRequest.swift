//
//  DummyRequest.swift
//
//
//  Created by Yuki Okudera on 2022/08/13.
//

@testable import Infrastructure
import Foundation

struct DummyRequest: ApiRequestable {
    typealias Response = DummyResponse

    let sleep: Int
    let path: String

    init(statusCode: Int, sleep: Int) {
        path = "/\(statusCode)"
        self.sleep = sleep
    }

    let baseUrl: String = "https://httpstat.us"

    let method: String = "GET"

    let timeoutInterval: TimeInterval = 2.0

    let headerFields: [String: String] = [
        "Accept": "application/json",
    ]

    var queryItems: [URLQueryItem]? {
        [
            .init(name: "sleep", value: "\(sleep)"),
        ]
    }
}
