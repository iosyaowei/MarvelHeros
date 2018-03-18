//
//  MNProgressHud.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/15.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
import UIKit
class MHProgressHudManager: NSObject {
    
    static let shared: MHProgressHudManager = {
        let manager = MHProgressHudManager()
        return manager
    }()
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        return container
    }()
    
    override init() {
        super.init()
        setupUI()
    }
    
   private func setupUI() {
        let bgLength: CGFloat = 90
        let bgView = UIView()
        bgView.frame = CGRect(x: kScreenW/2 - bgLength/2, y: kScreenH/2 - bgLength/2, width: bgLength, height: bgLength)
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.8)
        containerView.addSubview(bgView)
        
        let indicatorLength: CGFloat = 50
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorView.frame = CGRect(x: kScreenW/2 - indicatorLength/2, y: kScreenH/2 - indicatorLength/2 - 10, width: indicatorLength, height: indicatorLength)
        indicatorView.startAnimating()
        containerView.addSubview(indicatorView)
        
        let tipLabX = kScreenW/2 - bgLength/2 + 5
        let tipLabY = kScreenH/2 + indicatorLength/2 - 10
        let tipLab = UILabel(frame: CGRect(x: tipLabX, y: tipLabY, width: bgLength-10, height: bgLength/2 - indicatorLength/2 - 5))
        tipLab.font = UIFont.systemFont(ofSize: 15)    //设置系统字体和字号
        tipLab.textColor = UIColor.white
        tipLab.text = "加载中"
        tipLab.textAlignment = .center
        containerView.addSubview(tipLab)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        containerView.addGestureRecognizer(tap)
    }
    
    func showLoadingView(superView: UIView? = UIApplication.shared.keyWindow) {
        superView?.addSubview(containerView)
    }
    
    func hiddenLoadingView() {
        containerView.removeFromSuperview()
    }
    
    @objc private func tapGesture(sender: UITapGestureRecognizer) {
        containerView.removeFromSuperview()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
}
