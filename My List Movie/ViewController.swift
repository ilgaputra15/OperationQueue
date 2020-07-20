//
//  ViewController.swift
//  My List Movie
//
//  Created by ilga yulian putra on 20/07/20.
//  Copyright © 2020 ilga yulian putra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let _pendingOperations = PendingOperations()
    private var movies = MovieRepository().movies
    
    @IBOutlet weak var tableViewMovie: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMovie.dataSource = self
        tableViewMovie.delegate = self
        tableViewMovie.rowHeight = 150
        tableViewMovie.register(UITableViewCell.self, forCellReuseIdentifier: "movie-cell")
    }
    
    fileprivate func startOperations(index: IndexPath, movie: Movie) {
        if movie.state == .new {
            startDownload(movie: movie, index: index)
        }
    }
    
    fileprivate func startDownload(movie: Movie, index: IndexPath) {
        guard _pendingOperations.downloadInProgress[index] == nil else { return }
        let donwloader = ImageDownloader(movie: movie)
        donwloader.completionBlock = {
            if donwloader.isCancelled {return}
            DispatchQueue.main.async {
                self._pendingOperations.downloadInProgress.removeValue(forKey: index)
                self.tableViewMovie.reloadRows(at: [index], with: .automatic)
            }
        }
        
        _pendingOperations.downloadInProgress[index] = donwloader
        _pendingOperations.downloadQueue.addOperation(donwloader)
    }
    
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
        _pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie-cell", for: indexPath)
        let movie = movies[indexPath.row]

        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = movie.title
        cell.imageView?.image = movie.image

        if cell.accessoryView == nil {
           cell.accessoryView = UIActivityIndicatorView(style: .medium)
        }

        guard let indicator = cell.accessoryView as? UIActivityIndicatorView else { fatalError() }

        if movie.state == .new {
           indicator.startAnimating()
           if !tableView.isDragging && !tableView.isDecelerating {
            startOperations(index: indexPath, movie: movie)
               
           }
        } else {
           indicator.stopAnimating()
        }
        return cell
    }
}

