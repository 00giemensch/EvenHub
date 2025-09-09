import UIKit

class Constants {
    // MARK: - Colors
    struct Colors {
        struct Accent {
            static let darkCyan = UIColor(named: "Colors/Accent/DarkCyan")
            static let green = UIColor(named: "Colors/Accent/Green")
            static let orange = UIColor(named: "Colors/Accent/Orange")
            static let purple = UIColor(named: "Colors/Accent/Purple")
            static let red = UIColor(named: "Colors/Accent/Red")
            static let yellow = UIColor(named: "Colors/Accent/Yellow")
        }
        
        struct Background {
            static let black = UIColor(named: "Colors/BackgroundColor/Black")
            static let gray = UIColor(named: "Colors/BackgroundColor/Gray")
            static let secondBlack = UIColor(named: "Colors/BackgroundColor/SecondBlack")
        }
        
        struct PrimaryBlue {
            static let blue0 = UIColor(named: "Colors/PrimaryBlue/0")
            static let blue10 = UIColor(named: "Colors/PrimaryBlue/10")
            static let blue20 = UIColor(named: "Colors/PrimaryBlue/20")
            static let blue30 = UIColor(named: "Colors/PrimaryBlue/30")
            static let blue40 = UIColor(named: "Colors/PrimaryBlue/40")
            static let blue50 = UIColor(named: "Colors/PrimaryBlue/50")
        }
        
        struct SecondaryCyan {
            static let cyan0 = UIColor(named: "Colors/SecondaryCyan/0")
            static let cyan10 = UIColor(named: "Colors/SecondaryCyan/10")
            static let cyan20 = UIColor(named: "Colors/SecondaryCyan/20")
            static let cyan30 = UIColor(named: "Colors/SecondaryCyan/30")
            static let cyan40 = UIColor(named: "Colors/SecondaryCyan/40")
            static let cyan50 = UIColor(named: "Colors/SecondaryCyan/50")
        }
        
        struct TypographyColor {
            static let typographyColor0 = UIColor(named: "Colors/TypograpthyColor/0")
            static let typographyColor10 = UIColor(named: "Colors/TypograpthyColor/10")
            static let typographyColor20 = UIColor(named: "Colors/TypograpthyColor/20")
            static let typographyColor30 = UIColor(named: "Colors/TypograpthyColor/30")
            static let typographyColor40 = UIColor(named: "Colors/TypograpthyColor/40")
            static let typographyColor50 = UIColor(named: "Colors/TypograpthyColor/50")
        }
        
        static let accent = UIColor(named: "AccentColor")
    }
    
    // MARK: - Icons
    struct Icons {
        
        //MARK: Autentication Icons
        struct Autentication {
            static let eventHub = UIImage(named: "Icons/Autentication/autentication_eventHubImage")
            static let mail = UIImage(named: "Icons/Autentication/autentication_mail")
            static let passwordHidden = UIImage(named: "Icons/Autentication/autentication_password_hidden")
            static let password = UIImage(named: "Icons/Autentication/autentication_password")
            static let profile = UIImage(named: "Icons/Autentication/autentication_profile")
        }
        
        //MARK: Common Icons
        struct Common {
            static let favoriteAdd = UIImage(named: "Icons/Common/common_favorite_add")
            static let favoriteEmpty = UIImage(named: "Icons/Common/common_favorite_empty")
            static let favoriteSelected = UIImage(named: "Icons/Common/common_favorite_selected")
        }
        
        //MARK: EventDetails Icons
        struct EventDetails {
            static let date = UIImage(named: "Icons/Event Details/eventDetails_date")
            static let location = UIImage(named: "Icons/Event Details/eventDetails_location")
            static let share = UIImage(named: "Icons/Event Details/eventDetails_share")
        }
        
        //MARK: Explore Icons
        struct Explore {
            static let art = UIImage(named: "Icons/Explore/explore_art")
            static let filters = UIImage(named: "Icons/Explore/explore_filters")
            static let food = UIImage(named: "Icons/Explore/explore_food")
            static let music = UIImage(named: "Icons/Explore/explore_music")
            static let search = UIImage(named: "Icons/Explore/explore_search")
            static let sports = UIImage(named: "Icons/Explore/explore_sports")
        }
        
        //MARK: Filter Icons
        struct Filter {
            static let artFill = UIImage(named: "Icons/Filter/filter_art_fill")
            static let art = UIImage(named: "Icons/Filter/filter_art")
            static let calendar = UIImage(named: "Icons/Filter/filter_calendar")
            static let foodFill = UIImage(named: "Icons/Filter/filter_food_fill")
            static let food = UIImage(named: "Icons/Filter/filter_food")
            static let location = UIImage(named: "Icons/Filter/filter_location")
            static let musicFill = UIImage(named: "Icons/Filter/filter_music_fill")
            static let music = UIImage(named: "Icons/Filter/filter_music")
            static let range = UIImage(named: "Icons/Filter/filter_range")
            static let sportsFill = UIImage(named: "Icons/Filter/filter_sports_fill")
            static let sports = UIImage(named: "Icons/Filter/filter_sports")
        }
        
        //MARK: Map Icons
        struct Map {
            static let art = UIImage(named: "Icons/Map/map_art")
            static let currentLocation = UIImage(named: "Icons/Map/map_current_location")
            static let eventLocation = UIImage(named: "Icons/Map/map_event_location")
            static let food = UIImage(named: "Icons/Map/map_food")
            static let music = UIImage(named: "Icons/Map/map_music")
            static let sports = UIImage(named: "Icons/Map/map_sports")
        }
        
        //MARK: NavigationBar Icons
        struct NavigationBar {
            static let backBlack = UIImage(named: "Icons/NavigationBar/nav_back_black")
            static let backWhite = UIImage(named: "Icons/NavigationBar/nav_back_white")
            static let notificationFill = UIImage(named: "Icons/NavigationBar/nav_notification_fill")
            static let notification = UIImage(named: "Icons/NavigationBar/nav_notification")
            static let search = UIImage(named: "Icons/NavigationBar/nav_search")
        }
        
        //MARK: Notification Icons
        struct Notification {
            static let notification = UIImage(named: "Icons/Notification/notification_empty")
        }
        
        //MARK: Profile Icons
        struct Profile {
            static let edit = UIImage(named: "Icons/Profile/profile_edit")
            static let signOut = UIImage(named: "Icons/Profile/profile_sign_out")
        }
        
        //MARK: Search Icons
        struct Search {
            static let blue = UIImage(named: "Icons/Search/search_blue")
        }
        
        //MARK: Share Icons
        struct Share {
            static let copyLink = UIImage(named: "Icons/Share/share_copy_link")
            static let facebook = UIImage(named: "Icons/Share/share_facebook")
            static let instagram = UIImage(named: "Icons/Share/share_instagram")
            static let message = UIImage(named: "Icons/Share/share_message")
            static let messenger = UIImage(named: "Icons/Share/share_messenger")
            static let whatsApp = UIImage(named: "Icons/Share/share_whatsApp")
        }
        
        //MARK: Splash Screen Image
        static let splashScreenImage = UIImage(named: "Icons/SplashScreen/splashScreen_eventHubImage")
        
        //MARK: TabBar Icons
        struct TabBar {
            static let eventsFill = UIImage(named: "Icons/TabBar/tabBar_events_fill")
            static let events = UIImage(named: "Icons/TabBar/tabBar_events")
            static let exploreFill = UIImage(named: "Icons/TabBar/tabBar_explore_fill")
            static let explore = UIImage(named: "Icons/TabBar/tabBar_explore")
            static let favoritesFill = UIImage(named: "Icons/TabBar/tabBar_favorites_fill")
            static let favoritesSelected = UIImage(named: "Icons/TabBar/tabBar_favorites_selected")
            static let mapFill = UIImage(named: "Icons/TabBar/tabBar_map_fill")
            static let map = UIImage(named: "Icons/TabBar/tabBar_map")
            static let profileFill = UIImage(named: "Icons/TabBar/tabBar_profile_fill")
            static let profile = UIImage(named: "Icons/TabBar/tabBar_profile")
        }
        
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let book = "AirbnbCereal-Book"
        static let bold = "AirbnbCereal-Bold"
        static let black = "AirbnbCereal-Black"
        static let extraBold = "AirbnbCereal-ExtraBold"
        static let light = "AirbnbCereal-Light"
        static let medium = "AirbnbCereal-Medium"
    }
}
