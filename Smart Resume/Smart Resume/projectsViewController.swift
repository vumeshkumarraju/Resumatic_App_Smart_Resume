//
//  projectsViewController.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import UIKit

class projectsViewController: UIViewController {

    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var projectText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBgView.setUpView()
        self.view.applyGradient()
        self.projectText.text = projectDetails
        // Do any additional setup after loading the view.
    }
    

    var projectDetails = ""
}
