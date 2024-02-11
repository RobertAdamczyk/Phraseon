//
//  SwipeAction.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 08.01.24.
//

import SwiftUI

/// Custom Swipe Action View
struct SwipeAction<Content: View>: View {

    var cornerRadius: CGFloat = 0
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    /// View Properties
    /// View Unique ID
    let viewID = UUID()
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                    /// To Take Full Available Space
                        .containerRelativeFrame(.horizontal)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minx = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minx)
                                    .onPreferenceChange (OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: .topLeading)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .disabled(filteredActions.count == 0)
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }

    /// Action Buttons
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        /// Each Button Will Have 100 Width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 80)
            .overlay(alignment: .trailing) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds (0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds (0.1))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .apply(button.iconFont, size: .L, color: button.iconTint)
                                .frame(width: 80)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                    }
                }
            }
    }

    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minx = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minx > 0 ? -minx : 0)
    }

    var filteredActions: [Action] {
        return actions.filter({ $0.isEnabled })
    }
}

/// Offset Key
fileprivate struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Custom Transition
fileprivate struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    Rectangle ()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

/// Action Model
struct Action: Identifiable {
    private (set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: FontStyle = .medium
    var iconTint: AppColor = .white
    var isEnabled: Bool = true
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock (_ components: Action...) -> [Action] {
        return components
    }
}
