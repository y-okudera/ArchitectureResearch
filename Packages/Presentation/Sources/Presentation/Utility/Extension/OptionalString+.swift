//
//  OptionalString+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
