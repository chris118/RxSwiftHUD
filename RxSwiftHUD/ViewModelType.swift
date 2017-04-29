//
//  ViewModelType.swift
//  RxSwiftHUD
//
//  Created by xiaopeng on 2017/4/29.
//  Copyright © 2017年 PT. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
