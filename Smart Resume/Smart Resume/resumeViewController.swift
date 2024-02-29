//
//  resumeViewController.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import UIKit
import MessageUI


class resumeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.setUpView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        activityView = UIActivityIndicatorView(style: .large)
        self.view.setActivityView(activityView: activityView!)
        self.view.showActivityIndicatory(activityView: activityView!)
        Task {
            do {
                let decodedObject = try await APIHandler.sharedInstance.performGetRequest()
                self.parseCandidateJsonToCandidate(ccs:decodedObject)
                self.view.hideActivityIndicator(activityView: activityView!)
            } catch {
                print("Error:", error)
                self.view.hideActivityIndicator(activityView: activityView!)
                self.showPopUp(title: "Poor Internet Connection", message: "Please Try Again.")
            }
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.applyGradient()
    }
    
    var activityView: UIActivityIndicatorView?
    var candidates : [Candidate] = []
    var searchActive : Bool = false{
        didSet{
            if(searchActive == false){
                self.filteredCandidates = self.candidates
            }
        }
    }
    var filteredCandidates : [Candidate] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCandidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resumeTableViewCell", for: indexPath) as! resumeTableViewCell
        cell.nameLabel.text = filteredCandidates[indexPath.row].candidateName
        
        if filteredCandidates[indexPath.row].candidateEmail == "NA"{
            cell.emailButton.isHidden = true
        }else{
            cell.emailButton.isHidden = false
        }
        
        if filteredCandidates[indexPath.row].candidatePhone == "NA"{
            cell.callButton.isHidden = true
        }else{
            cell.callButton.isHidden = false
        }
        
        cell.callBtnTapped = {
            self.callToPhone(phNo: self.filteredCandidates[indexPath.row].candidatePhone)
        }
        cell.mailBtnTapped = {
            self.sendEmail(reciever: self.filteredCandidates[indexPath.row].candidateEmail)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "candidateProfileViewController") as! candidateProfileViewController
        vc.isFirstTime = false
        vc.candidateDetail = filteredCandidates[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    func parseCandidateJsonToCandidate(ccs:[CandidateJS]){
        var cds : [Candidate] = []
        for i in ccs{
            cds.append(i.candidateDetail)
        }
        self.candidates = cds
        self.filteredCandidates = cds
        self.tableView.reloadData()
    }
    
    
}

//MARK:- Search Bar
extension resumeViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCandidates = candidates.filter({ (getCd:Candidate) -> Bool in
            return (getCd.candidateName.lowercased().contains(searchText.lowercased())) || (getCd.candidateEmail.contains(searchText.lowercased())) || (getCd.degree.contains(searchText.lowercased())) || (getCd.collegeName.contains(searchText.lowercased())) || (getCd.candidatePhone.contains(searchText.lowercased())) || (getCd.skills.contains(searchText.lowercased())) || (getCd.projects.contains(searchText.lowercased()))
        })
        if(searchText.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
}
