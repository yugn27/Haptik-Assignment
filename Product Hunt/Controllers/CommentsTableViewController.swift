//
//  CommentsTableViewController.swift
//  Product Hunt
//
//  Created by Yash Nayak on 20/04/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    // Creaing reference for passing Post_ID into postID from the Product View Controller
    var postID: Int = 0
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var comments : [Comment] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        prepareSwipe()
        
        //Create Activity Indicator
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        // Adding Activity Indicator to backgroung of products TableView
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        // Start Activity Indicator
        activityIndicatorView.startAnimating()
        
         // Hiding table cell separator while loading
        self.tableView.separatorColor = UIColor.clear
        
        
        // Get the latest comments of the post from the API with the postID
        Networking.shared.fetch(route: .comments(postId: postID)) { (data) in
            let commentsData = try? JSONDecoder().decode(Comments.self, from: data)
            guard let allComments = commentsData?.comments else {return}
            self.comments = allComments
            
            // Showing table cell separator after loading
            self.tableView.separatorColor = UIColor.gray
            
            self.tableView.tableFooterView = UIView()
            
            DispatchQueue.main.async {
                // Stop Activity Indicator
                self.activityIndicatorView.stopAnimating()
                // Hide Activity Indicator
                self.activityIndicatorView.hidesWhenStopped = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareSwipe()
    {
        let swipeFromBottom = UISwipeGestureRecognizer(target: self, action: #selector(CommentsTableViewController.leftSwiping(_:)))
        swipeFromBottom.direction = .right
        view.addGestureRecognizer(swipeFromBottom)
        
    }
    
    @objc func leftSwiping(_ gesture:UIGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let comment = comments[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = comment.body
        
        return cell
    }
}
