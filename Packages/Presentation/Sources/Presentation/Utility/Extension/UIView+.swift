//
//  UIView+.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import UIKit

extension UIView {
    func recursiveSubviews() -> [UIView] {
        subviews + subviews.flatMap { $0.recursiveSubviews() }
    }

    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        recursiveSubviews().compactMap { $0 as? T }
    }
}
