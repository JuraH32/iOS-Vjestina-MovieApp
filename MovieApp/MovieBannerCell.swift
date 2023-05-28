//
//  MovieCell.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout

class MovieBannerCell: UICollectionViewCell {
    private var movieButton: UIButton!
    private var movieImage: UIImageView!
    private var heartButton: UIButton!
    private var heartImageView: UIImageView!
    private var router: AppRouter!
    private var movieId: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        assignViews()
        style()
        layout()
    }
    
    func setData(imageUrl: String, movieId: Int, router: AppRouter) {
        self.movieId = movieId
        self.router = router
        Task {
            await loadImage(imageURL: imageUrl, imageView: movieImage)
        }
    }
    
    private func assignViews() {
        movieButton = UIButton()
        movieButton.addTarget(self, action: #selector(handleMovieButton), for: .touchUpInside)
        addSubview(movieButton)
        
        movieImage = UIImageView()
        movieButton.addSubview(movieImage)
        sendSubviewToBack(movieImage)
        
        heartButton = UIButton()
        movieButton.addSubview(heartButton)
        
        heartImageView = UIImageView()
        heartButton.addSubview(heartImageView)
    }
    
    private func style() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        
        let heartImage = UIImage(systemName: "heart")
        heartImageView.image = heartImage
        heartImageView.tintColor = .white
        heartButton.alpha = 0.6
        heartButton.backgroundColor = .black
        heartButton.layer.cornerRadius = 16
    }
    
    private func layout() {
        movieButton.autoPinEdgesToSuperviewEdges()
        
        movieImage.autoPinEdgesToSuperviewEdges()
        
        heartButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 8)
        heartButton.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        heartButton.autoSetDimension(.width, toSize: 32)
        heartButton.autoSetDimension(.height, toSize: 32)
        
        heartImageView.autoCenterInSuperview()
        
    }
    
    func loadImage (imageURL: String, imageView: UIImageView) async {
        do {
            let url = URL(string: imageURL)
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            imageView.image = image
        } catch {
            return
        }
    }
    
    @objc func handleMovieButton() {
        router.openMovieDetail(movieId: movieId)
    }
}
