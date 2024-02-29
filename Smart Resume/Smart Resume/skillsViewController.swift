//
//  skillsViewController.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import UIKit

class skillsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topBgView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.topBgView.setUpView()
        self.view.applyGradient()
        
    }
    
    var skills:[String] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillsTableViewCell", for: indexPath) as! skillsTableViewCell
        cell.skillLabel.text = skills[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
