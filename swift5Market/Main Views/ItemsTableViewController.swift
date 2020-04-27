//
//  ItemsTableViewController.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/27.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class ItemsTableViewController: UIViewController {

    //MARK: IBOutlets Vars
    @IBOutlet weak var tableView: UITableView!
   
    //MARK: Vars
    var category: Category?
    var itemArray: [Item] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("send Category : \(category!.name)")
        
    }
    //MARK: IBOUtlet Actions
    @IBAction func navigationBarAddButtonTaped(_ sender: Any) {
        
        performSegue(withIdentifier: "addVC", sender: self.category)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if segue.identifier == "addVC" {
            
            let vc = segue.destination as! AddItemViewController
            
            vc.category = sender as? Category
            return
            
        }
        print("Segue called addVC was not found")
    }

}
//MARK: TableView Delegate DataSource

