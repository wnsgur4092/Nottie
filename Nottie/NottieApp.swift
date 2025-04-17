import SwiftUI
import SwiftData

@main
struct NottieApp: App {
    var body: some Scene {
        WindowGroup {
            NottieListView(viewModel: NottieListViewModel(repository: MockNottieRepository()))
                .modelContainer(for: Nottie.self)
        }
    }
}
