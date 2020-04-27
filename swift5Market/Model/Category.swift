//
//  Category.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/25.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init (_name: String, _imageName: String) {
        
        id = ""
        name = _name
        image = UIImage(named: _imageName)
        imageName = _imageName
    }
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
        
    }
   
}

//MARK: Save Category Function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
    
}
func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id,category.name,category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
    
}

//MARK: Download Category From Firebase
func downloadCategoriesFromFireStore(completion: @escaping(_ categoryArray: [Category]) -> Void){
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapShot, error) in
        
        if let error = error {
            print("Error : \(error.localizedDescription)")
            return
        }
        guard let snapShot = snapShot else {
            
            completion(categoryArray)
            return
        }
        if snapShot.isEmpty {
            
            print("snapShot is Empty")
            return
        }
        for categoryDictionary in snapShot.documents {
            
            categoryArray.append(Category(_dictionary: categoryDictionary.data() as NSDictionary))
           
        }
        completion(categoryArray)
    }
}

//MARK: Save Category
func createCategorySet() {
    
    let womenClothing = Category(_name: "Women's Clothing & Accessories", _imageName: "womenCloth")
    let footWaer = Category(_name: "FootWaer", _imageName: "footWaer")
    let electronics = Category(_name: "Electronics", _imageName: "electronics")
    let menClothing = Category(_name: "Men's Clothing & Accessories", _imageName: "menCloth")
    let health = Category(_name: "Health & Beauty", _imageName: "health")
    let baby = Category(_name: "Baby Stuff", _imageName: "baby")
    let home = Category(_name: "Home & Kitchen", _imageName: "home")
    let car = Category(_name: "Automobiles & Motorcycle", _imageName: "car")
    let luggage = Category(_name: "Luggage & bags", _imageName: "luggage")
    let hobby = Category(_name: "Hobby, Sport, Traveling", _imageName: "hobby")
    let jewelery = Category(_name: "Jewelery", _imageName: "jewelery")
    let pet = Category(_name: "Pet Products", _imageName: "pet")
    let industry = Category(_name: "Industry & Bussines", _imageName: "industry")
    let garden = Category(_name: "Garden supplies", _imageName: "garden")
    let camera = Category(_name: "Camera & Optics", _imageName: "camera")
    
    let arrayOfCategories = [womenClothing,footWaer,electronics,menClothing,health,baby,home,car,luggage,hobby,jewelery,pet,industry,garden,camera]
    
    for category in arrayOfCategories {
        
        saveCategoryToFirebase(category)
        
    }
    
}
