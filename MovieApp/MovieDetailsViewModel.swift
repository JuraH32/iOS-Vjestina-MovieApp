import SwiftUI
import MovieAppData

class MovieDetailsViewModel: ObservableObject {
    private let movieDataSource: MovieDataSource
    
    @Published var movieDetails: MovieDetailsModel? = nil
    
    init(movieDataSource: MovieDataSource, id: Int) {
        self.movieDataSource = movieDataSource
        
        Task {
            await fetchMovieDetails(id: id)
        }
    }
    
    func fetchMovieDetails(id: Int) async {
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
        } catch {
            print("Error fetching movie details: \(error)")
        }
    }
}


