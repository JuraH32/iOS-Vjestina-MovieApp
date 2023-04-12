//
//  MovieCell.swift
//  MovieApp
//
//  Created by endava-bootcamp on 04.04.2023..
//

import UIKit
import PureLayout

class MovieWithSummaryCell: UICollectionViewCell {
    var movieNameLabel: UILabel!
    var movieImage: UIImageView!
    var summaryLabel: UILabel!
    
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
    
    public func setData(imageUrl: String, name: String, summary: String) {
        movieNameLabel.text = name
        Task {
            await loadImage(imageURL: imageUrl, imageView: movieImage)
        }
        summaryLabel.text = summary
    }
    
    private func assignViews() {
        movieNameLabel = UILabel()
        contentView.addSubview(movieNameLabel)
        
        movieImage = UIImageView()
        contentView.addSubview(movieImage)
        
        summaryLabel = UILabel()
        contentView.addSubview(summaryLabel)
        
    }
    
    private func style() {
        self.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
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
