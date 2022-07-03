//
//  ListViewController.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/11/21.
//

import UIKit
import Firebase
import GradientView 

class ListViewController: UIViewController {
    
    @IBOutlet weak var bottomView: GradientView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    
    let db = Firestore.firestore()
    var list: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.titleForList
        navigationItem.leftBarButtonItem?.title = "Edit"
        tableView.allowsSelection = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellId)
        
        bottomView.colors = [UIColor(named: K.BrandColor.blue) ?? .clear, UIColor(named: K.BrandColor.greenBlue) ?? .clear]
        
        loadList()
    }
    
    //MARK: - Send button pressed -load data in db
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let itemName = itemTextField.text, let sender = Auth.auth().currentUser?.email {
            db.collection(K.FSStore.collectionName).addDocument(data: [
                K.FSStore.senderField: sender,
                K.FSStore.itemNameField: itemName,
                K.FSStore.checkMarkField: false,
                K.FSStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data in Firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
        DispatchQueue.main.async {
            self.itemTextField.text = ""
        }
    }
    
    
    
    //MARK: - LogOut/Edit on Navigation controll
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            //if signed out successfully - go to Welcome screen through navigation controller
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        
        if sender.title == "Edit" {
            
            sender.title = "Done"
            tableView.allowsSelection = true
            
        } else {
            sender.title = "Edit"
            tableView.allowsSelection = false
        }
    }
    
    //MARK: - Get data from DB
    func loadList() {
        
        db.collection(K.FSStore.collectionName)
            .order(by: K.FSStore.dateField, descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.list = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore: \(e)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                       // print(data)
                        
                        if let itemSender = data[K.FSStore.senderField] as? String,
                           let itemName = data[K.FSStore.itemNameField] as? String,
                           let itemCheckMark = data[K.FSStore.checkMarkField] as? Bool,
                           let itemDate = data[K.FSStore.dateField] as? Double {
                            
                            let newListItem = ListItem(id: document.documentID,
                                                       sender: itemSender,
                                                       item: itemName,
                                                       checkmark: itemCheckMark,
                                                       date: itemDate)
                            
                            self.list.append(newListItem)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                //scroll tableView
                                let indexPath = IndexPath(row: self.list.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
    }
}

//MARK: - Cell in TableView
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listItem = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath) as! ListCell
        cell.label.text = listItem.item
        
        if list[indexPath.row].checkmark {
            cell.checkMark.text = "✔️"
        } else {
            cell.checkMark.text = ""
        }
        // this item is from current user
        if listItem.sender == Auth.auth().currentUser?.email {
            cell.bulletPoint.text = "🟢"
            cell.listView.backgroundColor = UIColor(named: K.BrandColor.greenBlue)
            cell.listView.alpha = 0.2
            cell.label.textColor = UIColor(named: K.BrandColor.greenBlue)
        } else {
            cell.bulletPoint.text = "🔵"
            cell.listView.backgroundColor = UIColor(named: K.BrandColor.lightBlue)
            cell.listView.alpha = 1
            cell.label.textColor = UIColor(named: K.BrandColor.blue)
        }
        
        return cell
    }
}

//MARK: - Edit Cell
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if navigationItem.leftBarButtonItem?.title == "Done" {
            
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationItem.leftBarButtonItem?.title == "Done" {
            
            if let cell = tableView.cellForRow(at: indexPath) as? ListCell {
                
                let item = list[indexPath.row] //item that we pressed
                //REVERT CHECKMARK
                if cell.checkMark.text == "" {
                    cell.checkMark.text = "✔️"
                    
                    db.collection(K.FSStore.collectionName)
                        .document(item.id)
                        .setData([
                                    K.FSStore.itemNameField: item.item,
                                    K.FSStore.senderField: item.sender,
                                    K.FSStore.dateField: item.date,
                                    K.FSStore.checkMarkField: true])
                    
                    print("Set true for \(item.item)")
                } else {
                    cell.checkMark.text = ""
                    
                    db.collection(K.FSStore.collectionName)
                        .document(item.id)
                        .setData([
                                    K.FSStore.itemNameField: item.item,
                                    K.FSStore.senderField: item.sender,
                                    K.FSStore.dateField: item.date,
                                    K.FSStore.checkMarkField: false])
                    
                    print("Set false for \(item.item)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = list[indexPath.row] //item that we remove
            
            db.collection(K.FSStore.collectionName).document(item.id).delete() //remove from db
            print("Successfully removed \(item.id): \(item.item) from FireStore.")
            
            list.remove(at: indexPath.row) //revove from list array
            
            tableView.deleteRows(at: [indexPath], with: .fade) //remove from the tableView
        }
    }
}


