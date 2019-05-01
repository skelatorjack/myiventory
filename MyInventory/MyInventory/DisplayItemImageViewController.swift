//
//  DisplayItemImageViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/30/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import UIKit

class DisplayItemImageViewController: UIViewController {

    @IBOutlet weak var savedImageImageView: UIImageView!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        savedImageImageView.image = image!
        // Do any additional setup after loading the view.
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
