//
//  MovieCell.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout

class MovieBannerCell: UICollectionViewCell {
    var movieImage: UIImageView!
    var heartButton: UIButton!
    var heartImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        assignViews()
        style()
        layout()
    }
    
    public func setData(imageUrl: String) {
        Task {
            await loadImage(imageURL: imageUrl, imageView: movieImage)
        }
    }
    
    private func assignViews() {
        
        movieImage = UIImageView()
        self.addSubview(movieImage)
        self.sendSubviewToBack(movieImage)
        
        heartButton = UIButton()
        self.addSubview(heartButton)
        
        heartImageView = UIImageView()
        heartButton.addSubview(heartImageView)
    }
    
    private func style() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
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
}
