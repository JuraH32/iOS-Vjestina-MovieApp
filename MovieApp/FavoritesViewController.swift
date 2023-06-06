import PureLayout
import Combine

class FavoritesViewController: UIViewController {
    private var router: AppRouter
    
    private var movieList: [MovieModel]! = []
    
    private var favoritesLabel: UILabel!
    private var moviesCollectionView: UICollectionView!
    private var disposables = Set<AnyCancellable>()
    private let reuseIdentifier = "movie"
    private var viewModel: FavoritesViewModel!
    
    init(router: AppRouter, viewModel: FavoritesViewModel) {
        self.router = router
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayoutForViews()
        bindData()
    }
    
    private func bindData() {
        viewModel.$favoriteMovies.sink { [weak self] movies in
            self?.movieList = movies
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }.store(in: &disposables)
    }
    
    private func createViews() {
        favoritesLabel = UILabel()
        view.addSubview(favoritesLabel)
        
        let movieLayout = UICollectionViewFlowLayout()
        movieLayout.scrollDirection = .vertical
        movieLayout.minimumInteritemSpacing = 8
        movieLayout.itemSize = CGSize(width: 114, height: 167)
        
        moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieLayout)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(MovieBannerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(moviesCollectionView)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        favoritesLabel.text = "Favorites"
        favoritesLabel.font = .systemFont(ofSize: 20, weight: .heavy)
    }
    
    private func defineLayoutForViews() {
        favoritesLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 25)
        favoritesLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 18)
        favoritesLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        moviesCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        moviesCollectionView.autoPinEdge(.top, to: .bottom, of: favoritesLabel, withOffset: 16)
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
                        for: indexPath
        ) as? MovieBannerCell else { fatalError() }
        
        let movie = movieList[indexPath.item]
        
        cell.setData(imageUrl: movie.imageUrl, movieId: movie.id, router: router, isFavorite: true) { [weak self] id in
            self?.viewModel.toggleFavoriteMovie(id: id)
        }
        
        return cell
    }
}
