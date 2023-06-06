import SwiftUI

class MovieCategoryListViewModel: ObservableObject {
    private let movieDataSource: MovieDataSource
    private let freeTags = [MovieTagModel.movie, MovieTagModel.tvShow]
    private let trendingTags = [ MovieTagModel.trendingToday, MovieTagModel.trendingThisWeek]
    private let popularTags = [MovieTagModel.streaming, MovieTagModel.onTv, MovieTagModel.forRent, MovieTagModel.inTheaters]
    
    @Published var freeToWatchMovies: [[MovieModel]] = []
    @Published var trendingMovies: [[MovieModel]] = []
    @Published var popularMovies: [[MovieModel]] = []
    
    init(movieDataSource: MovieDataSource) {
        self.movieDataSource = movieDataSource
        
        Task {
            await fetchPopularMovies()
            await fetchTrendingMovies()
            await fetchFreeToWatchMovies()
        }
    }
    
    func fetchFreeToWatchMovies() async {
        var movies: [[MovieModel]] = []
        for tag: MovieTagModel in freeTags {
            do {
                let movieModels = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[MovieModel], Error>) in
                    movieDataSource.fetchFreeToWatchMovies (criteria: tag) { result in
                        switch result {
                        case .success(let movieModels):
                            continuation.resume(returning: movieModels)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                movies.append(movieModels)
            } catch {
                print("Error fetching freeToWatch movies: \(error)")
            }
        }
        self.freeToWatchMovies = movies
    }
    
    func fetchTrendingMovies() async {
        var movies: [[MovieModel]] = []
        for tag: MovieTagModel in trendingTags {
            do {
                let movieModels = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[MovieModel], Error>) in
                    movieDataSource.fetchTrendingMovies (criteria: tag) { result in
                        switch result {
                        case .success(let movieModels):
                            continuation.resume(returning: movieModels)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                movies.append(movieModels)
            } catch {
                print("Error fetching trending movies: \(error)")
            }
        }
        self.trendingMovies = movies
    }
    
    func fetchPopularMovies() async {
        var movies: [[MovieModel]] = []
        for tag: MovieTagModel in popularTags {
            do {
                let movieModels = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[MovieModel], Error>) in
                    movieDataSource.fetchPopularMovies(criteria: tag) { result in
                        switch result {
                        case .success(let movieModels):
                            continuation.resume(returning: movieModels)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                movies.append(movieModels)
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
        self.popularMovies = movies
    }
}

