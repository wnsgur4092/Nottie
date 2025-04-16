import SwiftUI
import SwiftData

@main
struct NottieApp: App {
    var body: some Scene {
        WindowGroup {
            NottieListView()
                .modelContainer(for: Nottie.self)
        }
    }
}
