//
//  MobileDesignerAppDelegate.h
//  MobileDesigner
//
//  Created by Dan Huang on 12/2/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileDesignerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

