//
//  ViewModel.swift
//  RxSwiftHUD
//
//  Created by xiaopeng on 2017/4/29.
//  Copyright © 2017年 PT. All rights reserved.
//

import RxSwift
import RxCocoa
import PKHUD
import RxSwiftUtilities

struct CommonError: Error {
    let error1: String
}

class ViewModel {
    
    struct Input {
            var loadButtonTap: Driver<Void>
    }
    struct Output {
            var indicatorTracker: Driver<Bool>
            let errorTracker: Driver<String>
            var fetchSomthing: Driver<String>
    }

    init() {
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        
        //模拟网络请求
        let fetchRequest =
            Observable<String>.create({ (observer) -> Disposable in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    observer.onNext("Chris")
                    observer.onError(CommonError(error1: "404"))
                    observer.onCompleted()
                })
                return Disposables.create()
        })
        
        let fetchDriver  = input.loadButtonTap.flatMapLatest{
                   return fetchRequest
                     .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: "error")
                }
        
        //根据错误代码 转化成 错误消息
        let transformError = errorTracker
            .map{ error -> String in
                let commonError = error as! CommonError
                switch commonError.error1 {
                case "404":
                    return "错误: 不能找到页面"
                default:
                    return "unknown"
                }

                
        }
        
        
        return Output (
            indicatorTracker: activityIndicator.asDriver(),
            errorTracker: transformError.asDriver(),
            fetchSomthing: fetchDriver
        )
    }
}
