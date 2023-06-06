import UIKit
import PureLayout

class MovieCategoryCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var movieCategoryLabel: UILabel!
    private var moviesList: [[MovieModel]]!
    private var favorites: [Int] = []
    private var toggleFavorite: ToggleFavorite!
    private var moviesCategoryCollectionView: UICollectionView!
    private var categoryName: String!
    private var router: AppRouter!
    private let reuseIdentifier = "cell"
    private var buttonStack: UIStackView!
    private var selected = 0
    
    private var tagButtons: [UILabel] = []
    private var tags: [String]
    
    init(category: String, moviesList: [[MovieModel]], router: AppRouter, tags: [String], toggleFavorite: @escaping ToggleFavorite) {
        self.categoryName = category
        self.moviesList = moviesList
        self.router = router
        self.toggleFavorite = toggleFavorite
        self.tags = tags
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.categoryName = ""
        self.moviesList = []
        self.tags = []
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        assignViews()
        style()
        layout()
    }
    
    private func assignViews() {
        movieCategoryLabel = UILabel()
        movieCategoryLabel.text = categoryName
        self.addSubview(movieCategoryLabel)
        
        let movieLayout = UICollectionViewFlowLayout()
        movieLayout.scrollDirection = .horizontal
        movieLayout.minimumInteritemSpacing = 8
        movieLayout.itemSize = CGSize(width: 122, height: 179)
        moviesCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieLayout)
        moviesCategoryCollectionView.dataSource = self
        moviesCategoryCollectionView.delegate = self
        moviesCategoryCollectionView.register(MovieBannerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.addSubview(moviesCategoryCollectionView)
        
        buttonStack = UIStackView()
        self.addSubview(buttonStack)
        
        for (index, tag) in tags.enumerated() {
            let button = UIButton()
            let buttonView = UILabel()
            buttonView.text = tag
            if index == selected {
                buttonView.font = .boldSystemFont(ofSize: 16)
            } else {
                buttonView.font = .systemFont(ofSize: 16)
                buttonView.textColor = .gray
            }
            button.addSubview(buttonView)
            buttonView.autoAlignAxis(toSuperviewAxis: .vertical)
            buttonView.autoAlignAxis(toSuperviewAxis: .horizontal)
            button.tag = index
            button.addTarget(self, action: #selector(setSelected), for: .touchUpInside)
//            let title = NSAttributedString(string: tag, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//            button.setAttributedTitle(title, for: .normal)
            
            tagButtons.append(buttonView)
            buttonStack.addArrangedSubview(button)
        }
    }
    
    private func style() {
        movieCategoryLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 20
    }
    
    private func layout() {
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .leading)
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .trailing)
        movieCategoryLabel.autoPinEdge(toSuperviewEdge: .top)
        
        buttonStack.autoPinEdge(.top, to: .bottom, of: movieCategoryLabel, withOffset: 8)
        buttonStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        buttonStack.autoPinEdge(toSuperviewEdge: .trailing)
        
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        moviesCategoryCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        moviesCategoryCollectionView.autoPinEdge(.top, to: .bottom, of: buttonStack, withOffset: 16)
        moviesCategoryCollectionView.autoSetDimension(.height, toSize: 179)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
                        for: indexPath
        ) as? MovieBannerCell else { fatalError() }
        
        let movie = moviesList[self.selected][indexPath.item]
        let isFavorite = favorites.contains(where: {$0 == movie.id})
        cell.setData(imageUrl: movie.imageUrl, movieId: movie.id, router: router, isFavorite: isFavorite) { [weak self] id in
            self?.toggleFavorite(id)
        }
        
        return cell
    }
    
    func updateMoviesList(movies: [[MovieModel]]) {
        moviesList = movies
        DispatchQueue.main.async {
            self.moviesCategoryCollectionView.reloadData()
        }
    }
    
    func updateFavoritesList(favorites: [Int]) {
        let oldFavorites = self.favorites
        self.favorites = favorites
        let updatedIndexes = self.indexPathsForUpdatedFavorites(oldFavorites: oldFavorites, newFavorites: favorites)
        
        DispatchQueue.main.async {
            self.moviesCategoryCollectionView.performBatchUpdates({
                self.moviesCategoryCollectionView.reloadItems(at: updatedIndexes)
            }, completion: nil)
        }
    }

    private func indexPathsForUpdatedFavorites(oldFavorites: [Int], newFavorites: [Int]) -> [IndexPath] {
        var updatedIndexes: [IndexPath] = []
        var needUpdate = oldFavorites.filter({
            let id = $0
            return favorites.contains(where: {$0 != id})
        })
        needUpdate.append(contentsOf: favorites.filter({
            let id = $0
            return oldFavorites.contains(where: {$0 != id})
        }))
        for id in needUpdate {
            guard let index = moviesList[selected].firstIndex(where: {$0.id == id}) else { continue }
            let indexPath = IndexPath(item: index, section: 0)
            updatedIndexes.append(indexPath)
        }
        
        return updatedIndexes
    }
    
    @objc func setSelected(sender: UIButton) {
        guard tagButtons.count > 0 else { return }
        let index = sender.tag
        selected = index
        for i in 0...tagButtons.count - 1 {
            if i == index {
                tagButtons[i].font = .boldSystemFont(ofSize: 16)
                tagButtons[i].superview?.addBottomBorder(color: .black, thickness: 2.0)
                tagButtons[i].textColor = .black
            } else {
                tagButtons[i].font = .systemFont(ofSize: 16)
                tagButtons[i].superview?.addBottomBorder(color: .white, thickness: 2.0)
                tagButtons[i].textColor = .gray
            }
        }
        DispatchQueue.main.async {
            self.moviesCategoryCollectionView.reloadData()
        }
    }
}
