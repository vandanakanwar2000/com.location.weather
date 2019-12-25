//
//  Service.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
import UIKit

/// Service Error Types.
enum ServiceError: Error {
    /// General error with message.
    case general(messsage: String)
}

/// Result type.
enum Result<T> {
    /// success.
    case success(T)

    /// failure.
    case failure(Error)
}

// MARK: - Types

/// Type for dictionary.
typealias JSON = [String: Any]

/// Service result.
typealias ServiceResult = Result<JSON>

/// Service callback.
typealias ServiceCallback = (ServiceResult) -> Void

/// Base service class
///
/// Implements common functionality for all service classess.
class Service {
    func submitRequest(with url: URL, completion: @escaping ServiceCallback) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                            DispatchQueue.main.async {
                                completion(.success(json))
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }

    func downloadImage(url: URL, contentMode _: UIView.ContentMode = .scaleAspectFit, completion: @escaping (UIImage?) -> Void?) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
