//
//  SignupAgeTableViewController.swift
//  The Umpire
//
//  Created by Branson Boggia on 4/21/17.
//  Copyright © 2017 PineTree Studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignupAgeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var ageList = [String]()
    var selectedAge: String!
    var leagueCode: String!
    var leagueName: String!
    var usrEmail: String!
    var usrPass: String!
    var firstName: String!
    var lastName: String!
    var uid: String!
    var alreadyHaveAccCheck = false
    
    var user: User!
    var userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Auth.auth().currentUser
        userUID = Auth.auth().currentUser?.uid
        
        dataObserver()
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLbl.font = UIFont.boldSystemFont(ofSize: 66)
            titleLbl.frame = CGRect(x: titleLbl.frame.minX, y: titleLbl.frame.minY, width: titleLbl.frame.width, height: titleLbl.frame.height * 2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataObserver() {
        Refs().dataRef.child(self.leagueCode).child("LeagueName").observeSingleEvent(of: .value, with: { (snapshot) in
            self.leagueName = snapshot.value as! String?
            self.populateView()
        })
    }
    
    func populateView() {
        Refs().statRef.child(self.leagueCode).child(self.leagueName).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.ageList.append(snap.key)
                print(self.ageList)
                print(snap.key)
                self.teamTableView.reloadData()
            }
        })
    }
    
    func displayMyAlertMessage(title:String, userMessage:String) {
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            action in
            
            if self.alreadyHaveAccCheck == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "coachTeamSelect") as! SignupTeamSelectViewController
                vc.division = self.selectedAge
                vc.leagueCode = self.leagueCode
                vc.leagueName = self.leagueName
                vc.alreadyHaveAccCheck = true
                self.navigationController?.pushViewController(vc,animated: true)
                
            } else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "coachTeamSelect") as! SignupTeamSelectViewController
                vc.division = self.selectedAge
                vc.usrEmail = self.usrEmail
                vc.usrPass = self.usrPass
                vc.leagueCode = self.leagueCode
                vc.leagueName = self.leagueName
                vc.firstName = self.firstName
                vc.lastName = self.lastName
                self.navigationController?.pushViewController(vc,animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ageList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = ageList[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = teamTableView.indexPathForSelectedRow
        let currentCell = teamTableView.cellForRow(at: indexPath!) as UITableViewCell?
        selectedAge = currentCell?.textLabel?.text
        
        displayMyAlertMessage(title: "Confirm", userMessage: "You selected \(selectedAge!), is this correct?")
    }
}
