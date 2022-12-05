//
//  MovieDetail.swift
//  TestMV
//
//  Created by Valmir Torres on 04/12/22.
//

import SwiftUI

struct MovieDetail: View {
    @StateObject var store: MovieStore
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let detail = store.detail {
                    GeometryReader { proxy in
                        AsyncImage(url: detail.backdropURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "film")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        }
                        .frame(width: proxy.size.width, height: 250)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black]),
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 100)
                        
                        Text(detail.title)
                            .font(.title)
                            .lineLimit(2)
                            .padding(.horizontal)
                        
                        HStack(alignment: .top) {
                            Text(detail.originalTitle)
                                .font(.title2)
                                .italic()
                                .lineLimit(2)
                            
                            Spacer()
                            
                            Text(detail.releaseDate)
                                .font(.body)
                        }
                        .padding(.horizontal)
                        
                        Text(detail.genres)
                            .lineLimit(1)
                            .padding(.horizontal)
                        
                        HStack {
                            Text(detail.runtime)
                                .lineLimit(1)
                            Spacer()
                            Text(detail.status)
                                .italic()
                                .lineLimit(1)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Label {
                                Text(detail.voteAverage)
                            } icon: {
                                Image(systemName: "star.fill")
                            }
                            Spacer()
                            
                            Text("Budget: \(detail.budget)")
                                .lineLimit(1)
                        }
                        .padding(.top)
                        .padding(.horizontal)

                        HStack {
                            Label {
                                Text(detail.popularity)
                            } icon: {
                                Image(systemName: "heart.fill")
                            }
                            Spacer()
                            
                            Text("Revenue: \(detail.revenue)")
                                .lineLimit(1)
                        }
                        .padding(.horizontal)

                        
                        Text(detail.overview)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(detail.credit) { item in
                                    CreditView(credit: item)
                                        .frame(width: 120)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.top, 150)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            Task {
                await store.loadDetail()
            }
        }
        .alert(isPresented: $store.showError) {
            Alert(title: Text("Attention"),
                  message: Text(store.errorMessage),
                  dismissButton: .cancel(
                    Text("Ok"),
                    action: { presentationMode.wrappedValue.dismiss() }
                  )
            )
        }
    }
}

struct CreditView: View {
    var credit: MovieStore.Detail.CastCrew
    
    var body: some View {
        VStack {
            AsyncImage(url: credit.profileURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.gray)
            }
            .frame(width: 84, height: 84)
            .clipShape(Circle())
            
            Text(credit.characterOrJob)
                .font(.footnote)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)
    
            Text(credit.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Spacer()
        }
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(store: MovieStore(type: .detail(550)))
    }
}
