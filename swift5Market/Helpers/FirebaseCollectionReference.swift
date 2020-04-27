//
//  FirebaseCollectionReference.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/25.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    
    case User
    case Category
    case Item
    case Basket
    
}
func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}


