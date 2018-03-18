//
//  MHNetworkManager+Extension.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/15.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

extension MHNetworkManager {
    
    /// Fetches lists of comic characters with optional filters
    ///
    /// - Parameters:
    ///   - offset: The requested offset (number of skipped results) of the call
    ///   - completion: completion callback
    func requestHeroListData(name: String?, offset: Int, completion: @escaping CompletionBlock) {
        let URLStr = MN_SERVER_URL + "public/characters"
        var params = ["limit" : 20, "offset": offset] as [String: Any]
        if let name = name { params["nameStartsWith"] = name }
        MHNetworkManager.shared.get(URLStr: URLStr, params: params) { (data, code, isSuccess) in
            completion(data, code, isSuccess)
        }
    }
    
    /// Fetches lists of comics containing a specific character
    ///
    /// - Parameters:
    ///   - characterId: characterId
    ///   - completion: completion: completion callback
    func requestHeroComicsData(characterId: Int, completion: @escaping CompletionBlock) {
        let URLStr = MN_SERVER_URL + "public/characters/\(characterId)/comics"
        let params = ["limit" : 3, "offset": 0]
        MHNetworkManager.shared.get(URLStr: URLStr, params: params, isShowLoading: false) { (data, code, isSuccess) in
            completion(data, code, isSuccess)
        }
    }
    
    /// Fetches lists of events in which a specific character appears
    ///
    /// - Parameters:
    ///   - characterId: characterId
    ///   - completion: completion: completion callback
    func requestHeroEventsData(characterId: Int, completion: @escaping CompletionBlock) {
        let URLStr = MN_SERVER_URL + "public/characters/\(characterId)/events"
        let params = ["limit" : 3, "offset": 0]
        MHNetworkManager.shared.get(URLStr: URLStr, params: params, isShowLoading: false) { (data, code, isSuccess) in
            completion(data, code, isSuccess)
        }
    }
    
    /// Fetches lists of comic series in which a specific character appears
    ///
    /// - Parameters:
    ///   - characterId: characterId
    ///   - completion: completion: completion callback
    func requestHeroSeriesData(characterId: Int, completion: @escaping CompletionBlock) {
        let URLStr = MN_SERVER_URL + "public/characters/\(characterId)/series"
        let params = ["limit" : 3, "offset": 0]
        MHNetworkManager.shared.get(URLStr: URLStr, params: params, isShowLoading: false) { (data, code, isSuccess) in
            completion(data, code, isSuccess)
        }
    }
    
    /// Fetches lists of comic stories featuring a specific character with optional filters.
    ///
    /// - Parameters:
    ///   - characterId: characterId
    ///   - completion: completion: completion callback
    func requestHeroStoriesData(characterId: Int, completion: @escaping CompletionBlock) {
        let URLStr = MN_SERVER_URL + "public/characters/\(characterId)/stories"
        let params = ["limit" : 3, "offset": 0]
        MHNetworkManager.shared.get(URLStr: URLStr, params: params, isShowLoading: false) { (data, code, isSuccess) in
            completion(data, code, isSuccess)
        }
    }
}
