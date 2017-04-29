//
//  PTProgressHUD.swift
//  PTLatitude
//
//  Created by 王炜程 on 16/8/29.
//  Copyright © 2016年 PT. All rights reserved.
//  
//  统一提示弹框
//

import UIKit

let Screenwidth = UIScreen.main.bounds.size.width
let Screenheight = UIScreen.main.bounds.size.height

class PTProgressHUD: NSObject {
    
    static let shareInstance = PTProgressHUD()
    fileprivate var isTipShown = false
    
    // MARK: - Life
    fileprivate override init(){}
    
    deinit {
        print("PTProgressHUD was deinit")
    }
    
    /**
     提示框，
     
     - author: wangweicheng
     
     - parameter message: 提示文字
     */
    class func show(_ message: String) {
        PTProgressHUD.shareInstance.show(message)
        PTProgressHUD.dismiss(2)
        
    }
    
    class func show(_ message: String, delay: Float) {
        PTProgressHUD.shareInstance.show(message)
        PTProgressHUD.dismiss(delay)
    }
    

    class var backgroundColor: UIColor? {
        get {
            return PTProgressHUD.shareInstance.tipView.backgroundColor
        }
        set (color) {
            PTProgressHUD.shareInstance.tipView.backgroundColor = color
        }
    }

    class func show(_ message: String, delay: Float, centerPoint: CGPoint) {
        PTProgressHUD.shareInstance.show(message, centerPoint: centerPoint)
        PTProgressHUD.dismiss(delay)
    }

    /**
     关闭提示框
     
     - author: wangweicheng
     
     - parameter delay: 延时时间
     */
    class func dismiss(_ delay: Float) {
        let delay_sec = NSEC_PER_SEC * UInt64(delay)
        
        let t = DispatchTime.now() + Double(Int64(delay_sec)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: t) {
            PTProgressHUD.shareInstance.dismiss()
        }
    }
    
    // MARK: - private functions
    fileprivate func show(_ message: String) {
        // 如果有键盘，收起键盘
        // UIApplication.sharedApplication().keyWindow?.endEditing(true)
        
        DispatchQueue.main.async {
            if self.hudView.superview == nil {
                self.keyView()?.addSubview(self.hudView)
                self.keyView()?.bringSubview(toFront: self.hudView)
            }
            
            if self.msgLabel.superview == nil {
                self.msgLabel.font = UIFont.systemFont(ofSize: 14)
                self.hudView.addSubview(self.msgLabel)
            }
            self.msgLabel.text = message
            // 计算文字占用的rect
            let maxSize = CGSize(width: 260.0, height: 2000.0)
            let options = NSStringDrawingOptions(arrayLiteral: .truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading)
            let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]
            let size = (message as NSString).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
        
            self.msgLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + 30, height: size.height + 20))
            
            let point = CGPoint(x: self.hudView.frame.size.width / 2, y: self.hudView.frame.size.height / 2)
            self.msgLabel.center = point
            
        }
    }

    fileprivate func show(_ message: String, centerPoint: CGPoint?) {
        // 如果有键盘，收起键盘
        // UIApplication.sharedApplication().keyWindow?.endEditing(true)
        
        DispatchQueue.main.async {
            if self.hudView.superview == nil {
                self.keyView()?.addSubview(self.hudView)
                self.keyView()?.bringSubview(toFront: self.hudView)
            }
            
            if self.msgLabel.superview == nil {
                self.msgLabel.font = UIFont.systemFont(ofSize: 14)
                self.hudView.addSubview(self.msgLabel)
            }
            self.msgLabel.text = message
            // 计算文字占用的rect
            let maxSize = CGSize(width: 260.0, height: 2000.0)
            let options = NSStringDrawingOptions(arrayLiteral: .truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading)
            let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]
            let size = (message as NSString).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
            
            self.msgLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + 30, height: size.height + 20))
            
            let point = CGPoint(x: self.hudView.frame.size.width / 2, y: self.hudView.frame.size.height / 2)
            self.msgLabel.center = centerPoint ?? point
    
        }
    }
    
    fileprivate func dismiss()  {

        UIView.animate(withDuration: 0.15,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: { 
                                    self.hudView.transform = self.hudView.transform.scaledBy(x: 0.8, y: 0.8)
                                    self.hudView.alpha = 0
            }) { (finished) in
                if self.hudView.alpha == 0 {
                    self.msgLabel.removeFromSuperview()
                    self.hudView.removeFromSuperview()
                    // 动画结束后，还原缩放
                    self.hudView.transform = CGAffineTransform.identity
                    self.hudView.alpha = 1
                    
                    let windows = UIApplication.shared.windows
                    for (_,window) in windows.enumerated() {
                        if window.windowLevel == 0.0 {
                            window.makeKey()
                        }
                    }
                    
                }
        }
    }
    
    fileprivate func keyView() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    fileprivate var topView: UIView? {
        get {
            return keyView()?.subviews.first
        }
    }
    // MARK: - private property
    
    fileprivate let tipView = UIView()
    
    fileprivate lazy var hudView : UIView = {
        let _hudView = UIView()
        _hudView.frame = CGRect(x:0, y:0, width: Screenwidth, height: Screenheight)
        _hudView.isUserInteractionEnabled = false
        return _hudView
    }()
    
    fileprivate let msgLabel : UILabel = {
        let msgl = UILabel()
        msgl.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        msgl.textColor = UIColor.white
        msgl.textAlignment = .center
        msgl.font = UIFont.systemFont(ofSize: 14)
        msgl.numberOfLines = 0
        
        msgl.layer.masksToBounds = true
        msgl.layer.cornerRadius = 6.0
        
        return msgl
    }()
}

extension PTProgressHUD {
    
    class func showTip(for view: UIView, text: String) {
        let length = text.characters.count
        showTip(for: view, text: text, delay: 2 + Double(length - 4) * 0.2)
    }
    class func showTip(for view: UIView, text: String, delay: TimeInterval) {
        if PTProgressHUD.shareInstance.isTipShown {
            PTProgressHUD.dismissTip(delay: 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                PTProgressHUD.shareInstance.showTip(for: view, text: text)
                PTProgressHUD.dismissTip(delay: delay)
            })
        }else{
            PTProgressHUD.shareInstance.showTip(for: view, text: text)
            PTProgressHUD.dismissTip(delay: delay)
        }
    }
    
    class func dismissTip(delay: TimeInterval) {
        
        if let _ = PTProgressHUD.shareInstance.tipView.superview {
            PTProgressHUD.shareInstance.tipView.layer.removeAllAnimations()
        }
        
        UIView.animate(withDuration: 0.15,
                       delay: delay,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        PTProgressHUD.shareInstance.tipView.alpha = 0
        }) { (finished) in
            while(PTProgressHUD.shareInstance.tipView.subviews.count != 0){
                let child = PTProgressHUD.shareInstance.tipView.subviews.last
                child?.removeFromSuperview()
            }
            PTProgressHUD.shareInstance.tipView.removeFromSuperview()
            PTProgressHUD.shareInstance.tipView.alpha = 1
            PTProgressHUD.shareInstance.isTipShown = false
        }
    }
    
    /// 弹出提示框
    ///
    /// - Parameters:
    ///   - view: 需要提示信息的视图
    ///   - text: 提示文字
    fileprivate func showTip(for view: UIView,text: String) {
        
        tipView.backgroundColor = UIColor.white
        // 初始化标签
        let l = UILabel()
        l.textColor = UIColor.black
        l.textAlignment = .left
        l.text = text
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        tipView.addSubview(l)
        // 屏幕边距 15，文字左右边距 8，上下边距 10
        let size = (text as NSString).boundingRect(with: CGSize(width: Screenwidth - 30 - 20, height: Screenheight), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: l.font], context: nil).size
        l.frame = CGRect(x: 8, y: 10, width: size.width, height: size.height)
        
        let rect = view.convert(view.bounds, to: nil)
        var x = rect.maxX - rect.width/2 - 16 - 8   // x 坐标
        let right = size.width + 20 + x // 右边距
        
        if right + 15 > Screenwidth {
            x = Screenwidth - 15 - size.width - 20
        }
        
        let cornerX = rect.maxX - rect.width/2 - x    // 角标位置
        
        // 角标是一个底长 16，高 8 的三角形
        let tRect = CGRect(x: x, y: rect.origin.y - size.height - 25 - 8, width: size.width + 16, height: size.height + 20 + 8)
        tipView.frame = tRect
        
        // 绘制形状，圆角，角标
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 3, y: 0))
        path.addLine(to: CGPoint(x: tRect.width - 3, y: 0))
        path.addArc(withCenter: CGPoint(x: tRect.width - 3, y: 3), radius: 3, startAngle: CGFloat(M_PI * 1.5), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: tRect.width, y: tRect.height - 8 - 3))
        path.addArc(withCenter: CGPoint(x: tRect.width - 3, y: tRect.height - 8 - 3), radius: 3, startAngle: 0, endAngle: CGFloat(M_PI/2), clockwise: true)
        path.addLine(to: CGPoint(x: cornerX + 8, y: tRect.height - 8))
        path.addLine(to: CGPoint(x: cornerX, y: tRect.height))
        path.addLine(to: CGPoint(x: cornerX - 8, y: tRect.height - 8))
        path.addLine(to: CGPoint(x: 3, y: tRect.height - 8))
        path.addArc(withCenter: CGPoint(x: 3, y: tRect.height - 8 - 3), radius: 3, startAngle: CGFloat(M_PI/2), endAngle: CGFloat(M_PI), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: 3))
        path.addArc(withCenter: CGPoint(x: 3, y: 3), radius: 3, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        
        tipView.layer.mask = shapeLayer
        
        keyView()?.addSubview(tipView)
        isTipShown = true
    }
}
