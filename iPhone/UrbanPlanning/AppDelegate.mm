/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "AppDelegate.h"

#import "GAI.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "UserInfoTableViewController.h"

#define ANALYTICS @"UA-51367576-1"
#define GOOGLE_MAPS_API_KEY @"AIzaSyCHmTVLOovMkvnc2dDHlE9424GNs8UW3fc"

@interface AppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize entityData, permissions, userID, modelsPaths, basque;

- (void)gotAnonymousUser:(BOOL)success FromSettings:(BOOL)fromSettings
{
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    NSString *name = [defaults objectForKey:DEFAULTS_NAME];
//    NSString *res = [defaults objectForKey:DEFAULTS_GORDEXOLA_RESIDENT];
    NSString *zone = [defaults objectForKey:DEFAULTS_RESIDENCE_ZONE];
    if(![defaults objectForKey:@"basque"]){
        [defaults setObject:@"N" forKey:@"basque"];
        self.basque = NO;
        NSLog(@"basque not initialized");
    }
    else
    {
        if([[defaults objectForKey:@"basque"] isEqualToString:@"N"]){
            self.basque = NO;
            NSLog(@"basque is N");
        }
        else{
            self.basque = YES;
            NSLog(@"basque is %@", [defaults objectForKey:@"basque"]);
//            NSLog(@"basque is else");
        }
        
    }
    if(name && zone)
    {
        FrontViewController *frontViewController = [[FrontViewController alloc] init];
        RearViewController *rearViewController = [[RearViewController alloc] init];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
        rightViewController.view.backgroundColor = [UIColor greenColor];
        revealController.rightViewController = rightViewController;
        self.viewController = revealController;
        self.window.rootViewController = self.viewController;
    }
    else
    {
        UserInfoTableViewController *userInfoTableViewController = [[UserInfoTableViewController alloc] initWithNibName:@"UserInfoTableViewController" bundle:nil];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:userInfoTableViewController];
        
        self.window.rootViewController = navCon;
    }
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    [[GAI sharedInstance] trackerWithTrackingId:ANALYTICS];
//
//	FrontViewController *frontViewController = [[FrontViewController alloc] init];
//	RearViewController *rearViewController = [[RearViewController alloc] init];
//	
//	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
//    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
//	
//	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//    revealController.delegate = self;
//    
//    
//    RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
//    rightViewController.view.backgroundColor = [UIColor greenColor];
//    
//    revealController.rightViewController = rightViewController;
    
    //revealController.bounceBackOnOverdraw=NO;
    //revealController.stableDragOnOverdraw=YES;
    
//	self.viewController = revealController;
    
    
//	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
    [GMSServices provideAPIKey:GOOGLE_MAPS_API_KEY];
    self.entityData = [[AREntityData alloc] init];
    self.modelsPaths = [[NSMutableDictionary alloc] init];
	return YES;
}

#define LogDelegates 1

#if LogDelegates
- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}


- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
//    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
//    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
//    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
{
//    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
{
//    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress
{
//    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{
//    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress
{
//    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

#endif









@end