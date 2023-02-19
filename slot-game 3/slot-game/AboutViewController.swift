//
//  AboutViewController.swift
//  slot-game
//
//   Created by
//  Sriskandarajah Sayanthan  301279325.
//  Neha Patel  301280513
//  Rutvik Lathiya 301282022

import Foundation
import CoreData
import UIKit

class AboutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var per:[NSManagedObject]  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList()
        tableView.register(UITableViewCell.self,
                              forCellReuseIdentifier: "TableViewCell")
        
        
        tableView.delegate = self
           
        self.tableView.rowHeight = 80
        tableView.dataSource = self
    }
    func fetchList() {
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "Entity")
        let sort = NSSortDescriptor(key: "value", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            let fetchResults = try moc.fetch(fetchRequest)
            
            for Entity in fetchResults as [NSManagedObject] {
                
                let entity1 = Entity.value(forKey: "name")
                let entitu2 = Entity.value(forKey: "value")
                per.append(Entity)
//                per = personModel( int: entitu2 as! Float, name: entity1 as! String)
                
              
                
            }
//            per.sorted(by: { $0.value(forKey: "value") as! Int  > $1.value(forKey: "value") as! Int })
            print("\(per)")
            } catch {
                
                print(error.localizedDescription)
            }
        }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return per.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        
        let detail = "Name:- \((per[indexPath.row].value(forKey: "name") as? String ?? ""))"
        let value = ", Dollor:\(per[indexPath.row].value(forKey: "value") ?? "")"
        let space = " "
        cell.textLabel?.text = detail + space + value
        print()
//        cell.detailTextLabel?.text = "78990"
        
            return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300.0;//Choose your custom row height
//    }
}
