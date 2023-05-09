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
    private var moviesCollectionView: UICollectionView!
    private var moviesList: [MovieModel] = []
    private var router: AppRouter
    private var screenTitle: UILabel!
    private let reuseIdentifier = "cell"
    
    init (router: AppRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let useCase = MovieUseCase()
        moviesList = useCase.allMovies
        createViews()
        styleViews()
        defineLayoutForViews()
        
    }
    
    private func createViews() {
        screenTitle = UILabel()
        navigationItem.titleView = screenTitle
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
        screenTitle.text = "Movie List"
    }
    
    private func defineLayoutForViews() {
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        moviesCollectionView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
                        for: indexPath
        ) as? MovieWithSummaryCell else { fatalError() }
        
        let movie = moviesList[indexPath.item]
        
        cell.setData(imageUrl: movie.imageUrl, name: movie.name, summary: movie.summary, movieId: movie.id, router: router)
        
        
        return cell
    }
}
