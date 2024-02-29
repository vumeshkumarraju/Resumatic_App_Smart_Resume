//
//  candidateProfileViewController.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import UIKit
import MessageUI

class candidateProfileViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var candiadateImage: UIImageView!
    @IBOutlet weak var candidateName: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailbutton: UIButton!
    
    @IBOutlet weak var topBgView: UIView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var degreeName: UILabel!
    @IBOutlet weak var graduationYear: UILabel!
    @IBOutlet weak var collegeName: UILabel!
    
    @IBOutlet weak var viewSkitllButton: UIButton!
    @IBOutlet weak var viewProjectsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBgView.setUpView()
        self.view.applyGradient()
        self.candiadateImage.layer.cornerRadius = (self.candiadateImage.frame.width / 2)
        self.callButton.layer.cornerRadius = 10
        self.emailbutton.layer.cornerRadius = 10
        self.infoView.layer.cornerRadius = 12
        self.viewSkitllButton.layer.cornerRadius = 12
        self.viewProjectsButton.layer.cornerRadius = 12
        
        self.candidateName.text = candidateDetail.candidateName
        self.graduationYear.text = candidateDetail.graduationYear
        self.collegeName.text = candidateDetail.collegeName
        self.degreeName.text = candidateDetail.degree
        
        if isFirstTime{
            self.saveButton.isHidden = false
        }else{
            self.saveButton.isHidden = true
        }
        activityView = UIActivityIndicatorView(style: .large)
        self.view.setActivityView(activityView: activityView!)
        
    }
    
    var activityView: UIActivityIndicatorView?
    var candidateDetail : Candidate = Candidate()
    var isFirstTime: Bool = false
    
    @IBAction func callBtnPressed(_ sender: Any) {
        self.callToPhone(phNo: candidateDetail.candidatePhone)
    }
    
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        self.sendEmail(reciever: candidateDetail.candidateEmail)
    }
    
    
    @IBAction func skillsButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "skillsViewController") as! skillsViewController
        vc.skills = candidateDetail.skills
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func projectsButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "projectsViewController") as! projectsViewController
        vc.title = "Projects"
        vc.projectDetails = candidateDetail.projects
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        Task {
            do {
                self.view.showActivityIndicatory(activityView: activityView!)
                var cjs = CandidateJS()
                cjs.id = "\(Int64(Date().timeIntervalSince1970))"
                cjs.candidateDetail = self.candidateDetail
                try await APIHandler.sharedInstance.postJSONData(requestData: cjs)
                self.view.hideActivityIndicator(activityView: activityView!)
                let alert = UIAlertController(title: "Sucessfull Added", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Error:", error)
                self.view.hideActivityIndicator(activityView: activityView!)
                self.showPopUp(title: "TRY AGAIN LATER", message: "Please check the resume pdf .")
            }
        }
    }
    
    func sendEmail(reciever:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([reciever])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            self.showPopUp(title: "Try Again Later", message: "")
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


}
