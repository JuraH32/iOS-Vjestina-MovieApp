//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 09.05.2023..
//

import Foundation

class FavoritesViewController: ViewController {
    private var router: AppRouter
    
    init(router: AppRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {}
    
    private func styleViews() {
        view.backgroundColor = .white
    }
    
    private func defineLayoutForViews() {}
}
