//
//  PendingOperations.swift
//  My List Movie
//
//  Created by ilga yulian putra on 20/07/20.
//  Copyright © 2020 ilga yulian putra. All rights reserved.
//

import Foundation

class PendingOperations {
    lazy var downloadInProgress: [IndexPath : Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "listMovie"
        queue.maxConcurrentOperationCount = 2
        return  queue
    }()
}
