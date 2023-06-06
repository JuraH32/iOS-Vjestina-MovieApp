//
//  InitialViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 09.05.2023..
//

import UIKit

class InitialViewController: UITabBarController {
    private var router: AppRouter
    init(router: AppRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieCategoryViewListController = MovieCategoryListViewController(router: router)
        let favoritesViewController = FavoritesViewController(router: router)
        
        movieCategoryViewListController.tabBarItem = UITabBarItem(title: "Movie list", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        viewControllers = [movieCategoryViewListController, favoritesViewController]
    }
}
