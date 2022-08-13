//
//  UIScrollView+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

import Combine
import UIKit

extension UIScrollView {
    /// A publisher emitting content offset changes from this UIScrollView.
    var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        publisher(for: \.contentOffset)
            .eraseToAnyPublisher()
    }

    /// A publisher emitting if the bottom of the UIScrollView is reached.
    ///
    /// - parameter offset: A threshold indicating how close to the bottom of the UIScrollView this publisher should emit.
    ///                     Defaults to 0
    /// - returns: A publisher that emits when the bottom of the UIScrollView is reached within the provided threshold.
    func reachedBottomPublisher(offset: CGFloat = 0) -> AnyPublisher<Void, Never> {
        contentOffsetPublisher
            .map { [weak self] contentOffset -> Bool in
                guard let self = self else { return false }
                let visibleHeight = self.frame.height - self.contentInset.top - self.contentInset.bottom
                let yDelta = contentOffset.y + self.contentInset.top
                let threshold = max(offset, self.contentSize.height - visibleHeight)
                return yDelta > threshold
            }
            .removeDuplicates()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
