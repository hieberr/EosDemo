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
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
        load(url, withCompletion: completion)
    }
}
