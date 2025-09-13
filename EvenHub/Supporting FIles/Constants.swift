import UIKit

class Constants {
    
    //MARK: - Names & Placeholders
    static let appName = "EventHub"
    static let loginPlaceholder = "abc@email.com"
    static let passwordPlaceholder = "Your password"
    static let passwordConfirmationPlaceholder = "Confirm your password"
    
    // MARK: - Colors
    struct Colors {
        struct Accent {
            static let darkCyan = UIColor(named: "accent_darkCyan")
            static let green = UIColor(named: "accent_green")
            static let orange = UIColor(named: "accent_orange")
            static let purple = UIColor(named: "accent_purple")
            static let red = UIColor(named: "accent_red")
            static let yellow = UIColor(named: "accent_yellow")
        }
        
        struct Background {
            static let black = UIColor(named: "background_black")
            static let gray = UIColor(named: "background_gray")
            static let secondBlack = UIColor(named: "background_secondBlack")
            static let backgroundBlue = UIColor().hex(0x4A43EC)
            static let exploreBackground = UIColor().hex(0xFAFAFC)
        }
        
        struct PrimaryBlue {
            static let blue0 = UIColor(named: "blue0")
            static let blue10 = UIColor(named: "blue10")
            static let blue20 = UIColor(named: "blue20")
            static let blue30 = UIColor(named: "blue30")
            static let blue40 = UIColor(named: "blue40")
            static let blue50 = UIColor(named: "blue50")
        }
        
        struct SecondaryCyan {
            static let cyan0 = UIColor(named: "cyan0")
            static let cyan10 = UIColor(named: "cyan10")
            static let cyan20 = UIColor(named: "cyan20")
            static let cyan30 = UIColor(named: "cyan30")
            static let cyan40 = UIColor(named: "cyan40")
            static let cyan50 = UIColor(named: "cyan50")
        }
        
        struct TypographyColor {
            static let typographyColor0 = UIColor(named: "color0")
            static let typographyColor10 = UIColor(named: "color10")
            static let typographyColor20 = UIColor(named: "color20")
            static let typographyColor30 = UIColor(named: "color30")
            static let typographyColor40 = UIColor(named: "color40")
            static let typographyColor50 = UIColor(named: "color50")
        }
    }
    
    // MARK: - Icons
    struct Icons {
        
        //MARK: Autentication Icons
        struct Authentication {
            static let eventHub = UIImage(named: "authentication_eventHubImage")
            static let mail = UIImage(named: "authentication_mail")
            static let passwordHidden = UIImage(named: "authentication_password_hidden")
            static let password = UIImage(named: "authentication_password")
            static let profile = UIImage(named: "authentication_profile")
        }
        
        //MARK: Common Icons
        struct Common {
            static let favoriteAdd = UIImage(named: "common_favorite_add")
            static let favoriteEmpty = UIImage(named: "common_favorite_empty")
            static let favoriteSelected = UIImage(named: "common_favorite_selected")
            static let arrowWhiteRight = UIImage(named: "common_arrow_white_right")
        }
        
        //MARK: EventDetails Icons
        struct EventDetails {
            static let date = UIImage(named: "eventDetails_date")
            static let location = UIImage(named: "eventDetails_location")
            static let share = UIImage(named: "eventDetails_share")
        }
        
        //MARK: Explore Icons
        struct Explore {
            static let art = UIImage(named: "explore_art")
            static let filters = UIImage(named: "explore_filters")
            static let food = UIImage(named: "explore_food")
            static let music = UIImage(named: "explore_music")
            static let search = UIImage(named: "explore_search")
            static let sports = UIImage(named: "explore_sports")
        }
        
        //MARK: Filter Icons
        struct Filter {
            static let artFill = UIImage(named: "filter_art_fill")
            static let art = UIImage(named: "filter_art")
            static let calendar = UIImage(named: "filter_calendar")
            static let foodFill = UIImage(named: "filter_food_fill")
            static let food = UIImage(named: "filter_food")
            static let location = UIImage(named: "filter_location")
            static let musicFill = UIImage(named: "filter_music_fill")
            static let music = UIImage(named: "filter_music")
            static let range = UIImage(named: "filter_range")
            static let sportsFill = UIImage(named: "filter_sports_fill")
            static let sports = UIImage(named: "filter_sports")
        }
        
        //MARK: Map Icons
        struct Map {
            static let art = UIImage(named: "map_art")
            static let currentLocation = UIImage(named: "map_current_location")
            static let eventLocation = UIImage(named: "map_event_location")
            static let food = UIImage(named: "map_food")
            static let music = UIImage(named: "map_music")
            static let sports = UIImage(named: "map_sports")
        }
        
        //MARK: NavigationBar Icons
        struct NavigationBar {
            static let backBlack = UIImage(named: "nav_back_black")
            static let backWhite = UIImage(named: "nav_back_white")
            static let notificationFill = UIImage(named: "nav_notification_fill")
            static let notification = UIImage(named: "nav_notification")
            static let search = UIImage(named: "nav_search")
        }
        
        //MARK: Notification Icons
        struct Notification {
            static let notification = UIImage(named: "notification_empty")
        }
        
        //MARK: Profile Icons
        struct Profile {
            static let edit = UIImage(named: "profile_edit")
            static let signOut = UIImage(named: "profile_sign_out")
        }
        
        //MARK: Search Icons
        struct Search {
            static let blue = UIImage(named: "search_blue")
        }
        
        //MARK: Share Icons
        struct Share {
            static let copyLink = UIImage(named: "share_copy_link")
            static let facebook = UIImage(named: "share_facebook")
            static let instagram = UIImage(named: "share_instagram")
            static let message = UIImage(named: "share_message")
            static let messenger = UIImage(named: "share_messenger")
            static let whatsApp = UIImage(named: "share_whatsApp")
        }
        
        //MARK: Splash Screen Image
        static let splashScreenImage = UIImage(named: "splashScreen_eventHubImage")
        
        //MARK: TabBar Icons
        struct TabBar {
            static let eventsFill = UIImage(named: "tabBar_events_fill")
            static let events = UIImage(named: "tabBar_events")
            static let exploreFill = UIImage(named: "tabBar_explore_fill")
            static let explore = UIImage(named: "tabBar_explore")
            static let favoritesFill = UIImage(named: "tabBar_favorites_fill")
            static let favoritesSelected = UIImage(named: "tabBar_favorites_selected")
            static let mapFill = UIImage(named: "tabBar_map_fill")
            static let map = UIImage(named: "tabBar_map")
            static let profileFill = UIImage(named: "tabBar_profile_fill")
            static let profile = UIImage(named: "tabBar_profile")
        }
        
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let book = "AirbnbCereal_W_Bk"
        static let bold = "AirbnbCereal_W_Bd"
        static let black = "AirbnbCereal_W_Blk"
        static let extraBold = "AirbnbCereal_W_XBd"
        static let light = "AirbnbCereal_W_Lt"
        static let medium = "AirbnbCereal_W_Md"
        
        static func attributedString(for text: String, font: String, fontSize: CGFloat, letterSpacing: CGFloat = 0) -> NSAttributedString {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: font, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
                .kern: letterSpacing
            ]
            
            return NSAttributedString(string: text, attributes: attributes)
        }
    }

}
