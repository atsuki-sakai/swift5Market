//
//  AddItemViewController.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/27.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView
import Photos

class AddItemViewController: UIViewController {

    //MARK: IBOutlet Vars
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var princeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Vars
    var category: Category!
    var gallery: GalleryController!
    var hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    
    var imageView: UIImageView?
    let imageViewCount: CGFloat = 5
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(category.name)
        cameraUsePermission()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30, y: self.view.frame.width/2 - 30, width: 60, height: 60), type: .lineScale, color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), padding: nil)
        
    }
    //MARK: IBActions
    @IBAction func doneBarButtonItemTaped(_ sender: Any) {
        
        if fieldsAreCompleted() {
            
            saveToFirestore()
            
        }else{
            //アラートを出す
            self.hud.textLabel.text = "all fields are required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func addItemButtonTaped(_ sender: Any) {
        
        for i in 0..<itemImages.count {
            
            let deleteView = self.view.viewWithTag(i + 1) as? UIImageView
            deleteView?.removeFromSuperview()
        }
        showImageGallery()
    }
    @IBAction func tapGestureAction(_ sender: Any) {
        
        dismissKeyboad()
    }
    //MARK: Helper Function
    private func fieldsAreCompleted() -> Bool{
        
        return (self.TitleTextField.text != "" && self.princeTextField.text != "" && self.descriptionTextView.text != "")
        
    }
    private func dismissKeyboad(){
        
        self.view.endEditing(true)
        
    }
    private func popTheView(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    private func cameraUsePermission(){
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status {
                
            case .authorized:
                
                print("got permission")
                break
            case .denied,.notDetermined,.restricted:
                
                print("i did not have permission")
                break
            default: break
            }
        }
    }
    //MARK: Save Item
    private func saveToFirestore(){
        
        showLoadingIndicator()
        let item = Item()
        
        item.id = UUID().uuidString
        item.name = TitleTextField.text
        item.categoryId = category.id
        item.description = descriptionTextView.text
        item.price = Double(princeTextField.text!)
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { (ImageLinkArray) in
                
                item.imageLinks = ImageLinkArray
                saveItemToFireStore(item)
                self.hideLoadingIndicator()
                self.popTheView()
        
            }
        }else{
            self.hideLoadingIndicator()
            saveItemToFireStore(item)
            popTheView()

        }
    }
    //MARK: Activity Indicator
    private func showLoadingIndicator(){
        
        if activityIndicator != nil {
            
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    private func hideLoadingIndicator(){
        
        if activityIndicator != nil {
            
            activityIndicator?.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = Int(imageViewCount)
        
        self.present(self.gallery, animated: true, completion: nil)
        
    }
}
//MARK: Gallery Delegate
extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        self.itemImages = []
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
                
                for i in 0..<self.itemImages.count {
                    
                    self.imageView = UIImageView()
                    
                    let screen = UIScreen.main.bounds.size
                    let imageOriginY = screen.height - (screen.height/5) - (self.imageView?.frame.height)!
                    
                    self.imageView?.frame = CGRect(x: (CGFloat(i)*screen.width/self.imageViewCount), y: imageOriginY, width: screen.width/self.imageViewCount, height: screen.width/self.imageViewCount)
                    self.imageView?.image = self.itemImages[i]
                    self.imageView?.tag = i + 1
                    self.view.addSubview(self.imageView!)
                }
                
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        //今回はビデオは実装しない
        return
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
