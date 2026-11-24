import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            MainTabView(onLogout: {
                withAnimation { isAuthenticated = false }
            })
        } else {
            LoginView(onLoginSuccess: {
                withAnimation { isAuthenticated = true }
            })
        }
    }
}

#Preview {
    ContentView()
}
