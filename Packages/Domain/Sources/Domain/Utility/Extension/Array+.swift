//
//  Array+.swift
//
//
//  Created by okudera on 2022/09/07.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
