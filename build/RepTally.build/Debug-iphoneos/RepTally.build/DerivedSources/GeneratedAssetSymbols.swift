import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "BackgroundColour" asset catalog color resource.
    static let backgroundColour = DeveloperToolsSupport.ColorResource(name: "BackgroundColour", bundle: resourceBundle)

    /// The "ButtonColour" asset catalog color resource.
    static let buttonColour = DeveloperToolsSupport.ColorResource(name: "ButtonColour", bundle: resourceBundle)

    /// The "CardColour" asset catalog color resource.
    static let cardColour = DeveloperToolsSupport.ColorResource(name: "CardColour", bundle: resourceBundle)

    /// The "NavBarColour" asset catalog color resource.
    static let navBarColour = DeveloperToolsSupport.ColorResource(name: "NavBarColour", bundle: resourceBundle)

    /// The "OverlayMenuColour" asset catalog color resource.
    static let overlayMenuColour = DeveloperToolsSupport.ColorResource(name: "OverlayMenuColour", bundle: resourceBundle)

    /// The "SafeBlack" asset catalog color resource.
    static let safeBlack = DeveloperToolsSupport.ColorResource(name: "SafeBlack", bundle: resourceBundle)

    /// The "SafeWhite" asset catalog color resource.
    static let safeWhite = DeveloperToolsSupport.ColorResource(name: "SafeWhite", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "BackgroundColour" asset catalog color.
    static var backgroundColour: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .backgroundColour)
#else
        .init()
#endif
    }

    /// The "ButtonColour" asset catalog color.
    static var buttonColour: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .buttonColour)
#else
        .init()
#endif
    }

    /// The "CardColour" asset catalog color.
    static var cardColour: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cardColour)
#else
        .init()
#endif
    }

    /// The "NavBarColour" asset catalog color.
    static var navBarColour: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .navBarColour)
#else
        .init()
#endif
    }

    /// The "OverlayMenuColour" asset catalog color.
    static var overlayMenuColour: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .overlayMenuColour)
#else
        .init()
#endif
    }

    /// The "SafeBlack" asset catalog color.
    static var safeBlack: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .safeBlack)
#else
        .init()
#endif
    }

    /// The "SafeWhite" asset catalog color.
    static var safeWhite: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .safeWhite)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "BackgroundColour" asset catalog color.
    static var backgroundColour: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .backgroundColour)
#else
        .init()
#endif
    }

    /// The "ButtonColour" asset catalog color.
    static var buttonColour: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .buttonColour)
#else
        .init()
#endif
    }

    /// The "CardColour" asset catalog color.
    static var cardColour: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .cardColour)
#else
        .init()
#endif
    }

    /// The "NavBarColour" asset catalog color.
    static var navBarColour: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .navBarColour)
#else
        .init()
#endif
    }

    /// The "OverlayMenuColour" asset catalog color.
    static var overlayMenuColour: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .overlayMenuColour)
#else
        .init()
#endif
    }

    /// The "SafeBlack" asset catalog color.
    static var safeBlack: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .safeBlack)
#else
        .init()
#endif
    }

    /// The "SafeWhite" asset catalog color.
    static var safeWhite: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .safeWhite)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "BackgroundColour" asset catalog color.
    static var backgroundColour: SwiftUI.Color { .init(.backgroundColour) }

    /// The "ButtonColour" asset catalog color.
    static var buttonColour: SwiftUI.Color { .init(.buttonColour) }

    /// The "CardColour" asset catalog color.
    static var cardColour: SwiftUI.Color { .init(.cardColour) }

    /// The "NavBarColour" asset catalog color.
    static var navBarColour: SwiftUI.Color { .init(.navBarColour) }

    /// The "OverlayMenuColour" asset catalog color.
    static var overlayMenuColour: SwiftUI.Color { .init(.overlayMenuColour) }

    /// The "SafeBlack" asset catalog color.
    static var safeBlack: SwiftUI.Color { .init(.safeBlack) }

    /// The "SafeWhite" asset catalog color.
    static var safeWhite: SwiftUI.Color { .init(.safeWhite) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "BackgroundColour" asset catalog color.
    static var backgroundColour: SwiftUI.Color { .init(.backgroundColour) }

    /// The "ButtonColour" asset catalog color.
    static var buttonColour: SwiftUI.Color { .init(.buttonColour) }

    /// The "CardColour" asset catalog color.
    static var cardColour: SwiftUI.Color { .init(.cardColour) }

    /// The "NavBarColour" asset catalog color.
    static var navBarColour: SwiftUI.Color { .init(.navBarColour) }

    /// The "OverlayMenuColour" asset catalog color.
    static var overlayMenuColour: SwiftUI.Color { .init(.overlayMenuColour) }

    /// The "SafeBlack" asset catalog color.
    static var safeBlack: SwiftUI.Color { .init(.safeBlack) }

    /// The "SafeWhite" asset catalog color.
    static var safeWhite: SwiftUI.Color { .init(.safeWhite) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

