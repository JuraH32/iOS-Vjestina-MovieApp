import MovieAppData
import Foundation

class MovieDataSource {
    var useCase = MovieAppData.MovieUseCase()
    let baseUrl = "https://five-ios-api.herokuapp.com"
    
    func fetchFreeToWatchMovies(criteria: MovieTagModel, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = baseUrl + "/api/v1/movie/free-to-watch?criteria=" + criteria.rawValue
        return fetchMovies(criteria: criteria, urlString: urlString, completion: completion)
    }
    
    func fetchPopularMovies(criteria: MovieTagModel, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = baseUrl + "/api/v1/movie/popular?criteria=" + criteria.rawValue
        return fetchMovies(criteria: criteria, urlString: urlString, completion: completion)
    }
    
    func fetchTrendingMovies(criteria: MovieTagModel, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = baseUrl + "/api/v1/movie/trending?criteria=" + criteria.rawValue
        return fetchMovies(criteria: criteria, urlString: urlString, completion: completion)
    }
    
    func fetchMovies(criteria: MovieTagModel, urlString: String,completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Data Error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movies = try decoder.decode([MovieModel].self, from: data)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        let urlString = "\(baseUrl)/api/v1/movie/\(id)/details"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Data Error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movie = try decoder.decode(MovieDetailsModel.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct MovieModel: Decodable {

    let id: Int
    let name: String
    let year: Int
    let summary: String
    let imageUrl: String

}

enum MovieTagModel: String, Decodable {

    case streaming = "STREAMING"
    case onTv = "ON_TV"
    case forRent = "FOR_RENT"
    case inTheaters = "IN_THEATERS"
    case movie = "MOVIE"
    case tvShow = "TV_SHOW"
    case trendingToday = "TODAY"
    case trendingThisWeek = "THIS_WEEK"

}

struct MovieDetailsModel: Decodable {

    let id: Int
    let name: String
    let year: Int
    let releaseDate: String
    let duration: Int
    let rating: Double
    let summary: String
    let imageUrl: String
    let categories: [MovieCategoryModel]
    let crewMembers: [MovieCrewMemberModel]

}

struct MovieCrewMemberModel: Decodable {
    
    let name: String
    let role: String

}

enum MovieCategoryModel: String, Decodable {

    case action = "ACTION"
    case adventure = "ADVENTURE"
    case comedy = "COMEDY"
    case crime = "CRIME"
    case drama = "DRAMA"
    case fantasy = "FANTASY"
    case romance = "ROMANCE"
    case scienceFiction = "SCIENCE_FICTION"
    case thriller = "THRILLER"
    case western = "WESTERN"

}
