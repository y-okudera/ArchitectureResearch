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
        self.path = "/\(statusCode)"
        self.sleep = sleep
    }

    var baseUrl: String {
        return "https://httpstat.us"
    }

    var method: String {
        return "GET"
    }

    var timeoutInterval: TimeInterval {
        return 2.0
    }

    var headerFields: [String: String] {
        return [
            "Accept": "application/json",
        ]
    }

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "sleep", value: sleep.description),
        ]
    }
}
