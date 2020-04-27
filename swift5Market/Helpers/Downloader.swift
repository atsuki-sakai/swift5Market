//
//  Downloader.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/27.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation
import FirebaseStorage


let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping(_ imageLinks: [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        
        var uploadImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.1)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil {
                    
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                    
                }else{
                    print("imageLink is nil")
                }
            }
            nameSuffix += 1
        }
        
    }else{
        print("Not Internet Connection")
    }
}
func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping(_ imageLinks: String?) -> Void) {
    
    var task: StorageUploadTask!
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        
        //observeを解除
        task.removeAllObservers()
        
        if let error = error {
            
            print(error.localizedDescription)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, error) in
            
            guard let downloadURL = url else {
                
                completion(nil)
                return
            }
            completion(downloadURL.absoluteString)
            
        }
    })
    task.resume()
}
