import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Aktywne okienka znajomych")) {
                    if viewModel.activeDyspos.isEmpty {
                        Text("Brak aktywnych dyspo w okolicy.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.activeDyspos) { dyspo in
                            DyspoRow(dyspo: dyspo)
                        }
                    }
                }
            }
            .navigationTitle("CatchMe 📍")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddDyspoView(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
