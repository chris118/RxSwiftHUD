//
//  PTProgressHUD+Rx.swift
//  RxSwiftHUD
//
//  Created by xiaopeng on 2017/4/29.
//  Copyright © 2017年 PT. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import PKHUD


extension PTProgressHUD {

    public static func rx_hud_animating(msg: String) -> AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                    PTProgressHUD.show(msg)
                } else {
                    PTProgressHUD.dismiss(0)
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }
    
    public static func rx_hud_error() -> AnyObserver<String> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                PTProgressHUD.show(value, delay: 2)
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }
}

