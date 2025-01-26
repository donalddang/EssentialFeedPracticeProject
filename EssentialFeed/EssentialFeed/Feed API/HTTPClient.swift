//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/18/25.
//

import Foundation
//this is only has dependency on foundation stuff, which makes it domain specific. This is good!
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
