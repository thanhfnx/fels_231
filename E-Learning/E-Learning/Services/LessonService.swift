//
//  LessonService.swift
//  E-Learning
//
//  Created by Huy Pham on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

enum CategoryRequestError: Error {
    case outOfCategories
}

enum UpdateLessonError: Error {
    case errorUpdateLesson
}

enum CategoryRequestResult {
    case success([Category])
    case failure(Error)
}

enum LessonRequestResult {
    case success(Lesson)
    case failure(Error)
}

class LessonService: APIService {
    
    private let session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func fetchCategories(withInfo info: [String: Any],
        completion: @escaping (CategoryRequestResult) -> Void) {
        if let page = info["page"] as? Int {
            if page <= Category.currentPage {
                completion(.success(DataStore.shared.categories))
                return
            }
        }
        var infoDict = info
        infoDict["auth_token"] = DataStore.shared.loggedInUser?.auth_token ?? ""
        guard let request = makeURLRequest(urlString: kGetCategoriesURL,
            parameters: infoDict, method: .get) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            OperationQueue.main.addOperation {
                completion(self.processCategoriesRequest(data: data, error: error))
            }
        }
        task.resume()
    }
    
    func createLesson(categoryId: Int, completion: @escaping (LessonRequestResult) -> Void) {
        let urlString = String(format: kCreateLessonURL, categoryId)
        let infoDict = ["auth_token": DataStore.shared.loggedInUser?.auth_token ?? ""]
        guard let request = makeURLRequest(urlString: urlString, parameters: infoDict,
            method: .post) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            OperationQueue.main.addOperation {
                completion(self.processLessonRequest(data: data, error: error))
            }
        }
        task.resume()
    }
    
    func updateLesson(lessonId: Int, info: [String: Any],
        completion: @escaping (LessonRequestResult) -> Void) {
        let urlString = String(format: kUpdateLessonURL, lessonId)
        var infoDict = info
        infoDict["auth_token"] = DataStore.shared.loggedInUser?.auth_token ?? ""
        guard let request = makeURLRequest(urlString: urlString, parameters: infoDict,
            method: .patch) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            OperationQueue.main.addOperation {
                completion(self.processLessonRequest(data: data, error: error))
            }
        }
        task.resume()
    }
    
    private func processCategoriesRequest(data: Data?, error: Error?) -> CategoryRequestResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
                options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let categories = jsonDictionary["categories"] as? [[String:Any]],
                let totalPages = jsonDictionary["total_pages"] as? Int
                else {
                return .failure(APIServiceError.errorParseJSON)
            }
            Category.totalPages = totalPages
            var finalCategories = [Category]()
            for categoriesDictionary in categories {
                let category = Category(dictionary: categoriesDictionary)
                if DataStore.shared.categories.index(of: category) == nil {
                    DataStore.shared.categories.append(category)
                    finalCategories.append(category)
                }
            }
            if finalCategories.isEmpty && !categories.isEmpty {
                return .failure(APIServiceError.errorParseJSON)
            } else if finalCategories.isEmpty {
                return .failure(CategoryRequestError.outOfCategories)
            }
            return .success(finalCategories)
        } catch {
            return .failure(error)
        }
    }
    
    private func processLessonRequest(data: Data?, error: Error?) -> LessonRequestResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
                options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let lessonDictionary = jsonDictionary["lesson"] as? [String:Any]
                else {
                return .failure(APIServiceError.errorParseJSON)
            }
            return .success(Lesson(dictionary: lessonDictionary))
        } catch {
            return .failure(error)
        }
    }
}
