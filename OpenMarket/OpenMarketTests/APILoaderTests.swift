//
//  APILoaderTests.swift
//  OpenMarketTests
//
//  Created by Yeon on 2021/08/04.
//

import XCTest
@testable import OpenMarket

final class APILoaderTests: XCTestCase {
    var loader: APIRequestLoader<GetItemAPIRequest>!
    
    override func setUpWithError() throws {
        let request = GetItemAPIRequest()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        loader = APIRequestLoader(apiReqeust: request, urlSession: urlSession)
    }
    
    func testLoaderSuccess() {
        let inputID = 3
        let mockJSONData = """
        {
            "id": 3,
            "title": "Mac mini",
            "price": 890000,
            "currency": "KRW",
            "stock": 90,
            "discounted_price": 89000,
            "thumbnails": [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3-1.png"
            ],
            "registration_date": 1611523563.7245178
        }
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.path.contains("3"), true)
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        loader.loadAPIReqeust(requestData: inputID) { item, error in
            XCTAssertEqual(item?.id, 3)
            XCTAssertEqual(item?.title, "Mac mini")
            XCTAssertEqual(item?.discountedPrice, 89000)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    override func tearDownWithError() throws {
        loader = nil
    }
}

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected reqeust with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}
