import SwiftUI
import SwiftData

@main
struct NottieApp: App {
    @UIApplicationDelegateAdaptor(NotificationHandler.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NottieListView(viewModel: NottieListViewModel(repository: MockNottieRepository()))
                .modelContainer(for: Nottie.self)
        }
    }
}
