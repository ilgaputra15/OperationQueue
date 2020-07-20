//
//  Movie.swift
//  My List Movie
//
//  Created by ilga yulian putra on 20/07/20.
//  Copyright © 2020 ilga yulian putra. All rights reserved.
//

import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class Movie {
    let title: String
    let poster: URL
    
    var image: UIImage?
    var state: DownloadState = .new
    
    
    init(title: String, poster: URL) {
        self.title = title
        self.poster = poster
    }
    
}
