//
//  APIHandler.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 15/11/23.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
}

class APIHandler{
    static let sharedInstance = APIHandler()
    
    // Define a function for making an asynchronous GET request
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    // Define a function to decode JSON data
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func performGetRequest() async throws -> [CandidateJS] {
        guard let url = URL(string: apiKey.getURL) else {
            throw NetworkingError.invalidURL
        }
        do {
            let data = try await fetchData(from: url)
            // Decode JSON data and return the decoded object
            return try decodeJSON([CandidateJS].self, from: data)
        } catch {
            throw NetworkingError.requestFailed(error)
        }
    }
    
    func uploadPDF(pdfURL: URL) async throws -> Candidate{
        guard let url = URL(string: apiKey.predictURL) else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.addValue("application/pdf", forHTTPHeaderField: "Content-Type")
        do {
            let pdfData = try Data(contentsOf: pdfURL)
            request.setValue("multipart/form-data; boundary=YOUR_BOUNDARY", forHTTPHeaderField: "Content-Type")
             // Create the body of the request
             let boundary = "YOUR_BOUNDARY"
             var body = Data()
             // Add PDF file data to the request body
             body.append(Data("--\(boundary)\r\n".utf8))
             body.append(Data("Content-Disposition: form-data; name=\"pdf_file\"; filename=\"example.pdf\"\r\n".utf8))
             body.append(Data("Content-Type: application/pdf\r\n\r\n".utf8))
             body.append(contentsOf:pdfData)
             body.append(Data("\r\n".utf8))
             body.append(Data("--\(boundary)--\r\n".utf8))
             // Set the request body
             request.httpBody = body
//            request.httpBody = pdfData
            let (data, _) = try await URLSession.shared.data(for: request)
            return try decodeJSON(Candidate.self, from: data)
        } catch {
            print("Error reading PDF file: \(error)")
            throw NetworkingError.requestFailed(error)
        }
    }
    
    func postJSONData(requestData: CandidateJS) async throws {
        guard let url = URL(string: apiKey.postURL) else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        request.httpBody = try jsonEncoder.encode(requestData)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "")")
        } catch {
            throw NetworkingError.requestFailed(error)
        }
    }
}
