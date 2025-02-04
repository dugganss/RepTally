#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"uk.ac.chester.RepTally";

/// The "BackgroundColour" asset catalog color resource.
static NSString * const ACColorNameBackgroundColour AC_SWIFT_PRIVATE = @"BackgroundColour";

/// The "ButtonColour" asset catalog color resource.
static NSString * const ACColorNameButtonColour AC_SWIFT_PRIVATE = @"ButtonColour";

/// The "CardColour" asset catalog color resource.
static NSString * const ACColorNameCardColour AC_SWIFT_PRIVATE = @"CardColour";

/// The "NavBarColour" asset catalog color resource.
static NSString * const ACColorNameNavBarColour AC_SWIFT_PRIVATE = @"NavBarColour";

/// The "OverlayMenuColour" asset catalog color resource.
static NSString * const ACColorNameOverlayMenuColour AC_SWIFT_PRIVATE = @"OverlayMenuColour";

/// The "SafeBlack" asset catalog color resource.
static NSString * const ACColorNameSafeBlack AC_SWIFT_PRIVATE = @"SafeBlack";

/// The "SafeWhite" asset catalog color resource.
static NSString * const ACColorNameSafeWhite AC_SWIFT_PRIVATE = @"SafeWhite";

#undef AC_SWIFT_PRIVATE
