//
// SwipeToDelete.swift
// HapticEngineDemo
//

import SwiftUI
import UIKit

/// Swipe a row left to uncover a plain trash icon on the card's own background, instead of the system's
/// filled action button. A short swipe leaves the icon showing to tap; a long one deletes straight away.
struct SwipeToDelete<Content: View>: View {
    @Binding var isOpen: Bool
    let onDelete: () -> Void
    @ViewBuilder let content: Content

    /// How far an open row sits, leaving room for the icon.
    private let openWidth: CGFloat = 64
    /// Past this share of the row's width, letting go deletes.
    private let deleteFraction: CGFloat = 0.5

    @State private var dragOffset: CGFloat?
    @State private var width: CGFloat = 0
    @State private var isDeleting = false

    private var restingOffset: CGFloat { isOpen ? -openWidth : 0 }
    private var offset: CGFloat { isDeleting ? -width : (dragOffset ?? restingOffset) }
    private var passesDeleteThreshold: Bool { width > 0 && -offset > width * deleteFraction }

    var body: some View {
        content
            // Opaque, so the icon stays hidden until the row moves.
            .background(Color(.secondarySystemGroupedBackground))
            .offset(x: offset)
            .background(alignment: .trailing) { deleteButton }
            .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
            .gesture(
                HorizontalPan(allowsRightward: isOpen) { translation in
                    // Only leftward from rest; resists a little past the full width.
                    let proposed = min(0, restingOffset + translation)
                    dragOffset = proposed < -width ? -width + (proposed + width) / 4 : proposed
                } onEnd: { velocity in
                    settle(velocity: velocity)
                }
            )
            .sensoryFeedback(.impact(weight: .light), trigger: passesDeleteThreshold) { _, passes in passes }
            .animation(.snappy, value: isOpen)
            .accessibilityAction(named: "Delete", onDelete)
    }

    private var deleteButton: some View {
        Button("Delete", systemImage: "trash", action: delete)
            .labelStyle(.iconOnly)
            .font(.body.weight(.medium))
            // Gray until letting go would delete, then red: the only color in the whole gesture.
            .foregroundStyle(passesDeleteThreshold ? Color.red : Color.secondary)
            .scaleEffect(passesDeleteThreshold ? 1.15 : 1)
            .frame(width: openWidth)
            .frame(maxHeight: .infinity)
            .contentShape(.rect)
            // Fades in as the row uncovers it.
            .opacity(min(1, -offset / openWidth))
            .animation(.snappy(duration: 0.2), value: passesDeleteThreshold)
            .accessibilityHidden(true)
    }

    private func settle(velocity: CGFloat) {
        guard let dragOffset else { return }
        // A quick flick counts as a full swipe, as in system lists.
        if passesDeleteThreshold || (dragOffset < -openWidth && velocity < -1500) {
            delete()
            return
        }
        let opens = dragOffset < -openWidth / 2 || velocity < -300
        withAnimation(.snappy) {
            self.dragOffset = nil
            isOpen = opens && velocity < 300
        }
    }

    private func delete() {
        // Slides the row the rest of the way out, then removes it so the rows below move up.
        withAnimation(.snappy(duration: 0.25)) {
            dragOffset = nil
            isDeleting = true
        } completion: {
            isOpen = false
            onDelete()
        }
    }
}

/// A pan that only starts on a mostly horizontal drag, so vertical scrolling and the navigation back
/// swipe keep working. A SwiftUI `DragGesture` inside a scroll view can't make that choice.
private struct HorizontalPan: UIGestureRecognizerRepresentable {
    /// Rightward drags are left to the back swipe unless a row is open and can be closed.
    var allowsRightward: Bool
    var onChange: (CGFloat) -> Void
    var onEnd: (_ velocity: CGFloat) -> Void

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        pan.delegate = context.coordinator
        return pan
    }

    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        context.coordinator.allowsRightward = allowsRightward
    }

    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        switch recognizer.state {
        case .changed:
            onChange(recognizer.translation(in: recognizer.view).x)
        case .ended, .cancelled:
            onEnd(recognizer.velocity(in: recognizer.view).x)
        default:
            break
        }
    }

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var allowsRightward = false

        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            guard let pan = recognizer as? UIPanGestureRecognizer else { return false }
            let velocity = pan.velocity(in: pan.view)
            guard abs(velocity.x) > abs(velocity.y) else { return false }
            return velocity.x < 0 || allowsRightward
        }
    }
}
