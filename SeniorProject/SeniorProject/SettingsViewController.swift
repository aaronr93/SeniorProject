//
//  SettingsViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var userImage: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImage.image = UIImage(named: "...") // placeholder image
        //userImage.file = someObject.picture // remote image
        
        userImage.loadInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
