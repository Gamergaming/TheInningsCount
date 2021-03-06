//
//  AdminTableViewController.swift
//  The Umpire
//
//  Created by Branson Boggia on 4/17/17.
//  Copyright © 2017 PineTree Studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AdminTableViewController: UITableViewController {
    
    var user: User!
    var userUID: String!
    var ref : DatabaseReference?
    
    var tablePath: DatabaseReference!
    var convertedArray = [String]()
    var league: String!
    var ageGroup: String!
    var selectedCell: String!
    var alertTextField: String!
    var theSnapshot: DataSnapshot!
    var randNum: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        user = Auth.auth().currentUser
        userUID = Auth.auth().currentUser?.uid
        
        ref?.child("UserData").child(userUID!).child("League").observeSingleEvent(of: .value, with: { (snapshot) in
            self.league = snapshot.childSnapshot(forPath: "Name").value as! String!
            self.randNum = snapshot.childSnapshot(forPath: "RandomNumber").value as! String!
            self.dataObserver()
        })
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataObserver() {
        
        self.tablePath = self.ref?.child("LeagueStats").child(self.randNum).child(self.league)
        
        tablePath.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.convertedArray.append(snap.key)
                self.tableView.reloadData()
            }
            print(self.convertedArray)
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return convertedArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = convertedArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = convertedArray[indexPath.row]
        
        let myAlert = UIAlertController(title: "Rename Age Group", message: "Enter the new name for the age group selected.", preferredStyle: UIAlertControllerStyle.alert)
        
        myAlert.addTextField()
        
        let okAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { action in
            self.alertTextField = myAlert.textFields![0].text
            
            self.tablePath.observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tablePath.child(self.alertTextField).setValue(snapshot.childSnapshot(forPath: self.selectedCell).value)
                self.tablePath.child(self.selectedCell).removeValue()
            })
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }

}
