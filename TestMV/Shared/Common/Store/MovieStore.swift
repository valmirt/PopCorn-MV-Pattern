//
//  MovieStore.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation

final class MovieStore: ObservableObject {
    private let typeLoading: TypeLoad
    private var page = 0
    private var totalPages = Int.max
    private(set) var errorMessage: String = ""
    
    @Published private(set) var movies: [Item] = []
    @Published private(set) var detail: Detail?
    @Published private(set) var isLoading: Bool = false
    @Published var showError: Bool = false
    
    init(type: TypeLoad) {
        self.typeLoading = type
    }

    func loadData(isToReload: Bool = false) async {
        await MainActor.run { isLoading = true }
        do {
            if isToReload {
                page = 0
                movies = []
            }
            if page < totalPages {
                page += 1
                switch typeLoading {
                case .nowPlaying:
                    try await setupList(data: PageInfo.nowPlayingMovies(on: page))
                case .topRated:
                    try await setupList(data: PageInfo.topRatedMovies(on: page))
                case .popular:
                    try await setupList(data: PageInfo.popularMovies(on: page))
                case .upcoming:
                    try await setupList(data: PageInfo.upcomingMovies(on: page))
                default:
                    await MainActor.run { isLoading = false }
                    break
                }
            } else {
                await MainActor.run { isLoading = false }
            }
        } catch {
            await setupError(with: error.localizedDescription)
        }
    }

    func loadDetail() async {
        await MainActor.run { isLoading = true }
        do {
            switch typeLoading {
            case .detail(let id):
                async let detail = Movie.detail(with: id)
                async let credit = Credit.movieCredit(by: id)
                try await setupDetail(data: (detail, credit))
            default:
                await MainActor.run { isLoading = false }
                break
            }
        } catch {
            await setupError(with: error.localizedDescription)
        }
    }

    @MainActor
    private func setupList(data: PageInfo<MovieVO>) {
        totalPages = data.totalPages
        var list: [Item] = []
        data.results.forEach { item in
            if !movies.contains(where: { $0.id == item.id }) {
                var posterURL: URL?
                if let posterPath = item.posterPath {
                    posterURL = TMDBService
                        .shared
                        .createURL(
                            baseURL: TMDBService.shared.baseImageUrl,
                            path: "\(TMDBService.shared.imageW185)/\(posterPath)"
                        )
                }
                list.append(
                    Item(
                        id: item.id,
                        popularity: String(item.popularity.round(to: 1)),
                        releaseDate: item.releaseDate,
                        title: item.title,
                        originalTitle: item.originalTitle,
                        voteAverage: String(item.voteAverage.round(to: 1)),
                        posterURL: posterURL
                    )
                )
            }
        }
        movies.append(contentsOf: list)
        isLoading = false
    }

    @MainActor
    private func setupDetail(data: (movie: Movie, credit: Credit)) {
        var backdropURL: URL?
        if let backdropPath = data.movie.backdropPath {
            backdropURL = TMDBService
                .shared
                .createURL(
                    baseURL: TMDBService.shared.baseImageUrl,
                    path: "\(TMDBService.shared.imageW500)/\(backdropPath)"
                )
        }
        detail = Detail(
            backdropURL: backdropURL,
            budget: data.movie.budget.toCurrency,
            genres: data.movie.genres.map({ $0.name }).desc,
            originalLanguage: data.movie.originalLanguage,
            originalTitle: data.movie.originalTitle,
            overview: data.movie.overview ?? "",
            popularity: String(data.movie.popularity.round(to: 1)),
            releaseDate: String(data.movie.releaseDate.prefix(4)),
            revenue: data.movie.revenue.toCurrency,
            runtime: "\(data.movie.runtime ?? 0) min",
            status: data.movie.status,
            title: data.movie.title,
            voteAverage: String(data.movie.voteAverage.round(to: 1)),
            credit: setupCredit(data: data.credit)
        )
        isLoading = false
    }

    @MainActor
    private func setupError(with message: String) {
        errorMessage = message
        isLoading = false
        showError = true
    }

    private func setupCredit(data: Credit) -> [Detail.CastCrew] {
        var list: [Detail.CastCrew] = []
        let concat = data.cast + (data.guestStars ?? []) + data.crew
        concat.forEach { item in
            var profileURL: URL?
            if let profilePath = item.profilePath {
                profileURL = TMDBService
                    .shared
                    .createURL(
                        baseURL: TMDBService.shared.baseImageUrl,
                        path: "\(TMDBService.shared.imageW185)/\(profilePath)"
                    )
            }
            list.append(
                Detail.CastCrew(
                    idCredit: item.id,
                    name: item.name,
                    characterOrJob: item.character ?? item.job ?? "-",
                    profileURL: profileURL
                )
            )
        }
        return list
    }
}

extension MovieStore {
    struct Item: Identifiable {
        let id: Int
        let popularity: String
        let releaseDate: String
        let title: String
        let originalTitle: String
        let voteAverage: String
        let posterURL: URL?
    }
    struct Detail {
        let backdropURL: URL?
        let budget: String
        let genres: String
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: String
        let releaseDate: String
        let revenue: String
        let runtime: String
        let status: String
        let title: String
        let voteAverage: String
        let credit: [CastCrew]
        
        struct CastCrew: Identifiable {
            let id: String = UUID().uuidString
            let idCredit: Int
            let name: String
            let characterOrJob: String
            let profileURL: URL?
        }
    }
    enum TypeLoad {
        case nowPlaying, topRated, popular, upcoming, detail(Int)
    }
}
