//
//  CategoryCollectionViewController.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/25.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController {

    //MARK: IBoutlet Vars
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    //MARK: Vars
    var categoryArray: [Category] = []
    
    //MARK: Let
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TransParency NavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCategories()
    }
    //MARK: Download Categories
    private func loadCategories(){
        
        downloadCategoriesFromFireStore { (allCategories) in
            
            self.categoryArray = allCategories
            self.categoryCollectionView.reloadData()
            print("all Category Count : \(self.categoryArray.count)")
            
        }
    }
}
//MARK: UICollectionView Delegate DataSource
extension CategoryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.toFields(categoryArray[indexPath.row])
        
        return cell
     
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CategoryItemSegue", sender: categoryArray[indexPath.row])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CategoryItemSegue"{
            
            let vc = segue.destination as! ItemsTableViewController
            
            vc.category = sender as? Category
            return
            
        }
        print("categoryItemSegue can not find")

    }

}
//MARK: CollectionView FlowLayout
extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow
        
        //cellの大きさを返す
        return CGSize(width: withPerItem, height: withPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
    
}
