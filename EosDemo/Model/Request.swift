//
//  Request.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation

let networkUrl = URL(string: "https://api.eosnewyork.io/v1/chain")!

/// Task returned by a Request object.
protocol RequestTask {
    /// Cancels the task.
    func cancel()
}

class URLSessionRequestTask : RequestTask {
    let task: URLSessionDataTask
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    func cancel() {
        task.cancel()
    }
}

/// Request a file from an asynchronous source which is Decodable into a Model.
protocol Request: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void) -> RequestTask
    func decode(_ data: Data) -> Model?
}

/// Extension for loading a Request using HTTP
extension Request {
    /// Request the file at url and return the decoded Model in the completion.
    ///
    /// - Parameters:
    ///   - url: The url that the resource exists at.
    ///   - completion: Callback which receives the decoded Model if successful. nil is returned if the resource could not be downloaded or could not be decoded.
    fileprivate func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (Model?) -> Void) -> RequestTask {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        })
        task.resume()
        return URLSessionRequestTask(task: task)
    }
}

/// Used to request info about the chain including the head block
class ChainInfoRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ChainInfoRequest: Request {
    func decode(_ data: Data) -> ChainInfo? {
        let decoded = try?JSONDecoder().decode(ChainInfo.self, from: data)
        return decoded
    }
    
    func load(withCompletion completion: @escaping (ChainInfo?) -> Void) -> RequestTask {
        let urlRequest = URLRequest(url: url)
        return load(urlRequest, withCompletion: completion)
    }
}

/// Used to request info about the chain including the head block
class BlockInfoRequest {
    let url: URL
    let blockId: String
    
    init(url: URL, blockId: String) {
        self.url = url
        self.blockId = blockId
    }
}

extension BlockInfoRequest: Request {
    func decode(_ data: Data) -> BlockInfo? {
        let decoded = try?JSONDecoder().decode(BlockInfo.self, from: data)
        return decoded
    }
    
    func load(withCompletion completion: @escaping (BlockInfo?) -> Void) -> RequestTask {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["block_num_or_id": blockId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        
        return load(urlRequest, withCompletion: completion)
    }
}

/// Used to request info about an abi.
class AbiInfoRequest {
    let url: URL
    let accountName: String
    
    init(url: URL, accountName: String) {
        self.url = url
        self.accountName = accountName
    }
}

extension AbiInfoRequest: Request {
    func decode(_ data: Data) -> AbiInfo? {
        let decoded = try?JSONDecoder().decode(AbiInfo.self, from: data)
        return decoded
    }
    
    func load(withCompletion completion: @escaping (AbiInfo?) -> Void) -> RequestTask {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["account_name": accountName]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        return load(urlRequest, withCompletion: completion)
    }
}
