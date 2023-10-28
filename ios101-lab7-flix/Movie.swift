//
//  Movie.swift
//  ios101-lab6-flix
//

import Foundation

struct MovieFeed: Decodable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let title: String
    let overview: String
    let posterPath: String? // Path used to create a URL to fetch the poster image

    // MARK: Additional properties for detail view
    let backdropPath: String? // Path used to create a URL to fetch the backdrop image
    let voteAverage: Double?
    let releaseDate: Date?

    // MARK: ID property to use when saving movie
    let id: Int

    // MARK: Custom coding keys
    // Allows us to map the property keys returned from the API that use underscores (i.e. `poster_path`)
    // to a more "swifty" lowerCamelCase naming (i.e. `posterPath` and `backdropPath`)
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case id
    }
}



// Methods for saving, retrieving, and removing movies from favorites
extension Movie {
    // The "Favorites" key
    static var favoritesKey: String {
        return "Favorites"
    }

    // Save an array of favorite movies to UserDefaults
    static func save(_ movies: [Movie], forKey key: String) {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(movies)
        defaults.set(encodedData, forKey: key)
    }

    // Get the array of favorite movies from UserDefaults
    static func getMovies(forKey key: String) -> [Movie] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let decodedMovies = try! JSONDecoder().decode([Movie].self, from: data)
            return decodedMovies
        } else {
            return []
        }
    }

    // Adds the movie to the favorites array in UserDefaults
    func addToFavorites() {
        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
        favoriteMovies.append(self)
        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
    }

    // Removes the movie from the favorites array in UserDefaults
    func removeFromFavorites() {
        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
        favoriteMovies.removeAll { movie in
            return self == movie
        }
        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
    }
}
