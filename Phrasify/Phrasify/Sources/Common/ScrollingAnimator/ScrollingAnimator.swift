//
//  ScrollingAnimator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

/// A view modifier for animating the navigation title while scrolling through the content.
struct ScrollingAnimator: ViewModifier {

    enum State {
        case scrollView
        case navigationBar
    }

    @Binding var state: State

    /// The offset from which the animation will be triggered.
    var offsetToAnimateTitle: CGFloat

    /// Animation with which the navigation bar will change.
    var animation: Animation

    /// Assigns a name to the view’s coordinate space, so other code can operate on dimensions like points
    /// and sizes relative to the named space.
    var coordinateSpace: String

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            geometryReader()
            content
        }
    }

    @ViewBuilder
    private func geometryReader() -> some View {
        GeometryReader { reader -> AnyView in
            let offset = reader.frame(in: .named(coordinateSpace)).minY
            // Guard statement prevents the view from constantly refreshing.
            // Once we have the right state for this offset, we don't want to
            // set the variable again, which would cause the view to be refreshed.
            guard self.state == .navigationBar && offset > offsetToAnimateTitle ||
                  self.state == .scrollView && offset < offsetToAnimateTitle else {
                return AnyView( EmptyView() )
            }
            DispatchQueue.main.async {
                withAnimation(animation) {
                    self.state = offset < offsetToAnimateTitle ? .navigationBar : .scrollView
                }
            }
            return AnyView( EmptyView() )
        }
        .frame(height: 0)
    }
}

extension View {

    private var coordinateSpace: String { "scrollSpace" }

    func animate(_ state: Binding<ScrollingAnimator.State>,
                 offsetToAnimate: CGFloat = -20,
                 animation: Animation = .default.speed(1)) -> some View {
        modifier(ScrollingAnimator(state: state, offsetToAnimateTitle: offsetToAnimate,
                                   animation: animation, coordinateSpace: coordinateSpace))
    }

    func scrollSpace() -> some View {
        self
            .coordinateSpace(name: coordinateSpace)
    }
}
