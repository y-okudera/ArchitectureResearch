//
//  NSError+.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Foundation

extension NSError {
    func isEqual(to: NSError) -> Bool {
        let lhs = self as Error
        let rhs = to as Error
        return isEqual(to) && lhs.reflectedString == rhs.reflectedString
    }
}
