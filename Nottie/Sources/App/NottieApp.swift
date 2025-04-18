import SwiftUI
import SwiftData

@main
struct NottieApp: App {
    @UIApplicationDelegateAdaptor(NotificationHandler.self) var appDelegate

    var body: some Scene {
        let modelContainer = try! ModelContainer(for: Nottie.self)
        let context = modelContainer.mainContext
        
        WindowGroup {
            NottieListView(viewModel: NottieListViewModel(repository: NottieRepository(context: context)))
                .modelContainer(modelContainer)
        }
    }
}
