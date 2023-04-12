//
//  MovieListiViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout
import MovieAppData

class MovieListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var moviesCollectionView: UICollectionView!
    var moviesList: [MovieModel] = []
    let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let useCase = MovieUseCase()
        moviesList = useCase.allMovies
        createViews()
        styleViews()
        defineLayoutForViews()
        
    }
    
    private func createViews() {
        let movieLayout = UICollectionViewFlowLayout()
        movieLayout.scrollDirection = .vertical
        movieLayout.minimumInteritemSpacing = 12
        movieLayout.itemSize = CGSize(width: view.bounds.width - 32, height: 142)
        moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieLayout)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(MovieWithSummaryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(moviesCollectionView)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
    }
    
    private func defineLayoutForViews() {
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        moviesCollectionView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieWithSummaryCell
        
        let movie = moviesList[indexPath.item]
        
        cell.setData(imageUrl: movie.imageUrl, name: movie.name, summary: movie.summary)
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
}
