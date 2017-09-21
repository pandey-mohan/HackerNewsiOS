//
//  Items.swift
//  HackerPiper
//
//  Created by mohan on 9/20/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import Foundation
import RealmSwift



class IntObject: Object {
    dynamic var value = 0
}

class Item:Object{
    
    dynamic var id: Int = -1
    dynamic var type: String?
    dynamic var by: String?
    dynamic var time: Int = 0
    dynamic var text: String?
    dynamic var parent: Int = -2
    dynamic var title: String?
    dynamic var score: Int = 0
    dynamic var url: String?
    dynamic var descendants: Int = 0
    dynamic var isFetched = false
    let kids = List<IntObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    class func initItemsWithId(ids: [Int], parent: Int = 0, isComment: Bool = false) -> Bool{
        
        for id in ids {
            do{
                let realm = try Realm()
                try realm.write{
                    let item = Item()
                    item.id = id
                    item.parent = parent
                    realm.add(item, update: true)
                    //realm.create(Item.self, value: dict, update: true)
                }
            }catch let _ as NSError{
                return false
            }
        }
        return true
    }
    
}
