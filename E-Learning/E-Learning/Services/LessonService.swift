//
//  LessonService.swift
//  E-Learning
//
//  Created by Huy Pham on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

enum CategoryResult {
    case success([Category])
    case failure(Error)
}

enum LessonResult {
    case success([Lesson])
    case failure(Error)
}

class LessonService: APIService {
    
    private let session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func fetchCategories(withInfo info: [String:String],
        completion: @escaping (CategoryResult) -> Void) {
        var infoDict = info
        infoDict["auth_token"] = ""
        guard let request = makeURLRequest(url: kGetCategoriesURL, parameters: infoDict, method: .get) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            completion(self.processCategoriesRequest(data: data, error: error))
        }
        task.resume()
    }
    
    func processCategoriesRequest(data: Data?, error: Error?) -> CategoryResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
            options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let categories = jsonDictionary["categories"] as? [[String:Any]]
                else {
                return .failure(APIServiceError.errorParseJSON)
            }
            var finalCategories = [Category]()
            for categoriesDictionary in categories {
                let category = Category(dictionary: categoriesDictionary)
                finalCategories.append(category)
            }
            if finalCategories.isEmpty && !categories.isEmpty {
                return .failure(APIServiceError.errorParseJSON)
            }
            return .success(finalCategories)
        } catch {
            return .failure(error)
        }
    }
}
