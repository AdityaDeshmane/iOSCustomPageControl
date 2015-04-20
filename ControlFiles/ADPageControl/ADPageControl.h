//    The MIT License (MIT)
//
//    Copyright (c) 2015 Aditya Deshmane
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


#import <UIKit/UIKit.h>
#import "ADPageModel.h"

@protocol ADPageControlDelegate <NSObject>

@optional
-(UIViewController *)adPageControlGetViewControllerForPageModel:(ADPageModel *) pageModel;
-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage;

@end

@interface ADPageControl : UIViewController

@property(readwrite) id<ADPageControlDelegate> delegateADPageControl;

//Data
@property(readwrite) NSMutableArray *arrPageModel;//Only one compulsory parameter, rest all have default values

//Initial visible page
@property(readwrite) int            iFirstVisiblePageNumber;

//Color theme
@property(readwrite) UIColor        *colorTitleBarBackground;
@property(readwrite) UIColor        *colorTabText;
@property(readwrite) UIColor        *colorPageIndicator;
@property(readwrite) UIColor        *colorPageOverscrollBackground;

//UI Size related customisation
@property(readwrite) int            iTitleViewHeight;
@property(readwrite) int            iPageIndicatorHeight;
@property(readwrite) UIFont         *fontTitleTabText;

//Bounce effect on/off
@property(readwrite) BOOL           bEnablePagesEndBounceEffect;
@property(readwrite) BOOL           bEnableTitlesEndBounceEffect;

//Title tabview show indicator when more tabs available to left/right
@property(readwrite) BOOL           bShowMoreTabAvailableIndicator;


@end
