//
//  APIService.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIServiceError: Error {
    case errorCreateURLRequest
    case errorParseJSON
}

class APIService {
    
    func makeURLRequest(urlString: String, parameters: [String: Any],
        method: HttpMethod) -> URLRequest? {
        let paramsString = parameters.toHttpFormDataString()
        var request: URLRequest
        switch method {
        case .get:
            guard let url = URL(string: "\(urlString)?\(paramsString)") else {
                return nil
            }
            request = URLRequest(url: url)
        case .post, .patch, .delete:
            guard let url = URL(string: urlString),
                let paramsData = paramsString.data(using: .utf8,
                    allowLossyConversion: true)
                else {
                return nil
            }
            request = URLRequest(url: url)
            request.httpBody = paramsData
        }
        request.addValue("application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        return request
    }
    
    func sendRequest(url: String, method: HttpMethod,
        params: [String: Any], success: @escaping ([String: Any]) -> (),
        failure: @escaping (String) -> ()) {
        var paramsString = ""
        for (key, value) in params {
            paramsString += "&\(key)=\(value)"
        }
        paramsString.remove(at: paramsString.startIndex)
        let request: NSMutableURLRequest
        switch method {
        case .get:
            guard let getURL = URL(string: "\(url)?\(paramsString)") else {
                return
            }
            request = NSMutableURLRequest(url: getURL)
        case .post, .patch, .delete:
            guard let url = URL(string: url) else {
                return
            }
            request = NSMutableURLRequest(url: url)
            request.httpBody = paramsString.data(using: .utf8,
                allowLossyConversion: true)
        }
        if method == .patch {
            request.setValue("multipart/form-data",
                forHTTPHeaderField: "Content-Type")
        }
        request.httpMethod = method.rawValue
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest)
            { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    failure(error.localizedDescription)
                }
                return
            }
            do {
                if let data = data, let dictionary =
                    try JSONSerialization.jsonObject(with: data,
                    options: .mutableContainers) as? [String: Any] {
                    DispatchQueue.main.async {
                        success(dictionary)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        dataTask.resume()
    }
    
}
