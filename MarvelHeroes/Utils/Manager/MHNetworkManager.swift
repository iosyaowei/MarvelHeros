//
//  MHNetworkManager.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/14.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

typealias CompletionBlock = (_ data: Data?, _ code: Int, _ isSuccess: Bool) -> ()
typealias SuccessBlock = (Data?, HTTPURLResponse?) -> ()
typealias FailBlock = (Error?, HTTPURLResponse?) -> ()

class MHNetworkManager: NSObject {
    
    var session: URLSession?
    
    lazy var queue: OperationQueue = {
        let que = OperationQueue()
        que.maxConcurrentOperationCount = 5
        return que
    }()
    
    static let shared: MHNetworkManager = {
        let manager = MHNetworkManager()
        return manager
    }()
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }
}

extension MHNetworkManager {
    func get(URLStr: String, params: [String: Any]?, isShowLoading: Bool = true, completion: @escaping CompletionBlock) {
        let dataTask = self.dataTask(method: .GET, URLStr: URLStr, params: params, isShowLoading: isShowLoading, successed: { (data, response) in
            do {
                if let data = data {
                    let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                    let status = MHStatus(jsonDic: jsonDic)
                    if status.code == 200 {
                        if let objArr = status.data.results {
                            let resultData = try JSONSerialization.data(withJSONObject: objArr, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                            completion(resultData, status.code, true)
                        }
                    }else {
                        completion(nil, status.code, false)
                    }
                }
            } catch let error {
                completion(nil, response!.statusCode, false)
                print("fail with error:\(String(describing: error.localizedDescription))")
            }
        }) { (error, response) in
            completion(nil, response!.statusCode, false)
            print("fail with error:\(String(describing: error?.localizedDescription))")
        }
        
        dataTask.resume()
    }
    
    func downloadImage(URLStr: String, completion: @escaping (_ data: Data?, _ isSuccess: Bool) -> ()) {
        let downloadTask = self.downloadTask(URLStr: URLStr, successed: { (data, response) in
            completion(data, true)
        }) { (error, response) in
            completion(nil, false)
            print("fail with error:\(String(describing: error?.localizedDescription))")
        }
        
        downloadTask.resume()
    }
    
}

extension MHNetworkManager {
    private func dataTask(method: HTTPMethod, URLStr: String, params: [String: Any]?, isShowLoading: Bool, successed: SuccessBlock?, failed: FailBlock?) -> URLSessionTask {
        
        let tampStr = Date().timestamp()
        var authParams = ["apikey": PUBLIC_KEY, "hash": (tampStr + PRIVATE_KEY + PUBLIC_KEY).md5String(), "ts": tampStr] as [String: Any]
        if let params = params {
            authParams += params
        }
        
        let URLString = URLStr + "?" + query(authParams)
        var request = URLRequest(url: URL(string: URLString)!)
        request.httpMethod = method.rawValue
        if isShowLoading {
            MHProgressHudManager.shared.showLoadingView()
        }
        
        let task = session?.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if isShowLoading {
                    MHProgressHudManager.shared.hiddenLoadingView()
                }
                
                if let error = error {
                    print("fail with error:\(error.localizedDescription)")
                    failed?(error, response as? HTTPURLResponse)
                }else {
                    successed?(data, response as? HTTPURLResponse)
                }
            }
        })
        
        return task!
    }
    
    private func downloadTask(URLStr: String, successed: SuccessBlock?, failed: FailBlock?) -> URLSessionDownloadTask {
        let request = URLRequest(url: URL(string: URLStr)!)
        let task = session?.downloadTask(with: request, completionHandler: { (url, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("fail with error:\(error.localizedDescription), url:\(url?.description ?? "unkown")")
                    failed?(error, response as? HTTPURLResponse)
                }else {
                    do {
                        let data = try Data(contentsOf: url!)
                        successed?(data, response as? HTTPURLResponse)
                    }catch let err {
                        TCLog("获取缓存数据Data失败\(err.localizedDescription)")
                    }
                }
            }
        })
        
        return task!
    }
}

extension MHNetworkManager {
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                let substring = string[range]
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                index = endIndex
            }
        }
        
        return escaped
    }
    
}

extension MHNetworkManager: URLSessionDelegate {
    
}
