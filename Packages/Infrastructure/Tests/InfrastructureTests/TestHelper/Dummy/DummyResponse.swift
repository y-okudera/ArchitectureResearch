//
//  DummyResponse.swift
//
//
//  Created by Yuki Okudera on 2022/08/13.
//

@testable import Infrastructure
import Foundation

struct DummyResponse: Decodable {
    let code: Int
    let description: String
}
