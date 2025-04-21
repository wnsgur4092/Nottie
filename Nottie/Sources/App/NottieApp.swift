import SwiftUI
import SwiftData

@main
struct NottieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showOnboarding = false
    
    var body: some Scene {
        let modelContainer = try! ModelContainer(for: Nottie.self)
        let context = modelContainer.mainContext
        
        WindowGroup {
            NottieListView(viewModel: NottieListViewModel(repository: NottieRepository(context: context)))
                .modelContainer(modelContainer)
                .sheet(isPresented: .constant(!hasSeenOnboarding)) {
                    OnboardingView(viewModel: OnboardingViewModel(notificationService: NotificationHandler()), isPresented: .constant(false))
                }
        }
    }
}
