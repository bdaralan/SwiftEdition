import SwiftUI


/// A UINavigationController wrapper that wraps a view as root view.
///
/// The wrapper injects an environment object, `Coordinator`, to the root view.
/// The root view can use this object to access the wrapped navigation and root controller.
///
/// - Tag: UINavigationControllerWrapper
///
public struct UINavigationControllerWrapper: UIViewControllerRepresentable {
    
    private let onMakeRootController: (Coordinator) -> UIViewController
    
    public init<RootView>(@ViewBuilder onMakeRootView: @escaping () -> RootView) where RootView: View {
        onMakeRootController = { coordinator in
            let rootView = onMakeRootView().environmentObject(coordinator)
            let rootController = UIHostingController(rootView: rootView)
            return rootController
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let coordinator = context.coordinator
        let rootController = onMakeRootController(coordinator)
        let navController = UINavigationController(rootViewController: rootController)
        coordinator.navController = navController
        coordinator.rootController = rootController
        return navController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // no updates
    }
    
    public class Coordinator: ObservableObject {
        public fileprivate(set) var navController: UINavigationController!
        public fileprivate(set) var rootController: UIViewController!
        fileprivate init() {}
    }
}


struct UINavigationControllerWrapper_Previews: PreviewProvider {
    struct RootView: View {
        @EnvironmentObject private var coordinator: UINavigationControllerWrapper.Coordinator
        @State private var rows = Array(0..<49)
        var body: some View {
            List(rows, id: \.self) { number in
                Text("Row \(number)")
            }.onAppear {
                let navItem = coordinator.rootController.navigationItem
                navItem.title = "Root View"
                navItem.searchController = .init()
                let shuffle = UIAction {
                    $rows.animation(.default).wrappedValue.shuffle()
                }
                navItem.rightBarButtonItems = [
                    .init(systemItem: .refresh, primaryAction: shuffle, menu: nil)
                ]
            }
        }
    }
    static var previews: some View {
        UINavigationControllerWrapper {
            RootView()
        }
        .ignoresSafeArea()
    }
}
