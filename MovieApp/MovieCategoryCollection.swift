//
//  MovieCategoryCollection.swift
//  MovieApp
//
//  Created by endava-bootcamp on 05.04.2023..
//

import UIKit
import PureLayout
import MovieAppData

class MovieCategoryCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var movieCategoryLabel: UILabel!
    var moviesList: [MovieModel]!
    var moviesCategoryCollectionView: UICollectionView!
    var categoryName: String!
    let reuseIdentifier = "cell"
    
    init(category: String, moviesList: [MovieModel]) {
        self.categoryName = category
        self.moviesList = moviesList
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
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieBannerCell
        
        let movie = moviesList[indexPath.item]
        
        cell.setData(imageUrl: movie.imageUrl)
        
        return cell
    }
}
