//
//  ViewController.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 28/10/23.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController,UIDocumentPickerDelegate {

    @IBOutlet weak var viewResumes: UIButton!
    @IBOutlet weak var uploadResumeButton: UIButton!
    @IBOutlet weak var topBgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBgView.setUpView()
        self.viewResumes.layer.cornerRadius = 12
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        activityView = UIActivityIndicatorView(style: .large)
        self.view.setActivityView(activityView: activityView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.applyGradient()
    }
    @IBAction func uploadButtonTapped(_ sender: Any) {
        pickDoucumentFromFile(title: "hello", no: 1)
    }
    var activityView: UIActivityIndicatorView?
    var titleDoc:String = ""
    var DocNo:Int = 0
}
extension ViewController{
    func pickDoucumentFromFile(title:String,no:Int){
        self.titleDoc = title
        self.DocNo = no
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            self.titleDoc = ""
            self.DocNo = 0
            self.showPopUp(title: "Try Again !!!", message: "Your \(self.titleDoc) is Not Uploaded")
            return
        }
        Task {
            do {
                self.view.showActivityIndicatory(activityView: activityView!)
                let decodedObject = try await APIHandler.sharedInstance.uploadPDF(pdfURL: selectedFileURL)
                self.view.hideActivityIndicator(activityView: activityView!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "candidateProfileViewController") as! candidateProfileViewController
                vc.isFirstTime = true
                vc.candidateDetail = decodedObject
                self.navigationController?.pushViewController(vc, animated: true)
            } catch {
                self.view.hideActivityIndicator(activityView: activityView!)
                print("Error:", error)
                self.showPopUp(title: "TRY AGAIN LATER", message: "Please check the resume pdf .")
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.titleDoc = ""
        self.DocNo = 0
        controller.dismiss(animated: true)
    }
    
}
