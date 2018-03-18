//
//  MNCommon.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/14.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
import UIKit

let MN_SERVER_URL = "http://gateway.marvel.com/v1/"

let PUBLIC_KEY = "dfc082085e63cadb492ce2b606dc620a"

let PRIVATE_KEY = "3dc6c0203491b5e7431e1d7df8f6bea19cd1f6ae"

/// 导航栏+状态栏高度
let kNavBarHeight = UIApplication.shared.statusBarFrame.size.height + 44

/// 屏幕宽
let kScreenW = UIScreen.main.bounds.width

/// 屏幕高
let kScreenH = UIScreen.main.bounds.height

/// 横向通用间距
let kMargin = CGFloat(14)

let kPlaceHolderImage = UIImage.image(color: UIColor.hexInt(hex: 0x999999))


func TCLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("文件名:\((file as NSString).lastPathComponent)[行号:\(line)], 方法:\(method): \(message)")
    #endif
}

func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
