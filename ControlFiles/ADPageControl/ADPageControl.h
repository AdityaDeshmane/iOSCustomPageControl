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

//For lazy loading provide page model when moved to that page
-(UIViewController *)adPageControlGetViewControllerForPageModel:(ADPageModel *) pageModel;

//Provides current visible page index
-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage;

@end

@interface ADPageControl : UIViewController

@property(weak) id<ADPageControlDelegate> delegateADPageControl;

//Data
@property(readwrite) NSMutableArray *arrPageModel;//Only one compulsory parameter, rest all have default values

//Initial visible page
@property(readwrite) int            iFirstVisiblePageNumber;

//Color theme
@property(readwrite) UIColor        *colorTitleBarBackground;       //Top horizontal page listing view background color
@property(readwrite) UIColor        *colorTabText;                  //Page title text color
@property(readwrite) UIColor        *colorPageIndicator;            //Horizontal page indicator line color
@property(readwrite) UIColor        *colorPageOverscrollBackground;

//UI Size related customisation
@property(readwrite) int            iTitleViewHeight;               //Top title view height
@property(readwrite) int            iPageIndicatorHeight;           //Height of horizontal line indicating current page
@property(readwrite) UIFont         *fontTitleTabText;

//Bounce effect on/off
@property(readwrite) BOOL           bEnablePagesEndBounceEffect;    //Bounce for pages
@property(readwrite) BOOL           bEnableTitlesEndBounceEffect;   //Bounce for title

//More pages on right/left indicator
@property(readwrite) BOOL           bShowMoreTabAvailableIndicator; //Indicator on left and right of title view to show more pages are available


//Go to specific page by page index
-(void)goToPageWithPageNumber:(int) iPageNumber;

@end
