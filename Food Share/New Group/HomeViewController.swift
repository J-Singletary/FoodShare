//
//  HomeViewController.swift
//  Food Share
//
//  Created by user170197 on 4/17/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    private var posts = [Post]()
    
    private var postCollectionRef: CollectionReference!
    
    private var usersCollectionRef: CollectionReference!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        
        postCollectionRef = Firestore.firestore().collection("Post(Offer)")
        
        loadPosts()
        
        myRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadPosts() {
        
        postCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            } else {
                guard let snap = snapshot else { return }
                self.posts.removeAll()
                for document in snap.documents {
                    
                    //get all the data
                    
                    let data = document.data()
                    let first = data["username"] as? String ?? "Anonymous"
                    let timeStamp = data["dateCreated"] as? Date ?? Date()
                    let descriptionText = data["description"] as? String ?? "Failed description"
                    let type = data["foodName"] as? String ?? "Failed type"
                    
                    //get photo
                    
                    let photoId = data["photoId"] as? String
                    let photoRef = Storage.storage().reference().child(photoId!)
                    photoRef.getData(maxSize: 1*1024*1024*100) { (imageData, error) in
                        let img = UIImage(data: imageData!)!
                        
                        //create a new post and add it to array
                        
                        let newPost = Post(name: first, photo: img, description: descriptionText, food: type)
                        self.posts.append(newPost)
                        print("added post")
                        //reload data
                        self.tableView.reloadData()
                        self.myRefreshControl.endRefreshing()
                        
                    }
                    
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath) as? OfferCell {
            
            cell.configureCell(post: posts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    

    
    
    

}
