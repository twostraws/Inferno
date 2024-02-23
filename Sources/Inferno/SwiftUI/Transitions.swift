//
// Transitions.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

// IMPORTANT:
// This file contains all the SwiftUI transitions for the
// shaders included with Inferno. If you want to use one
// of our transitions, you need to copy this Swift file
// into your project alongside the Metal files for your
// chosen transitions.

import SwiftUI

/// A transition where many circles grow upwards to reveal the new content.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct CircleTransition: ViewModifier {
    /// How big to make the circles.
    var size = 20.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .colorEffect(
                InfernoShaderLibrary.circleTransition(
                    .float(progress),
                    .float(size)
                )
            )
    }
}

/// A transition where many circles grow upwards to reveal the new content,
/// with the circles moving outwards from the top-left edge.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct CircleWaveTransition: ViewModifier {
    /// How big to make the circles.
    var size = 20.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(
                        InfernoShaderLibrary.circleWaveTransition(
                            .float2(proxy.size),
                            .float(progress),
                            .float(size)
                        )
                    )
            }
    }
}

/// A transition where many diamonds grow upwards to reveal the new content.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct DiamondTransition: ViewModifier {
    /// How big to make the diamonds.
    var size = 20.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .colorEffect(
                InfernoShaderLibrary.diamondTransition(
                    .float(progress),
                    .float(size)
                )
            )
    }
}

/// A transition where many diamonds grow upwards to reveal the new content,
/// with the diamonds moving outwards from the top-left edge.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct DiamondWaveTransition: ViewModifier {
    /// How big to make the diamonds.
    var size = 20.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(
                        InfernoShaderLibrary.diamondWaveTransition(
                            .float2(proxy.size),
                            .float(progress),
                            .float(size)
                        )
                    )
            }
    }
}


/// A Metal-powered layer effect transition that needs to know the
/// view's size. You probably don't want to use this directly, and
/// should instead use one of the `AnyTransition` extensions.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct InfernoTransition: ViewModifier {
    /// The name of the shader function we're rendering.
    var name: String

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .layerEffect(
                        InfernoShaderLibrary[dynamicMember: name](
                            .float2(proxy.size),
                            .float(progress)
                        ), maxSampleOffset: .zero)
            }
    }
}

/// A Metal-powered distortion effect transition that needs to know
/// the view's size. You probably don't want to use this directly, and
/// should instead use one of the `AnyTransition` extensions.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct InfernoDistortionTransition: ViewModifier {
    /// The name of the shader function we're rendering.
    var name: String

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .distortionEffect(
                        InfernoShaderLibrary[dynamicMember: name](
                            .float2(proxy.size),
                            .float(progress)
                        ), maxSampleOffset: .zero)
            }
    }
}

/// A transition that causes the incoming and outgoing views to become
/// increasingly pixellated, then return to their normal state. While this
/// happens, the old view fades out and the new one fades in.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct PixellateTransition: ViewModifier {
    /// How large the pixels should be.
    var squares = 10.0

    /// How many steps to use for the animation. Lower values make the
    /// pixels jump in more noticeable size increments, which creates
    /// very interesting retro effects.
    var steps = 60.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .layerEffect(
                        InfernoShaderLibrary.pixellate(
                            .float2(proxy.size),
                            .float(progress),
                            .float(squares),
                            .float(steps)
                        ), maxSampleOffset: .zero)
            }
    }
}

/// A transition where views are twirled from the center and faded out.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct SwirlTransition: ViewModifier {
    /// How large the swirl should be relative to the view it's transitioning.
    var radius = 0.5

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .layerEffect(
                        InfernoShaderLibrary.swirl(
                            .float2(proxy.size),
                            .float(progress),
                            .float(radius)
                        ), maxSampleOffset: .zero)
            }
    }
}

/// A transition where views are removed blowing streaks from the right edge.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct WindTransition: ViewModifier {
    /// How long the streaks should be, relative to the view's width.
    var size = 0.2

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .layerEffect(
                        InfernoShaderLibrary.windTransition(
                            .float2(proxy.size),
                            .float(progress),
                            .float(size)
                        ), maxSampleOffset: .zero)
            }
    }
}

/// A collection of wrappers to make Inferno transitions easier to use.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
extension AnyTransition {
    /// A transition that makes a variety of circles simultaneously zoom up
    ///  across the screen.
    ///
    /// - Parameter size: The size of the circles.
    public static func circles(size: Double = 20) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: CircleTransition(size: size, progress: 0),
                identity: CircleTransition(size: size, progress: 1)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }

    /// A transition that makes a variety of circles zoom up across the screen,
    /// based on their X/Y position.
    ///
    /// - Parameter size: The size of the circles.
    public static func circleWave(size: Double = 20) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: CircleWaveTransition(size: size, progress: 0),
                identity: CircleWaveTransition(size: size, progress: 1)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }

    /// A transition that makes a variety of diamonds simultaneously zoom up
    ///  across the screen.
    /// - Parameter size: The size of the diamonds.
    public static func diamonds(size: Double = 20) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: DiamondTransition(size: size, progress: 0),
                identity: DiamondTransition(size: size, progress: 1)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }

    /// A transition that makes a variety of circles zoom up across the screen,
    /// based on their X/Y position.
    ///
    /// - Parameter size: The size of the diamonds.
    public static func diamondWave(size: Double = 20) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: DiamondWaveTransition(size: size, progress: 0),
                identity: DiamondWaveTransition(size: size, progress: 1)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }

    /// A transition that stretches a view from one edge to the other, while
    /// also fading it out. This one is for left-to-right transitions.
    public static let crosswarpLTR: AnyTransition = .asymmetric(
        insertion: .modifier(
            active: InfernoTransition(name: "crosswarpLTRTransition", progress: 1),
            identity: InfernoTransition(name: "crosswarpLTRTransition", progress: 0)
        ),
        removal: .modifier(
            active: InfernoTransition(name: "crosswarpRTLTransition", progress: 1),
            identity: InfernoTransition(name: "crosswarpRTLTransition", progress: 0)
        )
    )

    /// A transition that stretches a view from one edge to the other, while
    /// also fading it out. This one is for right-to-left transitions.
    public static let crosswarpRTL: AnyTransition = .asymmetric(
        insertion: .modifier(
            active: InfernoTransition(name: "crosswarpRTLTransition", progress: 1),
            identity: InfernoTransition(name: "crosswarpRTLTransition", progress: 0)
        ),
        removal: .modifier(
            active: InfernoTransition(name: "crosswarpLTRTransition", progress: 1),
            identity: InfernoTransition(name: "crosswarpLTRTransition", progress: 0)
        )
    )

    /// A transition that causes the incoming and outgoing views to become
    /// increasingly pixellated, then return to their normal state. While this
    /// happens, the old view fades out and the new one fades in.
    /// - Parameters:
    ///   - squares: How many pixel squares to create.
    ///   - steps: How many animation steps to use; anything >= 60 looks smooth.
    public static func pixellate(squares: Double = 20, steps: Double = 60) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: PixellateTransition(squares: squares, steps: steps, progress: 1),
                identity: PixellateTransition(squares: squares, steps: steps, progress: 0)
            ),
            removal: .modifier(
                active: PixellateTransition(squares: squares, steps: steps, progress: 1),
                identity: PixellateTransition(squares: squares, steps: steps, progress: 0)
            )
        )
    }

    /// A transition that causes the incoming and outgoing views to become
    /// sucked in and out of the top right corner.
    public static func genie() -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: InfernoDistortionTransition(name: "genieTransition", progress: 1),
                identity:  InfernoDistortionTransition(name: "genieTransition", progress: 0)
            ),
            removal: .modifier(
                active:  InfernoDistortionTransition(name: "genieTransition", progress: 1),
                identity:  InfernoDistortionTransition(name: "genieTransition", progress: 0)
            )
        )
    }

    /// A transition that creates an old-school radial wipe, starting from straight up.
    public static let radial: AnyTransition = .asymmetric(
        insertion: .modifier(
            active: InfernoTransition(name: "radialTransition", progress: 1),
            identity: InfernoTransition(name: "radialTransition", progress: 0)
        ),
        removal: .scale(scale: 1 + Double.ulpOfOne)
    )

    /// A transition that increasingly twists the contents of the incoming and outgoing
    /// views, then untwists them to complete the transition. As this happens the two
    /// views fade to move smoothly from one to the other.
    ///
    /// - Parameter radius: How much of the view to swirl, in the range 0 to 1. Start with 0.5 and experiment.
    public static func swirl(radius: Double = 0.5) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: SwirlTransition(radius: radius, progress: 1),
                identity: SwirlTransition(radius: radius, progress: 0)
            ),
            removal: .modifier(
                active: SwirlTransition(radius: radius, progress: 1),
                identity: SwirlTransition(radius: radius, progress: 0)
            )
        )
    }

    /// A transition that makes it look like the pixels of one image are being blown
    /// away horizontally.
    ///
    /// - Parameter size: How big the wind streaks should be, relative to the view's width.
    public static func wind(size: Double = 0.2) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: WindTransition(size: size, progress: 1),
                identity: WindTransition(size: size, progress: 0)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }
}
