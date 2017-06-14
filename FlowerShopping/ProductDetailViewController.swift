//
//  ProductDetailViewController.swift
//  FlowerShopping
//
//  Created by DUONG PHAM on 5/16/17.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit
import Moltin

class ProductDetailViewController: UIViewController {
    
    var productDict:NSDictionary?
    
    @IBOutlet weak var descriptionTextView:UITextView?
    @IBOutlet weak var productImageView:UIImageView?
    @IBOutlet weak var buyButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton?.backgroundColor = MOLTIN_COLOR
        
        // Do any additional setup after loading the view.
        if let description = productDict!.value(forKey: "description") as? String {
            self.descriptionTextView?.text = description
            
        }
        
        if let price = productDict!.value(forKeyPath: "price.data.formatted.with_tax") as? String {
            let buyButtonTitle = String(format: "Mua ngay (%@)", price)
            self.buyButton?.setTitle(buyButtonTitle, for: UIControlState())
        }
        
        var imageUrl = ""
        
        if let images = productDict!.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = (images.firstObject as! NSDictionary).value(forKeyPath: "url.https") as! String
            }
            
        }
        
        productImageView?.sd_setImage(with: URL(string: imageUrl))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyProduct(_ sender: AnyObject) {
        // Add the current product to the cart
        let productId:String = productDict!.object(forKey: "id") as! String
        
        SwiftSpinner.show("cập nhật giỏ hàng")
        
        Moltin.sharedInstance().cart.insertItem(withId: productId, quantity: 1, andModifiersOrNil: nil, success: { (response) -> Void in
            // Done.
            // Switch to cart...
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToCartTab()
            
            // and hide loading UI
            SwiftSpinner.hide()
            
            
        }) { (response, error) -> Void in
            // Something went wrong.
            // Hide loading UI and display an error to the user.
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't add product to the cart", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
    }
    
    
    
}
