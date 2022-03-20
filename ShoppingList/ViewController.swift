//
//  ViewController.swift
//  ShoppingList
//
//  Created by Abdullah Karagöz on 7.03.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var isimDizisi = [String]()
    var idDizisi = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(eklemeButtonuTiklandi))
        
        verileriAl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name(rawValue: "veriGirildi"), object: nil)
    }
    

   @objc func verileriAl(){
       isimDizisi.removeAll(keepingCapacity: false)
       idDizisi.removeAll(keepingCapacity: false)
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let sonuclar = try context.fetch(fetchRequest)
            
            for sonuc in sonuclar as! [NSManagedObject]{
                
                if let isim = sonuc.value(forKey: "isim") as? String {
                    isimDizisi.append(isim)
                }
                
                if let id = sonuc.value(forKey: "id") as? UUID {
                    idDizisi.append(id)
                }
                
            }
            tableView.reloadData()
        } catch {
            
        }
        
    }
    
   @objc func eklemeButtonuTiklandi() {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
    }

}

