//
//  Item.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/27.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    init(_dictionnary: NSDictionary) {
        
        id = _dictionnary[kOBJECTID] as? String
        categoryId = _dictionnary[kCATEGORYID] as? String
        name = _dictionnary[kNAME] as? String
        description = _dictionnary[kDESCRIPTION] as? String
        price = _dictionnary[kPRICE] as? Double
        imageLinks = _dictionnary[kIMAGELINKS] as? [String]
        
    }
    
}
//MARK:Save Items Function
func saveItemToFireStore(_ item: Item){
    
    FirebaseReference(.Item).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
    
}

//MARK: Helpers
func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id,item.categoryId,item.name,item.description,item.price,item.imageLinks], forKeys: [kOBJECTID as NSCopying,kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
    
}
