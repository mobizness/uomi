//
//  Config.m


//#define SERVER_URL @"http://10.0.0.219/uomi"
#define SERVER_URL @"http://35.162.18.174/uomi"

#define API_URL (SERVER_URL @"/api")
#define API_USER_SIGNUP                 (SERVER_URL @"/api/user_signup")
#define API_USER_LOGIN                  (SERVER_URL @"/api/user_login")
#define API_SEND_PHONENUMBER            (SERVER_URL @"/api/send_phonenumber")
#define API_SEND_VERIFYCODE             (SERVER_URL @"/api/send_verifycode")
#define API_GET_CONTACTS                (SERVER_URL @"/api/get_contacts")
#define API_SEND_SPLIT                  (SERVER_URL @"/api/send_split")
#define API_GET_USERINFO                (SERVER_URL @"/api/get_userinfo")
#define API_GET_RECEIPTS                (SERVER_URL @"/api/get_receipts")
#define API_SET_PAID                    (SERVER_URL @"/api/set_paid")
#define API_SET_ALL_PAID                (SERVER_URL @"/api/set_allpaid")
#define API_SET_NUDGE                   (SERVER_URL @"/api/set_nudge")
#define API_GET_FEED                    (SERVER_URL @"/api/get_feed")
#define API_SEND_MESSAGE                (SERVER_URL @"/api/send_message")
#define API_GET_MESSAGES                (SERVER_URL @"/api/get_messages")
#define API_GET_UNREAD_MESSAGES         (SERVER_URL @"/api/get_unread_messages")
#define API_UPDATE_IMAGE                (SERVER_URL @"/api/update_profileimage")
#define API_USER_UPDATE                 (SERVER_URL @"/api/update_profile")


#define GooglePluseClientID             @"142580359742-4t4s7d8ks47sdjlt7p3jc6ssd70ppg4k.apps.googleusercontent.com"



#define MEDIA_URL (SERVER_URL @"/assets/media/")
#define MEDIA_URL_USERS (SERVER_URL @"/assets/media/users/")
#define MEDIA_URL_GROUP_PHOTOS (SERVER_URL @"/assets/media/groups/")
#define MEDIA_URL_BARK_VIDEOS (SERVER_URL @"/assets/media/bark_videos/")
#define MEDIA_URL_BARK_VIDEO_THUMBS (SERVER_URL @"/assets/media/bark_video_thumbs/")

// Settings Config

#define EXPLORE_STYLISTS_COUNT_DEFAULT @"100"
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define COLOR_DARK_BROWN            [UIColor colorWithRed:(235.0f / 255.0f) green:(133.0f / 255.0f) blue:(55.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_BLUE        [UIColor colorWithRed:(41.0f / 255.0f) green:(203.0f / 255.0f) blue:(189.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_YELLOW          [UIColor colorWithRed:(255.0f / 255.0f) green:(194.0f / 255.0f) blue:(33.0f / 255.0f) alpha:1]
#define COLOR_DARK_BLUE             [UIColor colorWithRed:(109.0f / 255.0f) green:(166.0f / 255.0f) blue:(209.0f / 255.0f) alpha:1]
#define COLOR_RIGHT_PURPLE          [UIColor colorWithRed:(172.0f / 255.0f) green:(151.0f / 255.0f) blue:(221.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_GREEN           [UIColor colorWithRed:(122.0f / 255.0f) green:(223.0f / 255.0f) blue:(145.0f / 255.0f) alpha:1]
#define COLOR_LIHGT_BROWN           [UIColor colorWithRed:(233.0f / 255.0f) green:(167.0f / 255.0f) blue:(116.0f / 255.0f) alpha:1]
#define COLOR_DARK_GREEN            [UIColor colorWithRed:(142.0f / 255.0f) green:(199.0f / 255.0f) blue:(135.0f / 255.0f) alpha:1]

#define COLOR_DARK_GRAY             [UIColor colorWithRed:(255.0f / 255.0f) green:(255.0f / 255.0f) blue:(135.0f / 255.0f) alpha:0.4]
#define COLOR_BROWN            [UIColor colorWithRed:(231.0f / 255.0f) green:(112.0f / 255.0f) blue:(78.0f / 255.0f) alpha:1]
#define COLOR_GRAY            [UIColor colorWithRed:(109.0f / 255.0f) green:(120.0f / 255.0f) blue:(128.0f / 255.0f) alpha:1]
#define COLOR_GRAY2            [UIColor colorWithRed:(73.0f / 255.0f) green:(73.0f / 255.0f) blue:(73.0f / 255.0f) alpha:1]
#define COLOR_GRAY3            [UIColor colorWithRed:(250.0f / 255.0f) green:(250.0f / 255.0f) blue:(250.0f / 255.0f) alpha:1]


#define M_PI        3.14159265358979323846264338327950288

#define FONT_BLAMEBOT(s) [UIFont fontWithName:@"Blambot Custom" size:s]
#define FONT_HELVETICA_NEUE_LIGHT(s) [UIFont fontWithName:@"Helvetica Neue Light" size:s]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
