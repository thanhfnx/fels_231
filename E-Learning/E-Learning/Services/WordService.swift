//
//  WordService.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/16/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

enum WordRequestResult {
    case success([Word])
    case failure(Error)
}

class WordService: APIService {
    
    static let shared = WordService()
    private let session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func fetchWordsList(perPage: Int, option: String, categoryId: String,
        completion: @escaping (WordRequestResult) -> Void) {
        let params = ["page": "1", "per_page": "\(perPage)", "category_id": categoryId,
            "option": option, "auth_token": DataStore.shared.loggedInUser?.auth_token ?? ""]
        guard let request = makeURLRequest(urlString: kGetWordsURL,
            parameters: params, method: .get) else {
            completion(.failure(APIServiceError.errorCreateURLRequest))
            return
        }
        let task = session.dataTask(with: request) {
            (data, response, error) in
            OperationQueue.main.addOperation {
                completion(self.processWordsRequest(data: data, error: error))
            }
        }
        task.resume()
    }
    
    private func processWordsRequest(data: Data?, error: Error?) -> WordRequestResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
                options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let words = jsonDictionary["words"] as? [[String: Any]]
                else {
                    return .failure(APIServiceError.errorParseJSON)
            }
            var finalWords = [Word]()
            for wordsDictionary in words {
                let word = Word(dictionary: wordsDictionary)
                finalWords.append(word)
            }
            if finalWords.isEmpty && !words.isEmpty {
                return .failure(APIServiceError.errorParseJSON)
            }
            return .success(finalWords)
        } catch {
            return .failure(error)
        }
    }
    
}
