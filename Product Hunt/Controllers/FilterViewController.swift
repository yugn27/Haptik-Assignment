//
//  FilterViewController.swift
//  Product Hunt
//
//  Created by Yash Nayak on 21/04/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To Disable Future date in datePicker
        let now = Date(); // Today's System Date
        // Setting maximum date to Today's System Date
        datePicker.maximumDate = now
    }
    
    // Submit Button
    @IBAction func Submit(_ sender: Any) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        
        // Arranging date in yyyy-MM-dd eg.2019-04-21
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        //print(selectedDate)
        
        // Instantiate ProductsViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let ProductsVC = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        
        // Send "selectedDate" as a value to datePassed to ProductsViewController
        ProductsVC.datePassed = selectedDate
        
        // Take user to ProductsViewController
        navigationController?.pushViewController(ProductsVC, animated: true)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
