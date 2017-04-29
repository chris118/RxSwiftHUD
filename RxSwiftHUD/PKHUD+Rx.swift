//
//  RxPKHUD.swift
//  RxSwiftHUD
//
//  Created by xiaopeng on 2017/4/29.
//  Copyright © 2017年 PT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD


extension HUD {
    
    //http://stackoverflow.com/questions/36699772/rxswift-how-to-show-a-progress-bar
    // 因为HUD.show是静态函数，这里扩展的Observer需要定义成静态
    public static var rx_hud_animating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                 print(error)
            case .completed:
                break
            }
        }
    }
}

// http://stackoverflow.com/questions/41932734/how-to-show-hide-the-progresshud-with-mvvm-and-rxswift-in-swift
//// 如果HUD 继承自 UIView 用次方式扩展Rx， HUD.rx.isAnimating
//// 参考RxSwift中的 UIActivityIndicatorView+Rx.swift 实现
//extension Reactive where Base: HUD {
//    
//    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
//    public var isAnimating: UIBindingObserver<Base, Bool> {
//        return UIBindingObserver(UIElement: self.base) { pkhud, active in
//            if active {
//                HUD.show(.progress)
//            } else {
//                HUD.hide()
//            }
//        }
//    }
//    
//}
