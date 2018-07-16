//
//  Request.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation

//
//  Request
//  WordSearchGame
//
//  Created by floatingpoint on 7/2/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//
// File URL:

import Foundation

/// Request a file from an asynchronous source which is Decodable into a Model.
protocol Request: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

/// Extension for loading a Request using HTTP
extension Request {
    /// Request the file at url and return the decoded Model in the completion.
    ///
    /// - Parameters:
    ///   - url: The url that the resource exists at.
    ///   - completion: Callback which receives the decoded Model if successful. nil is returned if the resource could not be downloaded or could not be decoded.
    fileprivate func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (Model?) -> Void) {
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
    
    func load(withCompletion completion: @escaping (ChainInfo?) -> Void) {
        var urlRequest = URLRequest(url: url)
        load(urlRequest, withCompletion: completion)
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
        print(String(data: data, encoding: .utf8))

        let decoded = try?JSONDecoder().decode(BlockInfo.self, from: data)
        return decoded
    }
    
    func load(withCompletion completion: @escaping (BlockInfo?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let json: [String: Any] = ["block_num_or_id": blockId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        load(urlRequest, withCompletion: completion)
    }
}
