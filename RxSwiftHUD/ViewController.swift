//
//  ViewController.swift
//  RxSwiftHUD
//
//  Created by xiaopeng on 2017/4/28.
//  Copyright © 2017年 PT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class ViewController: UIViewController {

    @IBOutlet weak var loadButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRx()
    }
    
    fileprivate func configRx(){
        let input = ViewModel.Input(loadButtonTap: loadButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        // ding for HUD
        output.indicatorTracker.drive(HUD.rx_hud_animating).addDisposableTo(disposeBag)
        output.errorTracker.drive(PTProgressHUD.rx_hud_error()).addDisposableTo(disposeBag)
        
        output.fetchSomthing.asObservable()
            .subscribe{ (element) in
                print("response: \(element)")
            }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
    }
}

