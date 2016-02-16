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

#define COLOR_LIGHT_RED         [UIColor colorWithRed:1 green:204.0/255 blue:204.0/255.0 alpha:1.0]
#define COLOR_LIGHT_GREEN       [UIColor colorWithRed:204.0/255 green:1 blue:204.0/255 alpha:1.0]
#define COLOR_LIGHT_BLUE        [UIColor colorWithRed:204.0/255 green:204.0/255 blue:1 alpha:1.0]
#define COLOR_LIGHT_YELLOW      [UIColor colorWithRed:1 green:1 blue:204.0/255 alpha:1.0]

#import "SampleViewController.h"
#import "ADPageControl.h"

@interface SampleViewController ()<ADPageControlDelegate>
{
    ADPageControl   *_pageControl;
}

@end

@implementation SampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageControl];
}


-(void)setupPageControl
{
    
    /**** 1. Setup pages using model class "ADPageModel" ****/
    
    
    //page 0
    ADPageModel *pageModel0 =       [[ADPageModel alloc] init];
    UIViewController *page0 =       [UIViewController new];
    page0.view.backgroundColor =    COLOR_LIGHT_RED;
    pageModel0.strPageTitle =       @"Reeed";
    pageModel0.iPageNumber =        0;
    pageModel0.viewController =     page0;//You can provide view controller in prior OR use flag "bShouldLazyLoad" to load only when required
    
    //page 1
    ADPageModel *pageModel1 =       [[ADPageModel alloc] init];
    pageModel1.strPageTitle =       @"Greeeeeeeen";
    pageModel1.iPageNumber =        1;
    pageModel1.bShouldLazyLoad =    YES;
    
    //page 2
    ADPageModel *pageModel2 =       [[ADPageModel alloc] init];
    pageModel2.strPageTitle =       @"Blueeee";
    pageModel2.iPageNumber =        2;
    pageModel2.bShouldLazyLoad =    YES;
    
    //page 3
    ADPageModel *pageModel3 =       [[ADPageModel alloc] init];
    pageModel3.strPageTitle =       @"Yeeellow";
    pageModel3.iPageNumber =        3;
    pageModel3.bShouldLazyLoad =    YES;
    
    
    
    /**** 2. Initialize page control ****/
    
    _pageControl = [[ADPageControl alloc] init];
    _pageControl.delegateADPageControl = self;
    _pageControl.arrPageModel = [[NSMutableArray alloc] initWithObjects:
                                 pageModel0,
                                 pageModel1,
                                 pageModel2,
                                 pageModel3, nil];
    
    
    
    /**** 3. Customize parameters (Optinal, as all have default value set) ****/
    
    _pageControl.iFirstVisiblePageNumber =  1;
    _pageControl.iTitleViewHeight =         40;
    _pageControl.iPageIndicatorHeight =     4;
    _pageControl.fontTitleTabText =         [UIFont fontWithName:@"Helvetica" size:16];
    
    _pageControl.bEnablePagesEndBounceEffect =  NO;
    _pageControl.bEnableTitlesEndBounceEffect = NO;
    
    _pageControl.colorTabText =                     [UIColor whiteColor];
    _pageControl.colorTitleBarBackground =          [UIColor purpleColor];
    _pageControl.colorPageIndicator =               [UIColor whiteColor];
    _pageControl.colorPageOverscrollBackground =    [UIColor lightGrayColor];
    
    _pageControl.bShowMoreTabAvailableIndicator =   NO;
    
    
    
    /**** 3. Add as subview ****/
    
    [self.view addSubview:_pageControl.view];
    _pageControl.view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *subview = _pageControl.view;
    
    //Leading margin 0, Trailing margin 0
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(subview)]];
    
    //Top margin 20 for status bar, Bottom margin 0
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[subview]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(subview)]];
    
    
}

#pragma mark - ADPageControlDelegate 

//LAZY LOADING

-(UIViewController *)adPageControlGetViewControllerForPageModel:(ADPageModel *) pageModel
{
    NSLog(@"ADPageControl :: Lazy load asking for page %d",pageModel.iPageNumber);
    
    if(pageModel.iPageNumber == 1)
    {
        UIViewController *page1 =       [UIViewController new];
        page1.view.backgroundColor =    COLOR_LIGHT_GREEN;

        return page1;
    }
    else if(pageModel.iPageNumber == 2)
    {
        UIViewController *page2 =       [UIViewController new];
        page2.view.backgroundColor =    COLOR_LIGHT_BLUE;
        
        return page2;
    }
    else if(pageModel.iPageNumber == 3)
    {
        UIViewController *page3 =       [UIViewController new];
        page3.view.backgroundColor =    COLOR_LIGHT_YELLOW;
        
        return page3;
    }
    
    return nil;
}

//CURRENT PAGE INDEX

-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage
{
    NSLog(@"ADPageControl :: Current visible page index : %d",iCurrentVisiblePage);
}

@end
