//
//  b810DataEntryViewController.swift
//  The Umpire
//
//  Created by Branson Boggia on 1/12/17.
//  Copyright © 2017 PineTree Studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class b810DataEntryViewController: UIViewController, UITextFieldDelegate {
    
    let ref = FIRDatabase.database().reference()
    let mainRef = FIRDatabase.database()
    let user = FIRAuth.auth()?.currentUser
    var userUID = FIRAuth.auth()?.currentUser?.uid as String!
    let dateFormatter = DateFormatter()
    var currentDate = Date()
    
    var teamName:String!
    var leagueName:String!
    var userDate = ""
    var databaseDate = ""
    var age:String!
    
    @IBOutlet weak var playerNumberTextField: UITextField!
    @IBOutlet weak var pitchCountTextField: UITextField!
    @IBOutlet weak var titleField: UILabel!
    
    @IBAction func submit(_ sender: Any) {
        
        sendData()
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNumberTextField.delegate = self
        pitchCountTextField.delegate = self
        
        let teamNameRef = mainRef.reference().child("User Data").child(userUID!)
        teamNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.teamName = snapshot.childSnapshot(forPath: "Team").value as! String!
            self.leagueName = snapshot.childSnapshot(forPath: "League").value as! String!
            
        })
        
        titleField.text = age!
        
        self.navigationController?.title = leagueName
        
        userDate = NSDate().userSafeDate
        databaseDate = NSDate().datebaseSafeDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendData() {
        
        ref.child("LeagueDatabase").child(leagueName).child(age).child(teamName).child("\(self.databaseDate)").setValue("\(userDate) | Player#: \(playerNumberTextField.text!) | Innings: \(pitchCountTextField.text!)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }

}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
    }
}

extension NSDate {
    struct dates {
        static let userSafeDate = DateFormatter(dateFormat: "MM-dd-yy hh:mm a")
        static let databaseSafeDate = DateFormatter(dateFormat: "MM-dd-yy hh:mm:SSS a")
    }
    var userSafeDate: String {
        return dates.userSafeDate.string(from: self as Date)
    }
    var datebaseSafeDate: String {
        return dates.databaseSafeDate.string(from: self as Date)
    }
}
