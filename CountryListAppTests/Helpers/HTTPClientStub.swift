//
//  HTTPClientStub.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import Foundation
@testable import CountryListApp

class HTTPCLientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPCLientStub {
    static var offline: HTTPCLientStub {
        HTTPCLientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0))})
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) ->  HTTPCLientStub {
        HTTPCLientStub { url in
                .success(stub(url))
        }
    }
}
