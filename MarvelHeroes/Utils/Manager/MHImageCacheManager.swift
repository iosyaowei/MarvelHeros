//
//  MHWebImageCasheManager.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/15.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

class MHImageCacheManager {
    
    static let WEB_IMAGE_CACHE = NSHomeDirectory() + "/Library/Caches/WebImageCache"
    
    class func readCacheFrom(URLString: String) -> Data? {
        var data: Data?
        let path = MHImageCacheManager.fullCachePathFromURL(URLString: URLString)
        if FileManager.default.fileExists(atPath: path) {
            data = try? Data(contentsOf: URL(fileURLWithPath: path))
        }
        
        return data
    }
    
    class func writeCaheTo(URLString: String, data: Data) {
        let path = MHImageCacheManager.fullCachePathFromURL(URLString: URLString)
        do {
            try data.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch let error {
            TCLog("Image cache data is written to disk failure:\(error.localizedDescription)")
        }
    }
    
    class func fullCachePathFromURL(URLString: String) -> String {
        if !FileManager.default.fileExists(atPath: WEB_IMAGE_CACHE) {
            do {
                try FileManager.default.createDirectory(atPath: WEB_IMAGE_CACHE, withIntermediateDirectories: true, attributes: nil)
            }catch let error {
                TCLog("Creating a cache path failure:\(error.localizedDescription)")
            }
        }
        
        return WEB_IMAGE_CACHE + "/" + URLString.md5String()
    }
    
}


