//
//  ADPageModel.h
//  ADCustomPageControl
//
//  Created by Aditya Deshmane on 26/03/15.
//  Copyright (c) 2015 Aditya Deshmane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ADPageModel : NSObject

@property(readwrite) int iPageNumber;
@property(readwrite) NSString *strPageTitle;
@property(readwrite) UIViewController *viewController;
@property(readwrite) BOOL bShouldLazyLoad;

@end
