//
//  MovieCell.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout

class MovieWithSummaryCell: UICollectionViewCell {
    private var movieNameLabel: UILabel!
    private var movieImage: UIImageView!
    private var summaryLabel: UILabel!
    private var cellButton: UIButton!
    private var movieId: Int!
    private var router: AppRouter!
    
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
    
    func setData(imageUrl: String, name: String, summary: String, movieId: Int, router: AppRouter) {
        movieNameLabel.text = name
        self.movieId = movieId
        self.router = router
        Task {
            await loadImage(imageURL: imageUrl, imageView: movieImage)
        }
        summaryLabel.text = summary
    }
    
    private func assignViews() {
        cellButton = UIButton()
        cellButton.addTarget(self, action: #selector(handleCellButton), for: .touchUpInside)
        contentView.addSubview(cellButton)
        
        movieNameLabel = UILabel()
        cellButton.addSubview(movieNameLabel)
        
        movieImage = UIImageView()
        cellButton.addSubview(movieImage)
        
        summaryLabel = UILabel()
        cellButton.addSubview(summaryLabel)
        
    }
    
    private func style() {
        backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        movieImage.contentMode = .scaleAspectFill
                
        movieNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        movieNameLabel.clipsToBounds = true
        movieNameLabel.lineBreakMode = .byTruncatingTail
        
        summaryLabel.font = UIFont.systemFont(ofSize: 14)
        summaryLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        summaryLabel.numberOfLines = 5
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryLabel.clipsToBounds = true
        
    }
    
    private func layout() {
        movieImage.autoPinEdge(toSuperviewEdge: .top)
        movieImage.autoPinEdge(toSuperviewEdge: .leading)
        movieImage.autoPinEdge(toSuperviewEdge: .bottom)
        movieImage.autoSetDimension(.width, toSize: 97)
        
        movieNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        movieNameLabel.autoPinEdge(.leading, to: .trailing, of: movieImage, withOffset: 16)
        movieNameLabel.autoSetDimension(.height, toSize: 20)
        movieNameLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        summaryLabel.autoPinEdge(.top, to: .bottom, of: movieNameLabel, withOffset: 8)
        summaryLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        summaryLabel.autoPinEdge(.leading, to: .trailing, of: movieImage, withOffset: 16)
        
        cellButton.autoPinEdgesToSuperviewEdges()
    }
    
    func loadImage(imageURL: String, imageView: UIImageView) async {
        guard let url = URL(string: imageURL) else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
    
    @objc func handleCellButton() {
        router.openMovieDetail(movieId: movieId)
    }
}
