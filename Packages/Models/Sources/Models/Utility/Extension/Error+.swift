//
//  Error+.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Foundation

extension Error {
    var reflectedString: String {
        String(reflecting: self)
    }

    func isEqual(to: Self) -> Bool {
        reflectedString == to.reflectedString
    }
}
