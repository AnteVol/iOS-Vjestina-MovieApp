import Foundation

class MovieAPI {
    static let shared = MovieAPI()
    private let baseURL = "https://five-ios-api.herokuapp.com/api/v1"
    private let apiKey = "Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps"
    
    init() {}
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(movieID)/details"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
