//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 28.03.2023..
//

import UIKit
import PureLayout
import MovieAppData
import Combine

class MovieDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var movieBannerView: MovieBannerView!
    private var details: MovieDetailsModel?
    private var overviewLabel: UILabel!
    private var summary: UILabel!
    private var roleCollectionView: UICollectionView!
    private var crewList: [MovieCrewMemberModel]!
    private var movieId: Int!
    private var screenTitle: UILabel!
    private var viewModel: MovieDetailsViewModel
    private var disposable = Set<AnyCancellable>()
    
    private var summaryCenterConstrain: NSLayoutConstraint!
    private var rolesCenterConstrain: NSLayoutConstraint!
    
    let reuseIdentifier = "cell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(movieId: Int, viewModel: MovieDetailsViewModel) {
        self.movieId = movieId
        self.viewModel = viewModel
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
    
    private func createViews() {
        screenTitle = UILabel()
        navigationItem.titleView = screenTitle
        
        movieBannerView = MovieBannerView()
        view.addSubview(movieBannerView)
        
        overviewLabel = UILabel()
        overviewLabel.text = "Overview"
        view.addSubview(overviewLabel)
        
        summary = UILabel()
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
        
        screenTitle.text = "Movie Details"
        
        overviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        summary.font = UIFont.systemFont(ofSize: 14)
        summary.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        summary.numberOfLines = 0
        summary.lineBreakMode = .byWordWrapping
        
        roleCollectionView.backgroundColor = .white
    }
    
    private func defineLayoutForViews() {
        movieBannerView.autoPinEdge(toSuperviewSafeArea: .top)
        movieBannerView.autoMatch(.width, to: .width, of: view)
        
        overviewLabel.autoPinEdge(.top, to: .bottom, of: movieBannerView, withOffset: 22)
        overviewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        overviewLabel.autoSetDimension(.height, toSize: 31)
        
        summary.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: 8)
        summary.autoMatch(.width, to: .width, of: view, withOffset: -32)
        summary.autoAlignAxis(toSuperviewAxis: .vertical)
        
        roleCollectionView.autoPinEdge(.top, to: .bottom, of: summary, withOffset: 27)
        roleCollectionView.autoMatch(.width, to: .width, of: view, withOffset: -32)
        roleCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        roleCollectionView.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    private func bindData() {
        viewModel.$movieDetails.sink { [weak self] movie in
            self?.details = movie
            self!.movieBannerView.updateDetails(details: self!.details)
        }.store(in: &disposable)
        guard let details else { return }
        crewList = details.crewMembers
        summary.text = details.summary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        summary.transform = summary.transform.translatedBy(x: -view.frame.width, y: 0)
        roleCollectionView.transform = roleCollectionView.transform.translatedBy(x: -view.frame.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.summary.transform = .identity
        })
        UIView.animate(
            withDuration: 0.3,
            delay: 0.2,
            animations: {
                self.roleCollectionView.transform = .identity
        })
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
