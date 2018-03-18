//
//  MHLikeHero+CoreDataProperties.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/17.
//  Copyright © 2018年 姚巍. All rights reserved.
//
//

import Foundation
import CoreData


extension MHLikeHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHLikeHero> {
        return NSFetchRequest<MHLikeHero>(entityName: "MHLikeHero")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?

}
