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
            self.movieDetails = try await movieDataSource.fetchMovieDetails(id: id)
        } catch {
            print("Error fetching freeToWatch movies: \(error)")
        }
    }
}


