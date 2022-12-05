//
//  MovieList.swift
//  TestMV
//
//  Created by Valmir Torres on 04/12/22.
//

import SwiftUI

struct MovieList: View {
    @StateObject var store: MovieStore
    @State var visibility: Visibility = .visible
    var title: String
    
    var body: some View {
        NavigationView {
            List(store.movies) { item in
                NavigationLink {
                    MovieDetail(store: MovieStore(type: .detail(item.id)))
                } label: {
                    MovieRow(movie: item)
                        .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in 90 })
                        .onAppear {
                            Task {
                                await loadNextPageIfNeeded(with: item.id)
                            }
                        }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await store.loadData(isToReload: true)
                        }
                    } label: {
                        Label("Reload Data", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .onAppear {
                Task {
                    await store.loadData()
                }
            }
        }
        .alert(isPresented: $store.showError) {
            Alert(title: Text("Attention"),
                  message: Text(store.errorMessage),
                  dismissButton: .cancel(Text("Ok"))
            )
        }
    }

    private func loadNextPageIfNeeded(with id: Int) async {
        var position = store.movies.count - 1
        if store.movies.count > 5 {
            position = store.movies.count - 5
        }
        if id == store.movies[position].id {
            await store.loadData()
        }
    }
}

struct MovieRow: View {
    var movie: MovieStore.Item
    
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .foregroundColor(.gray)
            }
            .frame(width: 78, height: 118)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    
                Text(movie.originalTitle)
                    .font(.subheadline)
                    .italic()
                    .lineLimit(2)
                
                Label {
                    Text(movie.voteAverage)
                        .font(.footnote)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                
                HStack {
                    Label {
                        Text(movie.popularity)
                            .font(.footnote)
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                    Spacer()
                    
                    Text(movie.releaseDate)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
    }
}

struct ListMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MovieList(store: MovieStore(type: .popular), title: "Popular")
    }
}
