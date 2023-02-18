//
//  FavoriteTableViewController.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 7.02.2023.
//

import UIKit
import CoreData
import SCLAlertView

class FavoriteTableViewController: UITableViewController {

    var nameArray = [String]()
    var idArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        getCoreData()
        setBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getCoreData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        setBackground()
    }
    
    private func setNavigation() {
        title = LocalizableString.FavoriteScreenTitle.localized
    }
    
    private func setBackground() {
        if nameArray.count == 0 {
            self.tableView.backgroundView = FavoritePlaceholderView()
        }else {
            self.tableView.backgroundView = nil
        }
    }
    
    @objc private func getCoreData() {
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        nameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? Int{
                        idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        }catch{
            print("error")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FavoriteTableViewCell", owner: self, options: nil)?.first as! FavoriteTableViewCell
        cell.favoriteNameLabel.text = nameArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            
            let name = nameArray[indexPath.row]
            fetchRequest.predicate = NSPredicate(format: "name = %@", name)
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String{
                            if name == nameArray[indexPath.row] {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do{
                                    try context.save()
                                    SCLAlertView().showSuccess(LocalizableString.Success.localized, subTitle: LocalizableString.DeletedAlertMessage.localized)
                                }catch{
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
            }catch{
                print("error")
            }
        }
    }

}

