//
//  ProductsViewController.swift
//  Product Hunt
//
//  Created by Yash Nayak on 19/04/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // Creaing reference for passing Date into datePassed from the Filter View Controller
    var datePassed : String = ""
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var productsTableView: UITableView!
    
    var products : [Product] = []
    {
        didSet{
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Activity Indicator
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
         // Adding Activity Indicator to backgroung of products TableView
        productsTableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
         // Start Activity Indicator
        activityIndicatorView.startAnimating()
        
        // Hiding table cell separator while loading
        self.productsTableView.separatorColor = UIColor.clear
        
        // Cheking if the Date Passed from FilterView Controller is empty
        // If empty it will show today's post
        // else it will filter post according to date passed
        if(datePassed == "")
        {
            Networking.shared.fetch(route: .post) { (data) in
                let producthunt = try? JSONDecoder().decode(Producthunt.self, from: data)
                guard let newPosts = producthunt?.posts else{return}
                self.products = newPosts
                DispatchQueue.main.async {
                    self.productsTableView.separatorColor = UIColor.gray
                    self.productsTableView.reloadData()
                    
                }
            }
        }
        else
        {
            // Passing selected date from filterViewController to Networking file for featching post according to date passed
            Networking.shared.fetch(route: .datefilter(selectedDatePass: datePassed)) { (data) in
                let producthunt = try? JSONDecoder().decode(Producthunt.self, from: data)
                guard let newPosts = producthunt?.posts else{return}
                self.products = newPosts
                DispatchQueue.main.async {
                    self.productsTableView.separatorColor = UIColor.gray
                    self.productsTableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProductsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        //print(products)
        
        if product.name != nil {
            // Printing Name and TagLine to Text Lable
            cell.textLabel?.text = product.name
            cell.detailTextLabel?.text = product.tagline
            
            // Getting the image
            if let profileImageURL = product.imageURL {
                
                if product.imageURL != "image"
                {
                    DispatchQueue.main.async {
                        
                        cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
                        cell.imageView?.layer.borderWidth = 1
                        cell.imageView?.layer.masksToBounds = false
                        cell.imageView?.layer.borderColor = UIColor.black.cgColor
                        cell.imageView?.clipsToBounds = true
                    }
                }
            }
            
        }
        // Printing Default Image if fails to fetch image
        if product.imageURL == "image"
        {
            DispatchQueue.main.async {
                
                cell.imageView?.image = UIImage(named: "image.jpg")
            }
        }
        
        // Return
        return cell
        
    }
}

extension ProductsViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let postID = product.postID
        
        // Instantiate CommentsTableViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let commentsTableVC = storyboard.instantiateViewController(withIdentifier: "CommentsTableViewController") as! CommentsTableViewController
        
        // Send "POST_ID" as a value to postID to CommentsTableViewController
        commentsTableVC.postID = postID
        
        // Take user to CommentsTableViewController
        navigationController?.pushViewController(commentsTableVC, animated: true)
        
    }
}
