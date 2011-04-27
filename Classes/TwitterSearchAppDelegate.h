//
//  TwitterSearchAppDelegate.h
//  TwitterSearch
//
//  Created by Ahmet Ardal on 4/26/11.
//  Copyright 2011 Ahmet Ardal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterSearchViewController;

@interface TwitterSearchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TwitterSearchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TwitterSearchViewController *viewController;

@end

