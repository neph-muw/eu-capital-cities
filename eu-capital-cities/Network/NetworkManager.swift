//
//  NetworkManager.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 21/08/2020.
//

import Foundation

class NetworkManager: NSObject, URLSessionDelegate {
    
    // MARK: Configuration
    
    enum Configuration {
        static let serverUrl: String =  "https://gist.githubusercontent.com/nostradupus/cd6d64ae2387b0b8a9ce7161f6fd8419/raw/edb2d2f02eb3e963bc15203a8ea002a8477ea59d/european-cities.json"
        
    }
    
    // MARK: Variables
    
    var session: URLSession!
    var tasks: Array<URLSessionTask> = []
    
    // MARK: Life cycle
    
    override init() {
        super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    func networkRequest(url: URL, withBody data: Data?, andHeaders headers: [String : String]?, completion: @escaping (_ output: Data?, _ response: URLResponse?, _ error: Error?) throws -> Void) {
        let task = session.dataTask(with: url) { (data, response, error) in
            try? completion(data, response, error)
        }
        task.resume()
    }
}
