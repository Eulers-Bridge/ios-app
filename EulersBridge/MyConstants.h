//
//  MyConstants.h
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#ifndef EulersBridge_MyConstants_h
#define EulersBridge_MyConstants_h


#define WIDTH_OF_SCREEN 320
#define HEIGHT_OF_SCREEN 568

#define SERVER_TOKEN @"6F87C408-98E2-403F-BD9F-D60DB6328BEP"
#define SERVER_URL @"https://eulersbridge.meteor.com"

#define TESTING_URL @"http://www.eulersbridge.com:8080/dbInterface/api"
#define TESTING_USERNAME @"greg.newitt@unimelb.edu.au"
#define TESTING_PASSWORD @"test123"
#define TESTING_INSTITUTION_ID @"26"

#define PERSON_NAME_PROPERTY @"name"
#define PERSON_EMAILS_PROPERTY @"emails"
#define PERSON_PHONES_PROPERTY @"phones"


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

#define ISEGORIA_COLOR_BLUE [UIColor colorWithRed:47.0/255.0 green:123.0/255.0 blue:212.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_GREY [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:144.0/255.0 alpha:1.0]
#define ISEGORIA_COLOR_GREEN [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0]
#define ONE_PIXEL_GREY [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]
#define PERSONALITY_LABEL_GREY [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]
#define ISEGORIA_DARK_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]
#define ISEGORIA_LIGHT_GREY [UIColor colorWithRed:134.0/255.0 green:148.0/255.0 blue:163.0/255.0 alpha:1.0]
#define ISEGORIA_ULTRA_LIGHT_GREY [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]
#define ISEGORIA_BORDER_GREY [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]

#define ISEGORIA_CELL_MASK_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]
#define ISEGORIA_TEXT_BODY_GREY [UIColor colorWithRed:49.0/255.0 green:62.0/255.0 blue:77.0/255.0 alpha:1.0]

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

typedef NS_ENUM(NSInteger, EBProfilePhotoType) {
    EBProfilePhotoTypeBackground,
    EBProfilePhotoTypeProfile
};

typedef NS_ENUM(NSInteger, EBTaskType) {
    EBTaskTypeRecurring,
    EBTaskTypeOneOff
};

#endif
