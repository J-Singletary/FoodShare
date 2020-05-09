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
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    private var offers = [Offer]()
    
    private var requests = [Request]()
        
    private var postCollectionRef: CollectionReference!
    
    private var requestCollectionRef: CollectionReference!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        
        setupViews()
        
        postCollectionRef = Firestore.firestore().collection("Post(Offer)")
        requestCollectionRef = Firestore.firestore().collection("Post(Request)")
        
        loadOffers()
        
        myRefreshControl.addTarget(self, action: #selector(loadOffers), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    func setupViews() {
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 9
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlValueChanged), for: .valueChanged)
        
    }
    
    @objc func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //Load the offer posts
            loadOffers()
            myRefreshControl.addTarget(self, action: #selector(loadOffers), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
            break
        case 1:
            //load the request posts
            loadRequests()
            myRefreshControl.addTarget(self, action: #selector(loadRequests), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
            break
        case 2:
            //load my posts
            loadMyPosts()
            myRefreshControl.addTarget(self, action: #selector(loadMyPosts), for: .valueChanged)
            //Don't refresh other things anymore
            myRefreshControl.removeTarget(self, action: #selector(loadRequests), for: .valueChanged)
            myRefreshControl.removeTarget(self, action: #selector(loadOffers), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
            break
        default:
            //load the offer posts
            loadOffers()
            myRefreshControl.addTarget(self, action: #selector(loadOffers), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
            break
        }
        tableView.reloadData()
    }
    
    @objc func loadOffers() {
        
        postCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            } else {
                guard let snap = snapshot else { return }
                self.offers.removeAll()
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
                        if error != nil {
                            print("Error loading image")
                        } else {
                            let img = UIImage(data: imageData!)!
                            //create a new post and add it to array
                            let newPost = Offer(name: first, photo: img, description: descriptionText, food: type)
                            self.offers.append(newPost)
                            print("added offer post")
                            //reload data
                            self.tableView.reloadData()
                            self.myRefreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
    }
    
    @objc func loadRequests() {
        requestCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            } else {
                guard let snap = snapshot else { return }
                self.requests.removeAll()
                for document in snap.documents {
                    
                    //get all the data
                    
                    let data = document.data()
                    let first = data["username"] as? String ?? "Anonymous"
                    let timeStamp = data["dateCreated"] as? Date ?? Date()
                    let descriptionText = data["description"] as? String ?? "Failed description"
                    let type = data["foodName"] as? String ?? "Failed type"
                    
                    let newPost = Request(name: first, description: descriptionText, food: type)
                    self.requests.append(newPost)
                    print("added request post")
                    //reload data
                    self.tableView.reloadData()
                    self.myRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc func loadMyPosts() {
        self.requests.removeAll()
        self.offers.removeAll()
        
        //get my requests
        requestCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    
                    //get all the data
                    
                    let data = document.data()
                    let first = data["username"] as? String ?? "Anonymous"
                    let timeStamp = data["dateCreated"] as? Date ?? Date()
                    let descriptionText = data["description"] as? String ?? "Failed description"
                    let type = data["foodName"] as? String ?? "Failed type"
                    let uid = data["uid"] as? String ?? "Failed"
                    
                    if (uid == Auth.auth().currentUser?.uid) {
                        //add their post to requests array
                        let newPost = Request(name: first, description: descriptionText, food: type)
                        self.requests.append(newPost)
                        print("added my request post")
                        //reload data
                        self.tableView.reloadData()
                        self.myRefreshControl.endRefreshing()
                    }
                }
            }
        }
        
        //get my offers
        postCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            } else {
                guard let snap = snapshot else { return }
                self.offers.removeAll()
                for document in snap.documents {
                    
                    //get all the data
                    let data = document.data()
                    let first = data["username"] as? String ?? "Anonymous"
                    let timeStamp = data["dateCreated"] as? Date ?? Date()
                    let descriptionText = data["description"] as? String ?? "Failed description"
                    let type = data["foodName"] as? String ?? "Failed type"
                    let uid = data["uid"] as? String ?? "Failed"
                    
                    if (uid == Auth.auth().currentUser?.uid) {
                        
                        //get photo
                        let photoId = data["photoId"] as? String
                        let photoRef = Storage.storage().reference().child(photoId!)
                        photoRef.getData(maxSize: 1*1024*1024*100) { (imageData, error) in
                            
                            let img = UIImage(data: imageData!)!
                            //create a new post and add it to offers array
                            let newPost = Offer(name: first, photo: img, description: descriptionText, food: type)
                            self.offers.append(newPost)
                            print("added my offer post")
                            //reload data
                            self.tableView.reloadData()
                            self.myRefreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return requests.count
        }
        else {
            return offers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath) as? OfferCell {
                
                cell.configureCell(post: offers[indexPath.row])
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.blue.cgColor //set border color
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
        else if segmentedControl.selectedSegmentIndex == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as? RequestCell {
                cell.configureCell(post: requests[indexPath.row])
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.green.cgColor //set border color
                return cell
            } else {
                return UITableViewCell()
            }
        }
            
        else if segmentedControl.selectedSegmentIndex == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyOfferCell", for: indexPath) as? MyOfferCell {
                cell.configureCell(post: offers[indexPath.row])
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.purple.cgColor
                return cell
            } else {
                return UITableViewCell()
            }
        }
            
        else {
            return UITableViewCell()
        }
    }
    
    

}
