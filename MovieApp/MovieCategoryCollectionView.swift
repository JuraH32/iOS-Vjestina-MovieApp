//
//  MovieCategoryCollection.swift
//  MovieApp
//
//  Created by endava-bootcamp on 05.04.2023..
//

import UIKit
import PureLayout

class MovieCategoryCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var movieCategoryLabel: UILabel!
    private var moviesList: [MovieModel]!
    private var moviesCategoryCollectionView: UICollectionView!
    private var categoryName: String!
    private var router: AppRouter!
    private let reuseIdentifier = "cell"
    
    init(category: String, moviesList: [MovieModel], router: AppRouter) {
        self.categoryName = category
        self.moviesList = moviesList
        self.router = router
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.categoryName = ""
        self.moviesList = []
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        assignViews()
        style()
        layout()
    }
    
    private func assignViews() {
        movieCategoryLabel = UILabel()
        movieCategoryLabel.text = categoryName
        self.addSubview(movieCategoryLabel)
        
        let movieLayout = UICollectionViewFlowLayout()
        movieLayout.scrollDirection = .horizontal
        movieLayout.minimumInteritemSpacing = 8
        movieLayout.itemSize = CGSize(width: 122, height: 179)
        moviesCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieLayout)
        moviesCategoryCollectionView.dataSource = self
        moviesCategoryCollectionView.delegate = self
        moviesCategoryCollectionView.register(MovieBannerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.addSubview(moviesCategoryCollectionView)
    }
    
    private func style() {
        movieCategoryLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
    }
    
    private func layout() {
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .top)
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .leading)
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        moviesCategoryCollectionView.autoPinEdge(.top, to: .bottom, of: movieCategoryLabel, withOffset: 16)
        moviesCategoryCollectionView.autoSetDimension(.height, toSize: 179)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
                        for: indexPath
        ) as? MovieBannerCell else { fatalError() }
        
        let movie = moviesList[indexPath.item]
        
        cell.setData(imageUrl: movie.imageUrl, movieId: movie.id, router: router)
        
        return cell
    }
    
    func updateMoviesList(movies: [MovieModel]) {
        moviesList = movies
        DispatchQueue.main.async {
            self.moviesCategoryCollectionView.reloadData()
        }
    }
}
