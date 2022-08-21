//
//  UIImage+.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import UIKit

extension UIImage {
    static func load(url: URL) async -> UIImage? {
        let urlRequest = URLRequest(url: url)
        do {
            let result = try await URLSession.shared.data(for: urlRequest)
            return UIImage(data: result.0)
        } catch {
            return nil
        }
    }
}
