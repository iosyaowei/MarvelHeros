//
//  MHStatus.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/14.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

struct MHStatus {
    var copyright: String?
    var status: String?
    var data: MHData
    var attributionText: String?
    var code: Int = 0
    var etag: String?
    var attributionHTML: String?
    
    init(jsonDic: Dictionary<String, AnyObject>) {
        copyright = jsonDic["copyright"] as? String
        status = jsonDic["status"] as? String
        data = MHData(jsonDic: jsonDic["data"] as! [String: AnyObject])
        attributionText = jsonDic["attributionText"] as? String
        code = jsonDic["code"] as! Int
        etag = jsonDic["etag"] as? String
        attributionHTML = jsonDic["attributionHTML"] as? String
    }
}

struct MHData {
    var offset: Int = 0
    var total: Int = 0
    var limit: Int = 0
    var results : [AnyObject]?
    var count: Int = 0
    
    init(jsonDic: Dictionary<String, AnyObject>) {
        offset = jsonDic["offset"] as! Int
        total = jsonDic["total"] as! Int
        limit = jsonDic["limit"] as! Int
        results = jsonDic["results"] as? [AnyObject]
        count = jsonDic["count"] as! Int
    }
}

struct MHCharacter: Codable {
    var comics: MHComics
    var series: MHSeries
    var modified: String
    var id: Int = 0
    var name: String
    var thumbnail: MHThumbnail
    var urls = [MHUrls]()
    var description: String
    var stories: MHStories
    var resourceURI: String
    var events: MHEvents
}

struct MHUrls: Codable {
    var type: String
    var url: String
}

struct MHEvents: Codable {
    var items = [MHItems]()
    var available: Int = 0
    var returned: Int = 0
    var collectionURI: String
}

struct MHStories: Codable {
    var items = [MHItems]()
    var available: Int = 0
    var returned: Int = 0
    var collectionURI: String
}

struct MHThumbnail: Codable {
    var exten: String
    var path: String
    
    var fullPath: String {
        return "\(path ).\(exten)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case exten = "extension"
        case path
    }}

struct MHSeries: Codable {
    var items = [MHItems]()
    var available: Int = 0
    var returned: Int = 0
    var collectionURI: String
}

struct MHItems: Codable {
    var type: String?
    var name: String
    var resourceURI: String
}

struct MHComics: Codable {
    var items = [MHItems]()
    var available: Int = 0
    var returned: Int = 0
    var collectionURI: String
}

struct MHDetailCharacter {
    var id: Int = 0
    var name: String?
    var image: String?
    var isLike: Bool = false
    var items = [MHItemsDetail]()
}

struct MHItemsDetail {
    var title: String
    var dataArr: [MHDetailItemProtocol]
}

protocol MHDetailItemProtocol {
    var itemTitle: String? {get}
    var itemDesc: String? {get}
    var itemImgURL: String? {get}
}

struct MHDetailComics: MHDetailItemProtocol, Codable {
    var itemTitle: String? {
        return title
    }
    
    var itemDesc: String? {
        return description
    }
    
    var itemImgURL: String? {
        if let thumbnail = thumbnail {
            return "\(thumbnail.path).\(thumbnail.exten)"
        }else {
            return nil
        }
    }
    
    var format: String
    var variantDescription: String
    var thumbnail: MHThumbnail?
    var diamondCode: String
    var modified: String
    var id: Int = 0
    var title: String
    var issueNumber: Int = 0
    var description: String?
    var pageCount: Int = 0
    var issn: String?
    var isbn: String?
    var digitalId: Int = 0
    var resourceURI: String
    var stories: MHStories
    var ean: String?
    var upc: String?
}

struct MHDetailEvent: MHDetailItemProtocol, Codable {
    var itemTitle: String? {
        return title
    }
    
    var itemDesc: String? {
        return description
    }
    
    var itemImgURL: String? {
        if let thumbnail = thumbnail {
            return "\(thumbnail.path).\(thumbnail.exten)"
        }else {
            return nil
        }
    }

    var thumbnail: MHThumbnail?
    var description: String?
    var end: String
    var start: String
    var modified: String?
    var id: Int = 0
    var urls = [MHUrls]()
    var title: String
    var resourceURI: String
    var stories: MHStories
}

struct MHDetailSeries: MHDetailItemProtocol, Codable {
    var itemTitle: String? {
        return title
    }
    
    var itemDesc: String? {
        return description
    }
    
    var itemImgURL: String? {
        if let thumbnail = thumbnail {
            return "\(thumbnail.path).\(thumbnail.exten)"
        }else {
            return nil
        }
    }

    var thumbnail: MHThumbnail?
    var endYear: Int = 0
    var rating: String
    var type: String
    var startYear: Int = 0
    var events: MHEvents
    var modified: String
    var id: Int = 0
    var urls = [MHUrls]()
    var title: String
    var description: String?
    var resourceURI: String
    var stories: MHStories
}

struct MHDetailStory: MHDetailItemProtocol, Codable {
    
    var itemTitle: String? {
        return title
    }
    
    var itemDesc: String? {
        return description
    }
    
    var itemImgURL: String? {
        if let thumbnail = thumbnail {
            return "\(thumbnail.path).\(thumbnail.exten)"
        }else {
            return nil
        }
    }
    
    var thumbnail: MHThumbnail?
    var description: String?
    var type: String
    var modified: String?
    var id: Int = 0
    var title: String?
    var resourceURI: String?
}






