//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/18/25.
//

import Foundation

public protocol HTTPClient {
    //this is only has dependency on foundation stuff, which makes it domain specific. This is good!
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
