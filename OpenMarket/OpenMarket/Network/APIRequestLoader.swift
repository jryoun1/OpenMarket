//
//  APIRequestLoader.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

final class APIRequestLoader<T: APIRequest> {
    let apiRequest: T
    let urlSession: URLSession
    
    init(apiReqeust: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiReqeust
        self.urlSession = urlSession
    }
    
    func loadAPIReqeust(requestData: T.RequestDataType,
                        completion: @escaping (T.ResponseDataType?, OpenMarketError?) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let _ = error {
                    return completion(nil, .failToNetworkCommunication)
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 400 {
                            return completion(nil, .badRequest)
                        }
                        else if httpResponse.statusCode == 404 {
                            return completion(nil, .notFound)
                        }
                    }
                    return
                }
                
                guard let data = data else {
                    return completion(nil, .failUnwrappingData)
                }
                
                do {
                    let parseResponse = try self.apiRequest.parseResponse(data: data)
                    completion(parseResponse, nil)
                } catch {
                    completion(nil, .failDecodeData)
                }
            }.resume()
        } catch {
            return completion(nil, .failToMakeURLRequest)
        }
    }
}
