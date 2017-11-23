//
//  MyConstants.h
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#ifndef EulersBridge_MyConstants_h
#define EulersBridge_MyConstants_h


#define SAMPLE_DATA NO
#define WIDTH_OF_SCREEN 320
#define HEIGHT_OF_SCREEN 568

#define DEFAULT_BLUR_RADIUS 5.0

#define SERVER_TOKEN @"6F87C408-98E2-403F-BD9F-D60DB6328BEP"
#define SERVER_URL @"https://eulersbridge.meteor.com"

//#define SNSPlatformApplicationArn @"arn:aws:sns:ap-southeast-2:715927704730:app/APNS_SANDBOX/isegoria_dev"
#define SNSPlatformApplicationArn @"arn:aws:sns:ap-southeast-2:715927704730:app/APNS/isegoria_prod"


#define PROD_URL @"http://eulersbridge.com:8080/dbInterface/api"
//#define TESTING_URL @"http://172.20.10.2:8080/api"
#define TESTING_URL @"http://54.79.70.241:8080/dbInterface/api"
#define TESTING_USERNAME [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]
#define TESTING_PASSWORD [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]
#define TESTING_INSTITUTION_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"]

#define S3_BUCKET_KEY @"isegoriauserpics"
#define S3_URL_PREFIX @"https://s3.amazonaws.com/isegoriauserpics/"

#define PERSON_NAME_PROPERTY @"name"
#define PERSON_EMAILS_PROPERTY @"emails"
#define PERSON_PHONES_PROPERTY @"phones"

#define LOGIN_ERROR_BAD_CREDENTIALS @"HTTP Status 401 - Bad credentials\n"
#define LOGIN_ERROR_USER_UNVERIFIED @"HTTP Status 401 - User is disabled\n"

#define SECTION_TITLE_VIEW_HEIGHT 32
#define SECTION_TITLE_VIEW_TITLE_X_OFFSET 10
#define SECTION_TITLE_VIEW_TITLE_Y_OFFSET 3

#define FONT_SIZE_CELL_TITLE_LARGE 18
#define FONT_SIZE_CELL_TITLE_SMALL 14
#define FONT_SIZE_CELL_DATE_LARGE 14
#define FONT_SIZE_CELL_DATE_SMALL 9

#define FONT_SIZE_ARTICLE_TITLE 24
#define FONT_SIZE_ARTICLE_AUTHOR 14
#define FONT_SIZE_ARTICLE_DATE 9
#define FONT_SIZE_ARTICLE_BODY 14
#define FONT_SIZE_EVENT_DATE 14

#define FONT_SIZE_BUTTON 15

#define FONT_SIZE_VOLUNTEER_TITLE 15
#define FONT_SIZE_VOLUNTEER_POSITION 14
#define FONT_SIZE_VOLUNTEER_DESCRIPTION 14

#define SPACING_FEED 8
#define SPACING_PHOTO_GRID 2

#define SPACING_PHOTO_DETAIL 20

#define TEXT_BODY_INSET 15

#define ISEGORIA_COLOR_BLUE [UIColor colorWithRed:47.0/255.0 green:123.0/255.0 blue:212.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_GREY [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:144.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_GREEN [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_SIGNUP_GREEN [UIColor colorWithRed:96.0/255.0 green:153.0/255.0 blue:83.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_SIGNUP_RED [UIColor colorWithRed:255.0/255.0 green:109.0/255.0 blue:101.0/255.0 alpha:1.0]
#define ONE_PIXEL_GREY [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]
#define PERSONALITY_LABEL_GREY [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]
#define ISEGORIA_DARK_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]
#define ISEGORIA_LIGHT_GREY [UIColor colorWithRed:134.0/255.0 green:148.0/255.0 blue:163.0/255.0 alpha:1.0]
#define ISEGORIA_ULTRA_LIGHT_GREY [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]
#define ISEGORIA_BORDER_GREY [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]

#define ISEGORIA_CELL_MASK_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]
#define ISEGORIA_TEXT_BODY_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]
#define ISEGORIA_TEXT_TITLE_GREY [UIColor colorWithRed:107.0/255.0 green:122.0/255.0 blue:138.0/255.0 alpha:1.0]

#define ISEGORIA_CIRCLE_PROGRESS_GREY [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger, EBFeedCellType) {
    EBFeedCellTypeSquare,
    EBFeedCellTypeLarge,
    EBFeedCellTypeSmall
};

typedef NS_ENUM(NSInteger, EBFeedDetail) {
    EBFeedDetailNews,
    EBFeedDetailEvent,
    EBFeedDetailPhoto
};

typedef NS_ENUM(NSInteger, EBContentViewType) {
    EBContentViewTypeNews,
    EBContentViewTypeEvent,
    EBContentViewTypePhoto,
    EBContentViewTypeCandidateDescription,
    EBContentViewTypeTicketProfile,
    EBContentViewTypeProfile
};

typedef NS_ENUM(NSInteger, EBBadgesViewType) {
    EBBadgesViewTypeSmall,
    EBBadgesViewTypeLarge,
    EBBadgesViewTypeDetail
};

typedef NS_ENUM(NSInteger, EBTasksViewType) {
    EBTasksViewTypeSmall,
    EBTasksViewTypeDetail
};

typedef NS_ENUM(NSInteger, EBCandidateFilter) {
    EBCandidateFilterByPosition,
    EBCandidateFilterByTicket,
    EBCandidateFilterAll
};

typedef NS_ENUM(NSInteger, EBCandidateViewType) {
    EBCandidateViewTypeTicketProfile,
    EBCandidateViewTypePositionProfile,
    EBCandidateViewTypeAll,
};

typedef NS_ENUM(NSInteger, EBProfilePhotoType) {
    EBProfilePhotoTypeBackground,
    EBProfilePhotoTypeProfile
};

typedef NS_ENUM(NSInteger, EBTaskType) {
    EBTaskTypeRecurring,
    EBTaskTypeOneOff
};

#endif
