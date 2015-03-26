//
//  ADPageControl.h
//  ADCustomPageControl
//
//  Created by Aditya Deshmane on 26/03/15.
//  Copyright (c) 2015 Aditya Deshmane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADPageModel.h"

@protocol ADPageControlDelegate <NSObject>

-(UIViewController *)getViewControllerForPageModel:(ADPageModel *) pageModel;

@end

@interface ADPageControl : UIViewController

@property(readwrite) id<ADPageControlDelegate> delegateADPageControl;
@property(readwrite) NSMutableArray *arrPageModel;
@property(readwrite) int iFirstVisiblePageNumber;
@property(readwrite) UIColor *colorTitleBarBackground;
@property(readwrite) UIColor *colorTabText;
@property(readwrite) UIColor *colorPageIndicator;
@property(readwrite) UIColor *colorPageOverscrollBackground;

@end
