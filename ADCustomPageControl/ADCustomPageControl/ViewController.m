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


#import "ViewController.h"
#import "ADPageControl.h"
#import "PageItemController.h"

@interface ViewController ()<ADPageControlDelegate>
{
    ADPageControl *_pageControl;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /** 1. Setup pages using model class "ADPageModel" **/
    
    //page 0
    ADPageModel *pageModel0 = [[ADPageModel alloc] init];
    PageItemController *page0 = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
    page0.view.backgroundColor = [UIColor colorWithRed:1 green:204.0/255 blue:204.0/255.0 alpha:1.0];
    pageModel0.strPageTitle = @"Reeed";
    pageModel0.iPageNumber = 0;
    pageModel0.viewController = page0;//You can provide view control in prior OR use flag "bShouldLazyLoad" to load only when required

    //page 1
    ADPageModel *pageModel1 = [[ADPageModel alloc] init];
    pageModel1.strPageTitle = @"Greeeeeeeen";
    pageModel1.iPageNumber = 1;
    pageModel1.bShouldLazyLoad = YES;
    
    //page 2
    ADPageModel *pageModel2 = [[ADPageModel alloc] init];
    pageModel2.strPageTitle = @"Blueeee";
    pageModel2.iPageNumber = 2;
    pageModel2.bShouldLazyLoad = YES;
    
    //page 3
    ADPageModel *pageModel3 = [[ADPageModel alloc] init];
    pageModel3.strPageTitle = @"Yeeellow";
    pageModel3.iPageNumber = 3;
    pageModel3.bShouldLazyLoad = YES;
    
    /** 2. Initialize page control **/
    _pageControl = [[ADPageControl alloc] init];
    _pageControl.iFirstVisiblePageNumber = 1;
    _pageControl.delegateADPageControl = self;
    _pageControl.arrPageModel = [[NSMutableArray alloc] initWithObjects:pageModel0,pageModel1,pageModel2,pageModel3, nil];

    /** 3. Set theme colors **/
    _pageControl.colorTabText = [UIColor whiteColor];
    _pageControl.colorTitleBarBackground = [UIColor purpleColor];
    _pageControl.colorPageIndicator = [UIColor whiteColor];
    _pageControl.colorPageOverscrollBackground = [UIColor darkGrayColor];
    
    /** 4. Add as subview **/
    _pageControl.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
    [self.view addSubview:_pageControl.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADPageControlDelegate LazyLoading

-(UIViewController *)getViewControllerForPageModel:(ADPageModel *) pageModel
{
    if(pageModel.iPageNumber == 1)
    {
        PageItemController *page1 = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
        page1.view.backgroundColor = [UIColor colorWithRed:204.0/255 green:1 blue:204.0/255 alpha:1.0];

        return page1;
    }
    else if(pageModel.iPageNumber == 2)
    {
        PageItemController *page2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
        page2.view.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:1 alpha:1.0];
        
        return page2;
    }
    else if(pageModel.iPageNumber == 3)
    {
        PageItemController *page3 = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
        page3.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:204.0/255 alpha:1.0];
        
        return page3;
    }
    
    return nil;
}

@end
