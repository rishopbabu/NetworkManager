// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  NetworkManager.swift
//
//
//  Created by Rishop Babu on 26/06/24.
//

import Foundation

public enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unknown
}

public class NetworkManager {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func sendRequest<T: Decodable>(request: NetworkRequest,
                                          responseType: T.Type,
                                          completion: @escaping (Result<T, NetworkError>) -> Void) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                completion(.failure(.decodingFailed(decodingError)))
            }
        }
        
        task.resume()
    }
}

