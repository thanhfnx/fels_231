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

enum ImageRequestError: Error {
    case errorGettingImageURL
    case errorGettingCategoryId
    case errorCreatingImage
}

enum CategoryRequestResult {
    case success([Category])
    case failure(Error)
}

enum LessonRequestResult {
    case success(Lesson)
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

class LessonService: APIService {
    
    static let shared = LessonService()
    private let session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func fetchCategories(page: Int, perPage: Int, update: Bool,
        completion: @escaping (CategoryRequestResult) -> Void) {
        Category.perPage = perPage
        if !update {
            if page <= Category.currentPage {
                completion(.success(DataStore.shared.categories))
                return
            }
        }
        let infoDict = ["page": "\(page)", "per_page": "\(perPage)",
            "auth_token": DataStore.shared.loggedInUser?.auth_token ?? ""]
        guard let request = makeURLRequest(urlString: kGetCategoriesURL,
            parameters: infoDict, method: .get) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            OperationQueue.main.addOperation {
                completion(self.processCategoriesRequest(data: data,
                    update: update, error: error))
            }
        }
        task.resume()
    }
    
    func createLesson(categoryId: Int,
        completion: @escaping (LessonRequestResult) -> Void) {
        let urlString = String(format: kCreateLessonURL, categoryId)
        let infoDict =
            ["auth_token": DataStore.shared.loggedInUser?.auth_token ?? ""]
        guard let request = makeURLRequest(urlString: urlString,
            parameters: infoDict, method: .post) else {
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
    
    func updateLesson(lessonId: Int, lessonResult: [String: Any],
        completion: @escaping (LessonRequestResult) -> Void) {
        let urlString = String(format: kUpdateLessonURL, lessonId)
        var infoDict = lessonResult
        infoDict["auth_token"] = DataStore.shared.loggedInUser?.auth_token ?? ""
        guard let request = makeURLRequest(urlString: urlString,
            parameters: infoDict, method: .patch) else {
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
    
    func fetchImage(for category: Category,
        completion: @escaping (ImageResult) -> Void) {
        guard let categoryId = category.id else {
            completion(.failure(ImageRequestError.errorGettingCategoryId))
            return
        }
        let photoKey = "category\(categoryId)"
        if let image = ImageStore.shared.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        guard let photoURLString = category.photoURL,
            let photoURL = URL(string: photoURLString) else {
            completion(.failure(ImageRequestError.errorGettingImageURL))
            return
        }
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                ImageStore.shared.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processCategoriesRequest(data: Data?, update: Bool,
        error: Error?) -> CategoryRequestResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
                options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let categories = jsonDictionary["categories"]
                    as? [[String:Any]],
                let totalPages = jsonDictionary["total_pages"] as? Int
                else {
                return .failure(APIServiceError.errorParseJSON)
            }
            Category.totalPages = totalPages
            var finalCategories = [Category]()
            if update {
                DataStore.shared.categories.removeAll()
            }
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
    
    private func processLessonRequest(data: Data?,
        error: Error?) -> LessonRequestResult {
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
    
    private func processImageRequest(data: Data?,
        error: Error?) -> ImageResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil, let error = error {
                    return .failure(error)
                } else {
                    return .failure(ImageRequestError.errorCreatingImage)
                }
        }
        return .success(image)
    }
    
}
