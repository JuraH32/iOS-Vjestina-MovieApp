//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 28.03.2023..
//

import UIKit
import PureLayout
import MovieAppData

class MovieDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var movieBannerView: MovieBannerView!
    var details: MovieDetailsModel?
    var overviewLabel: UILabel!
    var summary: UILabel!
    var roleCollectionView: UICollectionView!
    var crewList: [MovieCrewMemberModel]!
    let reuseIdentifier = "cell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        movieBannerView = MovieBannerView(details: details)
        view.addSubview(movieBannerView)
        
        overviewLabel = UILabel()
        overviewLabel.text = "Overview"
        view.addSubview(overviewLabel)
        
        summary = UILabel()
        summary.text = details!.summary
        view.addSubview(summary)

        let roleLayout = UICollectionViewFlowLayout()
        roleLayout.scrollDirection = .vertical
        roleLayout.minimumInteritemSpacing = 10
        roleLayout.itemSize = CGSize(width: 110, height: 40)
        roleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: roleLayout)
        roleCollectionView.dataSource = self
        roleCollectionView.delegate = self
        roleCollectionView.register(CrewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(roleCollectionView)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        overviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        summary.font = UIFont.systemFont(ofSize: 14)
        summary.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        summary.numberOfLines = 0
        summary.lineBreakMode = .byWordWrapping
        
        roleCollectionView.backgroundColor = .white
    }
    
    private func defineLayoutForViews() {
        movieBannerView.autoPinEdge(toSuperviewEdge: .top)
        movieBannerView.autoMatch(.width, to: .width, of: view)
        
        overviewLabel.autoPinEdge(.top, to: .bottom, of: movieBannerView, withOffset: 22)
        overviewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        overviewLabel.autoSetDimension(.height, toSize: 31)
        
        summary.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: 8)
        summary.autoMatch(.width, to: .width, of: view, withOffset: -32)
        summary.autoAlignAxis(toSuperviewAxis: .vertical)
        
        roleCollectionView.autoPinEdge(.top, to: .bottom, of: summary, withOffset: 27)
        roleCollectionView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        roleCollectionView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        roleCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    private func getDetails() {
        details = MovieUseCase().getDetails(id: 111161)
        crewList = details!.crewMembers
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        crewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = roleCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CrewCollectionViewCell
        
        let crewMember = crewList[indexPath.item]
        
        cell.setText(name: crewMember.name, role: crewMember.role)
        
        return cell
    }
}
