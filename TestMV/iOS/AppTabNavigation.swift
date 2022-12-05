//
//  AppTabNavigation.swift
//  TestMV
//
//  Created by Valmir Torres on 04/12/22.
//

import SwiftUI

struct AppTabNavigation: View {
    enum Tab {
        case popular
        case nowPlaying
        case upcoming
        case topRated
    }

    @State private var selection: Tab = .popular

    var body: some View {
        TabView(selection: $selection) {
            MovieList(store: MovieStore(type: .popular), title: "Popular")
                .tabItem {
                    Label {
                        Text("Popular", comment: "Popular movies tab title")
                    } icon: {
                        Image(systemName: "heart.fill")
                    }
                }
                .tag(Tab.popular)
            
            MovieList(store: MovieStore(type: .nowPlaying), title: "Now Playing")
                .tabItem {
                    Label {
                        Text("Now Playing", comment: "Now playing movies tab title")
                    } icon: {
                        Image(systemName: "pin.fill")
                    }
                }
                .tag(Tab.nowPlaying)
            
            MovieList(store: MovieStore(type: .upcoming), title: "Upcoming")
                .tabItem {
                    Label {
                        Text("Upcoming", comment: "Upcoming movies tab title")
                    } icon: {
                        Image(systemName: "theatermasks.fill")
                    }
                }
                .tag(Tab.upcoming)
            
            MovieList(store: MovieStore(type: .topRated), title: "Top Rated")
                .tabItem {
                    Label {
                        Text("Top Rated", comment: "Top rated movies tab title")
                    } icon: {
                        Image(systemName: "star.fill")
                    }
                }
                .tag(Tab.topRated)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
