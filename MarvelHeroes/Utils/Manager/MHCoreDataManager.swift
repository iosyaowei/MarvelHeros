//
//  MHCoreDataManager.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/18.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit
import CoreData

class MHCoreDataManager {
        
    lazy var context: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        return context
    }()
    
    static let shared: MHCoreDataManager = {
        let manager = MHCoreDataManager()
        return manager
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MarvelHeroesCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension MHCoreDataManager {
    func insertLikeHeroData(heroDetail: MHDetailCharacter) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "MHLikeHero", in: context)!
        let hero = NSManagedObject(entity: entity, insertInto: context) as! MHLikeHero
        hero.id = Int64(heroDetail.id)
        hero.name = heroDetail.name
        hero.image = heroDetail.image
        
        do {
            try context.save()
            return true
        } catch let error {
            TCLog("coreData save fail:\(error.localizedDescription)")
            return false
        }
    }
    
    func selectLikeHeroData(heroId: Int?) -> [MHLikeHero] {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MHLikeHero")
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = 0
        
        if let heroId = heroId {
            let predicate = NSPredicate(format: "id = %d", heroId)
            fetchRequest.predicate = predicate
        }
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as! [MHLikeHero]
            return fetchedObjects
        } catch let error{
            fatalError("select fail： \(error.localizedDescription)")
        }
    }
    
    func deleteLikeHeroData(heroId: Int) {
        let heroLikeArr = selectLikeHeroData(heroId: heroId)
        
        heroLikeArr.forEach { (likeHero) in
            self.context.delete(likeHero)
            saveContext()
        }
    }

}
