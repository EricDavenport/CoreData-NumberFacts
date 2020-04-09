//
//  CreatePostViewController.swift
//  CoreData-NumberFacts
//
//  Created by Eric Davenport on 4/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

// 1. creating a custom protocol
protocol CreatePostDelegate : AnyObject {
  func didCreatePost(_ createPostViewController: CreatePostViewController, post: Post)
}

class CreatePostViewController: UITableViewController {
  
  @IBOutlet weak var postTitleTextField: UITextField!
  @IBOutlet weak var numberFactTextFeild: UITextField!
  @IBOutlet weak var pickerView: UIPickerView!
  
  // 2. creating a custonprotocol
  weak var delegate: CreatePostDelegate?
  
  private var users = [User]()
  private var selectedUser : User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePickerView()
    fetchUsers()
  }
  
  private func fetchUsers() {
    users = CoreDataManager.shared.fetchUsers()
  }
  
  private func configurePickerView() {
    pickerView.delegate = self
    pickerView.dataSource = self
  }
  
  @IBAction func submitButtonPressed(_ sender: UIButton) {
    // validating data (check to mmake sure its not empty ansd also a valid Double) (post title and number)
    // selected user
    guard let postTitle = postTitleTextField.text,
      !postTitle.isEmpty,
      let numberFactText = numberFactTextFeild.text,
      !numberFactText.isEmpty,
      let numberFact = Double(numberFactText) else {
        print("missing fileds")
        return
    }
    
    guard let user = selectedUser else {
      print("no user selected")
      return
    }
    
    // create post in core data
    let post = CoreDataManager.shared.createPost(for: user, numberFact: numberFact, title: postTitle)
    
    // call the delegate function
    delegate?.didCreatePost(self, post: post)
    
    dismiss(animated: true)
  }
  
  
  
}

extension CreatePostViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return users.count
  }
}

extension CreatePostViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return users[row].name
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedUser = users[row]
  }
}
