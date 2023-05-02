//
//  MovieListiViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout
import MovieAppData

class MovieCategoryListViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var categoryStack: UIStackView!
    private var popularList: [MovieModel]!
    private var popularCollection: MovieCategoryCollectionView!
    private var freeList: [MovieModel]!
    private var freeCollection: MovieCategoryCollectionView!
    private var trendingList: [MovieModel]!
    private var trendingCollection: MovieCategoryCollectionView!
    private let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        createViews()
        styleViews()
        defineLayoutForViews()
        
    }
    
    private func getData() {
        let useCase = MovieUseCase()
        popularList = useCase.popularMovies
        freeList = useCase.freeToWatchMovies
        trendingList = useCase.trendingMovies
    }
    
    private func createViews() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        categoryStack = UIStackView()
        contentView.addSubview(categoryStack)
        
        popularCollection = MovieCategoryCollectionView(category: "What's popular", moviesList: popularList)
        categoryStack.addArrangedSubview(popularCollection)
        
        freeCollection = MovieCategoryCollectionView(category: "Free to Watch", moviesList: freeList)
        categoryStack.addArrangedSubview(freeCollection)
        
        trendingCollection = MovieCategoryCollectionView(category: "Trending", moviesList: trendingList)
        categoryStack.addArrangedSubview(trendingCollection)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        categoryStack.axis = .vertical
        categoryStack.alignment = .fill
        categoryStack.distribution = .fillEqually
        categoryStack.spacing = 40
    }
    
    private func defineLayoutForViews() {
        categoryStack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        categoryStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        categoryStack.autoPinEdge(toSuperviewSafeArea: .top, withInset: 27)
        categoryStack.autoPinEdge(toSuperviewEdge: .bottom)
        
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: view)
        
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.contentSize = contentView.frame.size
    }
}
