import SwiftUI


@available(iOS 15.0, *)
struct DetentSheet<Content>: View where Content: View {
    
    @Binding var item: DetentSheetItem
    var onActionDismiss: (() -> Void)?
    var onInteractionDismiss: (() -> Void)?
    var onPreventionDismiss: (() -> Void)?
    let content: Content
    
    @State private var components = Components()
    private var controller: DetentSheetController { components.controller }
    
    struct Components {
        let controller = DetentSheetController()
    }
    
    var body: some View {
        UIViewControllerWrapper(onMake: makeController, onUpdate: updateController)
            .onChange(of: item, perform: updateSheet)
    }
    
    private func updateSheet(item: DetentSheetItem) {
        controller.updateSheet(item: item, content: content)
    }
    
    private func updateController() {
        controller.updateSheet(content: content)
    }
    
    private func makeController() -> DetentSheetController {
        controller.view.backgroundColor = .clear
        controller.view.isUserInteractionEnabled = false
        
        controller.onActionDismiss = {
            onActionDismiss?()
        }
        
        controller.onInteractionDismiss = {
            item.detent = nil
            onInteractionDismiss?()
        }
        
        controller.onPreventionDismiss = {
            onPreventionDismiss?()
        }
        
        controller.onViewAppear = {
            controller.updateSheet(item: item, content: content)
        }
        
        controller.onDetentChange = { detent in
            item.detent = detent
        }
        
        return controller
    }
}


extension View {
    
    @available(iOS 15.0, *)
    public func detentSheet<Content>(
        item: Binding<DetentSheetItem>,
        onDismiss: @escaping (DetentSheetItem.DismissReason) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        let sheet = DetentSheet(
            item: item,
            onActionDismiss: { onDismiss(.action) },
            onInteractionDismiss: { onDismiss(.interaction) },
            onPreventionDismiss: { onDismiss(.prevention) },
            content: content()
        )
        return background(sheet)
    }
}


@available(iOS 15.0, *)
final class DetentSheetController: UIViewController, UISheetPresentationControllerDelegate {
    
    var onViewAppear: (() -> Void)?
    var onActionDismiss: (() -> Void)?
    var onInteractionDismiss: (() -> Void)?
    var onPreventionDismiss: (() -> Void)?
    var onDetentChange: ((DetentSheetItem.Detent?) -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewAppear?()
    }
    
    func updateSheet<Content>(content: Content) where Content: View {
        guard let controller = presentedViewController as? UIHostingController<Content> else { return }
        controller.rootView = content
    }
    
    func updateSheet<Content>(item: DetentSheetItem, content: Content) where Content: View {
        // case present sheet
        if presentedViewController == nil, item.detent != nil {
            let controller = UIHostingController(rootView: content)
            controller.view.backgroundColor = .clear
            let sheet = configureSheet(controller: controller, item: item)
            sheet.selectedDetentIdentifier = item.detent?.uiDetentID
            present(controller, animated: true, completion: nil)
            return
        }
        
        // case update sheet
        if let controller = presentedViewController, let detent = item.detent {
            let sheet = configureSheet(controller: controller, item: item)
            guard sheet.selectedDetentIdentifier != detent.uiDetentID else { return }
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = detent.uiDetentID
            }
            return
        }
        
        // case dismiss sheet
        if let controller = presentedViewController, item.detent == nil {
            controller.dismiss(animated: true, completion: onActionDismiss)
            return
        }
    }
    
    @discardableResult
    private func configureSheet(controller: UIViewController, item: DetentSheetItem) -> UISheetPresentationController {
        controller.modalPresentationStyle = .formSheet
        controller.isModalInPresentation = item.allowInteractiveDismissal == false
        
        let sheet = controller.presentationController as! UISheetPresentationController
        sheet.delegate = self
        sheet.detents = item.detents.map(\.uiDetent)
        sheet.smallestUndimmedDetentIdentifier = item.smallestUndimmedDetent?.uiDetentID
        sheet.prefersGrabberVisible = item.prefersGrabberVisible
        sheet.prefersEdgeAttachedInCompactHeight = item.prefersEdgeAttachedInCompactHeight
        sheet.prefersScrollingExpandsWhenScrolledToEdge = item.prefersScrollingExpandsWhenScrolledToEdge
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = item.widthFollowsPreferredContentSizeWhenEdgeAttached
        
        return sheet
    }
    
    // MARK: - Sheet Delegate
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        let detentID = sheetPresentationController.selectedDetentIdentifier
        switch detentID {
        case .none:
            onDetentChange?(.none)
        case UISheetPresentationController.Detent.Identifier.medium:
            onDetentChange?(.medium)
        case UISheetPresentationController.Detent.Identifier.large:
            onDetentChange?(.large)
        default:
            print("⚠️ unimplemented detent identifier \(detentID?.rawValue ?? "") ⚠️")
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onInteractionDismiss?()
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        onPreventionDismiss?()
    }
}


@available(iOS 15.0, *)
struct DetentSheet_Previews: PreviewProvider {
    static var previews: some View {
        StateContent()
    }
    struct StateContent: View {
        @State private var item = DetentSheetItem(detent: .medium)
        @State private var number = 0
        @State private var dismissReason = ""
        var smallestUndimmedDetent: String { item.smallestUndimmedDetent?.uiDetentID.rawValue ?? "nil" }
        var body: some View {
            makeSheetView()
                .detentSheet(item: $item, onDismiss: handleDismiss, content: makeSheetView)
        }
        
        func makeSheetView() -> some View {
            Form {
                Text("Detent: \(item.detent?.uiDetentID.rawValue ?? "nil")")
                Text("Dismiss Reason: \(dismissReason)")
                Button("Medium") {
                    item.detent = .medium
                }
                Button("Large") {
                    item.detent = .large
                }
                Button("Dismiss") {
                    item.detent = .none
                }
                Picker("Smallest Undimmed Detent: \(smallestUndimmedDetent)", selection: $item.smallestUndimmedDetent) {
                    let buttons: [(name: String, detent: DetentSheetItem.Detent?)] = [
                        ("None", nil), ("Medium", .medium), ("Large", .large)
                    ]
                    ForEach(buttons, id: \.name) { button in
                        Button(button.name) {
                            item.smallestUndimmedDetent = button.detent
                        }
                        .tag(button.detent)
                    }
                }
                .pickerStyle(.menu)
                Button("Allow Interaction Dismiss: \(String(item.allowInteractiveDismissal))") {
                    item.allowInteractiveDismissal.toggle()
                }
            }
        }
        
        func handleDismiss(reason: DetentSheetItem.DismissReason) {
            dismissReason = String(describing: reason)
        }
    }
}
