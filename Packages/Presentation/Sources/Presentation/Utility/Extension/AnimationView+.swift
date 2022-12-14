//
//  AnimationView+.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation
import Lottie

extension AnimationView {
    convenience init(
        asset name: String,
        bundle: Bundle = .module,
        imageProvider: AnimationImageProvider? = nil,
        animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache
    ) {
        let animation = Animation.asset(name, bundle: bundle, animationCache: animationCache)
        let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
        self.init(animation: animation, imageProvider: provider)
    }
}
