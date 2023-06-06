//
//  MovieListiViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout
import MovieAppData
import Combine

class MovieCategoryListViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var categoryStack: UIStackView!
    private var popularList: [[MovieModel]] = []
    private var popularCollection: MovieCategoryCollectionView!
    private var freeList: [[MovieModel]] = []
    private var freeCollection: MovieCategoryCollectionView!
    private var trendingList: [[MovieModel]] = []
    private var trendingCollection: MovieCategoryCollectionView!
    private var favoritesList: [Int] = []
    private var screenTitle: UILabel!
    private var router: AppRouter!
    private var viewModel: MovieCategoryListViewModel!
    private var favoritesViewModel: FavoritesViewModel!
    private var disposablesFree = Set<AnyCancellable>()
    private var disposablesPopular = Set<AnyCancellable>()
    private var disposablesTrending = Set<AnyCancellable>()
    private var disposablesFavorite = Set<AnyCancellable>()
    private let reuseIdentifier = "cell"
    
    init (router: AppRouter, viewModel: MovieCategoryListViewModel, favoritesViewModel: FavoritesViewModel) {
        self.router = router
        self.viewModel = viewModel
        self.favoritesViewModel = favoritesViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        styleViews()
        defineLayoutForViews()
        bindData()
    }
    
    private func bindData() {
        favoritesViewModel.$favoriteMovies.sink { [weak self] movies in
            let ids = movies.map({$0.id})
            self?.favoritesList = ids
            self?.popularCollection.updateFavoritesList(favorites: ids)
            self?.freeCollection.updateFavoritesList(favorites: ids)
            self?.trendingCollection.updateFavoritesList(favorites: ids)
        }.store(in: &disposablesFavorite)
        
        viewModel.$popularMovies.sink { [weak self] movies in
            self?.popularList = movies
            self?.popularCollection.updateMoviesList(movies: self?.popularList ?? [])
        }.store(in: &disposablesFree)
        
        viewModel.$freeToWatchMovies.sink { [weak self] movies in
            self?.freeList = movies
            self?.freeCollection.updateMoviesList(movies: self?.freeList ?? [])
        }.store(in: &disposablesPopular)
        
        viewModel.$trendingMovies.sink { [weak self] movies in
            self?.trendingList = movies
            self?.trendingCollection.updateMoviesList(movies: self?.trendingList ?? [])
        }.store(in: &disposablesTrending)
    }
    
    private func createViews() {
        screenTitle = UILabel()
        navigationItem.titleView = screenTitle
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        categoryStack = UIStackView()
        contentView.addSubview(categoryStack)
        
        popularCollection = MovieCategoryCollectionView(category: "What's popular", moviesList: popularList, router: router, tags: ["Streaming", "On TV", "For Rent", "In theaters"]) { [weak self] id in
            self?.favoritesViewModel.toggleFavoriteMovie(id: id)
        }
        categoryStack.addArrangedSubview(popularCollection)
        
        freeCollection = MovieCategoryCollectionView(category: "Free to Watch", moviesList: freeList, router: router, tags: ["Movies", "TV"]) { [weak self] id in
            self?.favoritesViewModel.toggleFavoriteMovie(id: id)
        }
        categoryStack.addArrangedSubview(freeCollection)
        
        trendingCollection = MovieCategoryCollectionView(category: "Trending", moviesList: trendingList, router: router, tags: ["Today", "This Week"]) { [weak self] id in
            self?.favoritesViewModel.toggleFavoriteMovie(id: id)
        }
        categoryStack.addArrangedSubview(trendingCollection)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        categoryStack.axis = .vertical
        categoryStack.alignment = .fill
        categoryStack.distribution = .fillEqually
        categoryStack.spacing = 40
        
        screenTitle.text = "Movie List"
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
