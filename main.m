//
//  main.m
//  iPong
//
//  Created by Pieter Joost van de Sande on 3/21/11.
//  Copyright Born2code.net 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"iPongAppDelegate");
	[pool release];
	return retVal;
}
