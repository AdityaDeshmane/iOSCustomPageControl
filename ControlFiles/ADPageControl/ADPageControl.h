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


/************************************
 *******    VERSION  1.0.2       ****
 ************************************/



#import <UIKit/UIKit.h>

/************************************
 *******   Page Model Class    ******
 ************************************/

@interface ADPageModel : NSObject

@property(nonatomic) int                iPageNumber;        //Index of page, starts with 0
@property(nonatomic) NSString           *strPageTitle;      //Title for page
@property(nonatomic) UIViewController   *viewController;    //View controller for page
@property(nonatomic) BOOL               bShouldLazyLoad;    //Setting YES will ask to provide view controller instance when moved to that page using delegate callback adPageControlGetViewControllerForPageModel

@end



/************************************
 *****  Page Control Protocol   *****
 ************************************/

@protocol ADPageControlDelegate <NSObject>

@optional

//For lazy loading provide page model when moved to that page
-(UIViewController *)adPageControlGetViewControllerForPageModel:(ADPageModel *) pageModel;

//Provides current visible page index
-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage;

@end



/************************************
 ********  Page Control VC   ********
 ************************************/

@interface ADPageControl : UIViewController

@property(weak) id<ADPageControlDelegate> delegateADPageControl;

//DataSource
@property(nonatomic) NSMutableArray *arrPageModel;//Only one compulsory parameter, rest all have default values

//Initial visible page
@property(nonatomic) int            iFirstVisiblePageNumber;

//Color theme
@property(nonatomic) UIColor        *colorTitleBarBackground;       //Top horizontal page name listing view background color
@property(nonatomic) UIColor        *colorTabText;                  //Page title text color
@property(nonatomic) UIColor        *colorPageIndicator;            //Horizontal page indicator line color
@property(nonatomic) UIColor        *colorPageOverscrollBackground; //Background color to show when overscrolled/bounced

//UI Size related customisation
@property(nonatomic) int            iTitleViewHeight;               //Top title view height
@property(nonatomic) int            iPageIndicatorHeight;           //Height of horizontal line indicating current page
@property(nonatomic) UIFont         *fontTitleTabText;              //Page title font

//Bounce effect on/off
@property(nonatomic) BOOL           bEnablePagesEndBounceEffect;    //Bounce for pages
@property(nonatomic) BOOL           bEnableTitlesEndBounceEffect;   //Bounce for title

//More pages on right/left indicator
@property(nonatomic) BOOL           bShowMoreTabAvailableIndicator; //Indicator on left and right of title view to show more pages are available

//Hide shodow
@property(nonatomic) BOOL           bHideShadow;                    //Hides shadow between title bar and pages


//Fixed tab width
/*
 Default - Calculates based on text length, dont set any value
 Custom - E.g to show 3 tabs at a time configure control like  _pageControl.iCustomTabWidth =  [[UIScreen mainScreen] bounds].size.width/3;
 */
@property(nonatomic) int            iCustomFixedTabWidth;



-(void)goToPageWithPageNumber:(int) iPageNumber;                    //Go to specific page by page index

@end
