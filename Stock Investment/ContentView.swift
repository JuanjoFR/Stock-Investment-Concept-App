//
//  ContentView.swift
//  Stock Investment
//
//  Created by Juanjo Fernández Romeo on 13/10/23.
//

import SwiftUI

struct InvestCard: View {
    let data: RecentItem
    var progressionSystemImageName: String {
        if data.progression < 0 {
            return "chevron.down"
        } else if data.progression > 0 {
            return "chevron.up"
        } else {
            return "minus.circle"
        }
    }
    var progressionColor: Color {
        if data.progression < 0 {
            return .danger
        } else if data.progression > 0 {
            return .info
        } else {
            return .black
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Circle()
                .fill(.gray)
                .frame(width: 48, height: 48)
            Text(data.code)
                .font(.headline)
            Text(data.name)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.bottom)
            HStack {
                Text("$\(data.value.formatted(.number.precision(.fractionLength(2))))")
                Spacer(minLength: 14)
                Image(systemName: progressionSystemImageName)
                    .foregroundColor(progressionColor)
                Text("\(data.progression.formatted(.number.precision(.fractionLength(2))))%")
                    .foregroundColor(progressionColor)
            }
            .font(.subheadline)
            .fontWeight(.medium)
        }
        .padding()
        .background(.white)
        .cornerRadius(14)
    }
}

struct ContentView: View {
    @State var loading = false
    @StateObject var viewModel = StockDataBase()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Recently Viewed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        if loading == true {
                            HStack {
                                Text("Loading...")
                            }
                        } else {
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.homeScreen) { item in
                                        InvestCard(data: item)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                    .navigationTitle("Invest")
                }
            }
        }
        .onAppear {
            Task {
                loading = true
                await viewModel.fetch()
                loading = false
            }
        }
    }
}

class StockDataBase: ObservableObject {
    @Published var homeScreen: [RecentItem] = []
    
    func fetch() async {
        do {
            print("start sleep")
            try await Task.sleep(nanoseconds: 2_000_000_000)
            print("end sleep")
            
            homeScreen.append(
                RecentItem(code: "AAPL", name: "Apple", value: 358.07, progression: 3.04)
            )
            homeScreen.append(
                RecentItem(code: "MSFT", name: "Microsoft", value: 336.72, progression: -1.29)
            )
            homeScreen.append(
                RecentItem(code: "SPOT", name: "Spotify", value: 406.75, progression: 0.54)
            )
        } catch {
            print("error!")
        }
    }
}

struct RecentItem: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let value: Float
    let progression: Float
}

#Preview {
    ContentView()
}
