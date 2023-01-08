//
//  TableViewController.swift
//  Notes Application-Swift
//
//  Created by Sahid Reza on 07/01/23.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet var listTableView: UITableView!
    
    var myArrayList:[ItemList] = [ItemList]()
    var textFieldValue = UITextField()
    let presetencearrylistStorage = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appending(path: "myitem.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        UiAlertPorcessed()
    }
    
}

extension TableViewController {
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArrayList.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCelll", for: indexPath)
        
        let item = myArrayList[indexPath.row]
        
        cell.textLabel?.text = item.tilte
        
        cell.accessoryType = item.itemStatus ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myArrayList[indexPath.row].itemStatus = !myArrayList[indexPath.row].itemStatus
        writeItem()
        self.listTableView.reloadData()
        listTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension TableViewController{
    
    func UiAlertPorcessed(){
        
        let alert = UIAlertController(title: "Please Add item", message: "", preferredStyle: .alert)
        let actttion = UIAlertAction(title: "Add Item", style: .default){(alert) in
            
            if self.textFieldValue.text != "" {
                DispatchQueue.main.async {
                    
                    var newItem = ItemList()
                    newItem.tilte = self.textFieldValue.text!
                    self.myArrayList.append(newItem)

                    self.writeItem()
                    
                    self.listTableView.reloadData()
                    
                }
            }
            
        }
        
        alert.addTextField{(alertTextField) in

            alertTextField.placeholder = "Please add Item"
            self.textFieldValue = alertTextField
            
        }

        alert.addAction(actttion)
        
        self.present(alert, animated: true)
        
        
    }
    
    
}

extension TableViewController{
    
    func writeItem(){
        
        let encoder = PropertyListEncoder()

        do {
        
            let encoderData = try encoder.encode(self.myArrayList)
            try encoderData.write(to: self.filePath!)

        }catch{
            print("myError",error)
        }
        
    }
    
    func loadItem(){
        
        if let safeData = try? Data(contentsOf: filePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
                
                let decodeData = try decoder.decode([ItemList].self, from: safeData)
                self.myArrayList = decodeData
                
            }catch{
                print("Error:",error)
            }
            
            
        }
        
    }
}
