import Foundation

class MovieDetailsViewModel {
    private let movieAPI = MovieAPI()
    private let movieID: Int
    var movie: Movie?

    var onMovieDetailsFetched: (() -> Void)?
    
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    func fetchMovieDetails() {
        movieAPI.fetchMovieDetails(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.onMovieDetailsFetched?()
            case .failure(let error):
                print("Failed to fetch movie details: \(error)")
            }
        }
    }
    
    func getTitle() -> String {
        return movie?.name ?? ""
    }
    
    func getYear() -> String {
        if let year = movie?.year {
            return "(\(year))"
        }
        return ""
    }
    
    func getScore() -> String {
        if let rating = movie?.rating {
            return "\(rating)"
        }
        return ""
    }
    
    func getReleaseDate() -> String {
        if let releaseDate = movie?.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: releaseDate) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "d/M/yyyy"
                return outputDateFormatter.string(from: date)
            }
        }
        return ""
    }
    
    func getCategories() -> String {
        return movie?.categories?.joined(separator: ", ") ?? ""
    }
    
    func getDuration() -> String {
        if let duration = movie?.duration {
            let hours = duration / 60
            let minutes = duration % 60
            return "\(hours)h \(minutes)m"
        }
        return ""
    }
    
    func getSummary() -> String {
        return movie?.summary ?? ""
    }
    
    func getCrewMembers() -> [CrewMember] {
        return movie?.crewMembers ?? []
    }
    
    func getImageURL() -> URL? {
        if let imageUrl = movie?.imageUrl {
            return URL(string: imageUrl)
        }
        return nil
    }
}
