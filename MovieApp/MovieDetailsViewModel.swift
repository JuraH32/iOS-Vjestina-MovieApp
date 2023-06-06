import SwiftUI
import MovieAppData

class MovieDetailsViewModel: ObservableObject {
    private let movieDataSource: MovieDataSource
    private let favoritesViewModel: FavoritesViewModel
    private let id: Int
    
    @Published var movieDetails: MovieDetailsModel? = nil
    @Published var isFavorite: Bool = false
    
    init(movieDataSource: MovieDataSource, id: Int, favoritesViewModel: FavoritesViewModel) {
        self.movieDataSource = movieDataSource
        self.id = id
        self.favoritesViewModel = favoritesViewModel
        Task {
            await fetchMovieDetails()
        }
    }
    
    func fetchMovieDetails() async {
        do {
            let movieDetailsModel = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<MovieDetailsModel, Error>) in
                movieDataSource.fetchMovieDetails(id: id) { result in
                    switch result {
                    case .success(let movieDetailsModel):
                        continuation.resume(returning: movieDetailsModel)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            self.movieDetails = movieDetailsModel
            let favorites = movieDataSource.fetchFavorites()
            if favorites.contains(where: {$0 == movieDetailsModel.id}) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        } catch {
            print("Error fetching movie details: \(error)")
        }
    }
    
    func toggleIsFavorite() {
        favoritesViewModel.toggleFavoriteMovie(id: id)
        isFavorite = !isFavorite
    }
}


