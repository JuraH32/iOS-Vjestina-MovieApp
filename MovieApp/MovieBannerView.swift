//
//  MovieBannerView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 28.03.2023..
//

import UIKit
import PureLayout
import MovieAppData

class MovieBannerView: UIView {
    let scoreLabel = UILabel()
    let userScoreLabel = UILabel()
    let movieNameLabel = UILabel()
    let dateLabel = UILabel()
    let categories = UILabel()
    let starButton = UIButton()
    var backgroundImage = UIImageView()
    var categoriesString = ""
    
    let starButtonSize = 32.0
    
    var details: MovieDetailsModel?
    
    
    init(details: MovieDetailsModel?) {
        self.details = details
        super.init(frame: .zero)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        self.details = nil
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        assignViews()
        style()
        layout()
    }
    
    private func assignViews() {
        guard let details else {return}
        Task {
            await loadImage(imageURL: details.imageUrl, imageView: backgroundImage)
        }
        self.addSubview(scoreLabel)
        scoreLabel.text = String(details.rating)
        
        self.addSubview(userScoreLabel)
        userScoreLabel.text = "User score"
        
        self.addSubview(movieNameLabel)
        
        self.addSubview(dateLabel)
        
        let dateString = details.releaseDate
        let dateFormatterOriginal = DateFormatter()
        dateFormatterOriginal.dateFormat = "yyyy-MM-dd"
        let dateFormatterNew = DateFormatter()
        dateFormatterNew.dateFormat = "MM/dd/yyyy"
        let date = dateFormatterOriginal.date(from: dateString)
        if date != nil {
            dateLabel.text = dateFormatterNew.string(from: date!)
        }
        
        self.addSubview(categories)
        let cat = [MovieCategoryModel.action, MovieCategoryModel.adventure, MovieCategoryModel.drama, MovieCategoryModel.scienceFiction]
        categoriesString = cat
            .map {(category: MovieCategoryModel) -> String in return capitalSplitString(string: String(describing: category)).capitalized}
            .joined(separator: ", ")
        
        self.addSubview(starButton)
        self.addSubview(backgroundImage)
        self.sendSubviewToBack(backgroundImage)
        
    }
    
    private func capitalSplitString(string: String) -> String{
        let splitString  = string.reduce("") { (acc, cur) in
            if (cur.isUppercase) {
                return acc + " " + String(cur.lowercased())
            } else {
                return acc + String(cur)
            }
        }
        return splitString
    }
    
    private func style() {
        guard let details else {return}
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        userScoreLabel.textColor = .white
        userScoreLabel.font = UIFont.systemFont(ofSize: 14)
        
        let movieName = NSMutableAttributedString(string: details.name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)])
        movieName.append(NSMutableAttributedString(string: String(format: " (%d)", details.year), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]))
        movieNameLabel.textColor = .white
        movieNameLabel.attributedText = movieName
        
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        let categoriesText = NSMutableAttributedString(string: categoriesString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        categoriesText.append(NSMutableAttributedString(string: String(format: " %dh %dm", details.duration / 60, details.duration % 60), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        categories.attributedText = categoriesText
        categories.textColor = .white
        
        let starImage = UIImage(systemName: "star")
        starButton.setImage(starImage, for: .normal)
        starButton.imageView?.alpha = 1
        starButton.tintColor = .white
        starButton.alpha = 0.6
        starButton.layer.backgroundColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1).cgColor
        starButton.layer.cornerRadius = starButtonSize / 2
    }
    
    private func layout() {
        backgroundImage.autoPinEdgesToSuperviewEdges()
        backgroundImage.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        
        scoreLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 134)
        scoreLabel.autoSetDimension(.height, toSize: 19)
        scoreLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        userScoreLabel.autoPinEdge(.leading, to: .trailing, of: scoreLabel, withOffset: 8)
        userScoreLabel.autoAlignAxis(.horizontal, toSameAxisOf: scoreLabel)
        
        movieNameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        movieNameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        movieNameLabel.autoPinEdge(.top, to: .bottom, of: scoreLabel, withOffset: 16)
        movieNameLabel.autoSetDimension(.width, toSize: self.frame.size.width - 40)
        movieNameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        movieNameLabel.numberOfLines = 0
        movieNameLabel.lineBreakMode = .byWordWrapping
        
        dateLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        dateLabel.autoPinEdge(.top, to: .bottom, of: movieNameLabel, withOffset: 16)
        dateLabel.autoSetDimension(.height, toSize: 20)
        
        categories.autoPinEdge(.top, to: .bottom, of: dateLabel)
        categories.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        categories.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        categories.numberOfLines = 1
        categories.lineBreakMode = .byWordWrapping
        
        starButton.autoPinEdge(.top, to: .bottom, of: categories, withOffset: 16)
        starButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        starButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        starButton.autoSetDimension(.width, toSize: starButtonSize)
        starButton.autoSetDimension(.height, toSize: starButtonSize)
    }
    
    func loadImage (imageURL: String, imageView: UIImageView) async {
        do {
            let url = URL(string: imageURL)
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            backgroundImage.image = image
        } catch {
            return
        }
    }
}
