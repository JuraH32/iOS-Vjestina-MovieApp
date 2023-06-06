
import SwiftUI

class FavoritesViewModel: ObservableObject {
    private let movieDataSource: MovieDataSource
    
    @Published var favoriteMovies: [MovieModel] = []
    
    init(movieDataSource: MovieDataSource) {
        self.movieDataSource = movieDataSource
        Task {
            await fetchFavoriteMovies()
        }
    }
    
    func fetchFavoriteMovies() async{
        let favoriteIds = movieDataSource.fetchFavorites()
        var movies = favoriteMovies.filter({
            let movie = $0
            return favoriteIds.contains(where: {$0 == movie.id})
        })
        let idsToAdd = favoriteIds.filter({
            let id = $0
            return !movies.contains(where: {$0.id == id})
        })
        for id in idsToAdd {
            do {
                let movieModel = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<MovieModel, Error>) in
                    movieDataSource.fetchMovie (id: id) { result in
                        switch result {
                        case .success(let movieModel):
                            continuation.resume(returning: movieModel)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                movies.append(movieModel)
            } catch {
                print("Error fetching favorite movies: \(error)")
            }
        }
        self.favoriteMovies = movies
    }
    
    func toggleFavoriteMovie(id: Int) {
        movieDataSource.toggleFavoriteMovie(id: id)
        Task {
            await fetchFavoriteMovies()
        }
    }
}

