//
//  iPongAppDelegate.h
//  iPong
//
//  Created by Pieter Joost van de Sande on 3/21/11.
//  Copyright Born2code.net 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface iPongAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
