//
//  GeneralWebState.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

struct GeneralWebState {
    let initialUrl: URL

    init(initialUrl: URL) {
        self.initialUrl = initialUrl
    }
}
