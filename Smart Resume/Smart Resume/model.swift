//
//  model.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 13/11/23.
//

import Foundation

class Candidate:Codable{
    var candidateEmail :String = "akankshaHotta@gmail.com"
    var candidateName : String = "Akanksha Hotta"
    var degree: String = "Integrated MTech Software Engineering"
    var collegeName : String = "VIT Vellore"
    var skills : [String] = ["Web Dev"]
    var candidatePhone : String = "8144030193"
    var graduationYear : String = "2025"
    var projects : String = "Smart Resume"
}

class CandidateJS:Codable{
    var id : String = "1001"
    var candidateDetail : Candidate = Candidate()
}
