//
//  Router.swift
//  MovieApp
//
//  Created by endava-bootcamp on 09.05.2023..
//

import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
}
class AppRouter: AppRouterProtocol {
    private weak var tabBarController: UITabBarController?
    private var alternateNavigationController: UINavigationController?
    private var isAlternate = false
    private var movieDataSource: MovieDataSource!
    private var favoritesViewModel: FavoritesViewModel!
    
    init(tabBarController: UITabBarController, movieDataSource: MovieDataSource) {
        self.tabBarController = tabBarController
        self.movieDataSource = movieDataSource
    }
    
    func setStartScreen(in window: UIWindow?) {
        favoritesViewModel = FavoritesViewModel(movieDataSource: movieDataSource)
        let favoritesViewController = FavoritesViewController(router: self, viewModel: favoritesViewModel)
        let favoritesNavigation = UINavigationController(rootViewController: favoritesViewController)
        
        let movieCategoryViewListModel = MovieCategoryListViewModel(movieDataSource: movieDataSource)
        let movieCategoryViewListController = MovieCategoryListViewController(router: self, viewModel: movieCategoryViewListModel, favoritesViewModel: favoritesViewModel)
        let movieCategoryNavigation = UINavigationController(rootViewController: movieCategoryViewListController)
        
        movieCategoryNavigation.tabBarItem = UITabBarItem(title: "Movie list", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        favoritesNavigation.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        tabBarController?.viewControllers = [movieCategoryNavigation, favoritesNavigation]
        tabBarController?.tabBar.tintColor = .black
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
    
    func setAlternateScreen(in window: UIWindow?) {
        isAlternate = true
        let movieListViewController = MovieListViewController(router: self)
        alternateNavigationController = UINavigationController(rootViewController: movieListViewController)
        
        window?.rootViewController = alternateNavigationController
        window?.makeKeyAndVisible()
    }
    
    func openMovieDetail(movieId: Int) {
        let movieDetailsViewModel = MovieDetailsViewModel(movieDataSource: movieDataSource, id: movieId, favoritesViewModel: favoritesViewModel)
        let movieDetailsViewController = MovieDetailsViewController(movieId: movieId, viewModel: movieDetailsViewModel)
        movieDetailsViewController.title = "Movie Details"
        if let selectedNavigationController = tabBarController?.selectedViewController as? UINavigationController {
            selectedNavigationController.pushViewController(movieDetailsViewController, animated: true)
        }
        if (isAlternate) {
            alternateNavigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
    
}
