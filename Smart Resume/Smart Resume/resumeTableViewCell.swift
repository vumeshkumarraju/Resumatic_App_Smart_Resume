//
//  resumeTableViewCell.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import UIKit

class resumeTableViewCell: UITableViewCell {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        emailButton.layer.cornerRadius = 8
        callButton.layer.cornerRadius = 8
        studentImage.layer.cornerRadius = (studentImage.frame.width / 2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var callBtnTapped:(() -> Void)?
    var mailBtnTapped:(() -> Void)?
    
    @IBAction func callButtonPressed(_ sender: Any) {
        self.callBtnTapped!()
    }
    
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        self.mailBtnTapped!()
    }
}
