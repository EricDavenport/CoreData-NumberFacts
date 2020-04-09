//
//  CreateUserViewController.swift
//  CoreData-NumberFacts
//
//  Created by Eric Davenport on 4/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

// 1 - custom protocol
protocol CreateUserDelegate: AnyObject {
  func didCreateUser(_ createUserViewController: CreateUserViewController, user: User)
}

class CreateUserViewController: UITableViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  // 2 - custom protocol
  weak var delegate: CreateUserDelegate?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // set a maximum date of today
    datePicker.maximumDate = Date()

    }
  
  @IBAction func submitButtonPressed(_ sender: UIButton) {
    guard let usernameText = usernameTextField.text,
      !usernameText.isEmpty else {
        print("missing user name")
        return
    }
    
    let date = datePicker.date
    
    // create user
    let user = CoreDataManager.shared.createUser(name: usernameText, dob: date)
    
    //call delegate method
    delegate?.didCreateUser(self, user: user)
    // UserViewController will now have access to the created user and get a delegation notification about the new user
    
    dismiss(animated: true)
    print("\(user), \(date)")
    
  }
  

}
