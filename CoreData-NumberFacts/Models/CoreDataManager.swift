//
//  CoreDataManager.swift
//  CoreData-NumberFacts
//
//  Created by Eric Davenport on 4/9/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
  
  // implement singleton
  static let shared = CoreDataManager()
  private init() {}
  
  private var users = [User]()  // User in NSManagementObject
  
  private var posts = [Post]()  // Post is NSManagementObject
  
  // access to persistence container in the App Delegae
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  // viewContext is of type NSManagedObjectContext - refer to diagram in lecture
  
  // CRUD = []Create []Read []Update []Delete
  
  public func createUser(name: String, dob: Date) -> User {
    // create instance of user
    let user = User(entity: User.entity(), insertInto: context)
    user.name = name
    user.dob = dob
    
//    ==============================================================================
//     save changes to the NSManagedObjectContext
//    ==============================================================================
    // persistence - saving data
    // persistence we've used so far : user defaults, documents directory, firebase, code data, (iCloud)
    // similar to saving file manager
    
    do {
      try context.save()  // NSManagedObjectContext
    } catch {
      print("error saving user: \(error)")
    }
    return user
  }
  
  public func fetchUsers() -> [User] {
    do {
      users = try context.fetch(User.fetchRequest())  // fetch request gets all the oibjects from core data
      // Extra Notes: we can use (NSPredicate) to sort and filter core data objects during fetch
      // fetchRequest() is type NSFetchRequest
    } catch {
      print("Fetching users error: \(error)")
    }
    return users
  }
  
  public func createPost(for user: User, numberFact: Double, title: String) -> Post {
    // create a post instance
    let post = Post(entity: Post.entity(), insertInto: context)
    
    // set the post properties
    post.number = numberFact
    post.title = title
    
    // create relationship between post and user
    post.user = user      // this property created when ctrl+drag core date model - when creating relationship
    
    // saving post to the NSManagedObjectContext (Core Data)
    do {
      try context.save()
    } catch {
    print("save post error: \(error)")      // throwing function
    }
    return post
  }
  
  @discardableResult // silences the (warnings) if return value is not used
  public func deletePost(_ post: Post) -> Bool {
    var wasDeleted = false
    context.delete(post)
    
    // save context
    do {
      try context.save()
      wasDeleted = true
    } catch {
      print("failed to delete post with error: \(error)")
    }
    return wasDeleted
  }
  
  public func fetchPosts() -> [Post] {
    do {
      posts = try context.fetch(Post.fetchRequest())  // all the [Post]
    } catch {
      print("Fetching post error: \(error)")
    }
    return posts
  }
  
  
  
  
}
