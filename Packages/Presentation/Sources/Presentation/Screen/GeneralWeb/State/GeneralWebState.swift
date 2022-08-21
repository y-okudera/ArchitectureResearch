//
//  GeneralWebState.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

final actor GeneralWebState {
    let initialUrl: URL

    init(initialUrl: URL) {
        self.initialUrl = initialUrl
    }
}
