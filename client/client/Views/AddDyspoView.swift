import SwiftUI

struct AddDyspoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DashboardViewModel
    
    @State private var selectedZone = "Budynek B5"
    @State private var selectedIntent = "☕️"
    @State private var duration: Double = 60
    
    let zones = ["Budynek B5", "Miasteczko", "Biblioteka", "Rynek Główny"]
    let intents = ["☕️", "💻", "⚽️", "🍕", "🍻"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gdzie jesteś?")) {
                    Picker("Strefa", selection: $selectedZone) {
                        ForEach(zones, id: \.self) { Text($0) }
                    }
                }
                
                Section(header: Text("Co robimy?")) {
                    Picker("Intencja", selection: $selectedIntent) {
                        ForEach(intents, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Jak długo masz okienko?")) {
                    VStack {
                        Slider(value: $duration, in: 15...180, step: 15)
                        Text("\(Int(duration)) minut")
                            .bold()
                    }
                }
                
                Button {
                    viewModel.addMyDyspo(location: selectedZone, intent: selectedIntent, durationMinutes: duration)
                    dismiss()
                } label: {
                    Text("Rzuć Dyspo")
                        .frame(maxWidth: .infinity)
                        .bold()
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.blue)
            }
            .navigationTitle("Nowe Dyspo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anuluj") { dismiss() }
                }
            }
        }
    }
}
