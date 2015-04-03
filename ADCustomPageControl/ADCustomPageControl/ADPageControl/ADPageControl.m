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


#import "ADPageControl.h"

//Constants
#define HUGE_WIDTH_VALUE 1500
#define FONT [UIFont fontWithName:@"Helvetica-Bold" size:17]

//Default colors
#define DEFAULT_COLOR_TITLE_BAR_BACKGROUND [UIColor colorWithRed:51.0/255 green:0 blue:102.0/255 alpha:1.0]
#define DEFAULT_COLOR_TAB_TEXT [UIColor redColor]
#define DEFAULT_COLOR_PAGE_INDICATOR [UIColor redColor]
#define DEFAULT_COLOR_PAGE_OVERSCROLL_BACKGROUND [UIColor colorWithRed:45.0/255 green:2.0/255 blue:89.0/255 alpha:1.0]

@interface ADPageControl ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_arrTabWidth;
    int _iCurrentVisiblePage;
    NSMutableArray *_arrTabButtons;
}

//Outlets
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewTitle;
@property (strong, nonatomic) IBOutlet UIView *viewPageIndicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintPageIndicatorLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintPageIndicotorWidth;

//Private methods
-(void)setupPages;
-(void)setupTitles;
-(IBAction)tabPressed:(id)sender;
-(void)setPageIndicatorToPageNumber:(int) pageNumber andShouldHighlightCurrentPage:(BOOL) shouldHighlight;

@end

@implementation ADPageControl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupPages];
    [self setupTitles];
    [self setPageIndicatorToPageNumber:_iFirstVisiblePageNumber andShouldHighlightCurrentPage:YES];
}

#pragma mark - Initialization methods

-(void)setupPages
{
    if(_iFirstVisiblePageNumber >= _arrPageModel.count)
        _iFirstVisiblePageNumber = 0 ;
    
    _iCurrentVisiblePage = _iFirstVisiblePageNumber;
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self ;
    ADPageModel *firstVisiblePage = [_arrPageModel objectAtIndex:_iFirstVisiblePageNumber];
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:[self getViewControllerForPageModel:firstVisiblePage]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [_viewContainer addSubview:_pageViewController.view];
    [_pageViewController.view setFrame:_viewContainer.bounds];
    [_viewContainer setBackgroundColor:_colorPageOverscrollBackground ? _colorPageOverscrollBackground : DEFAULT_COLOR_PAGE_OVERSCROLL_BACKGROUND];
}

-(void)setupTitles
{
    [self setWidthArray];
    
    [_scrollViewTitle setBackgroundColor:_colorTitleBarBackground ? _colorTitleBarBackground : DEFAULT_COLOR_TITLE_BAR_BACKGROUND];
    [_viewPageIndicator setBackgroundColor:_colorPageIndicator ? _colorPageIndicator : DEFAULT_COLOR_PAGE_INDICATOR];
    UIColor *buttonTextColor = _colorTabText ? _colorTabText : DEFAULT_COLOR_TAB_TEXT;
    
    int parentHeight = _scrollViewTitle.frame.size.height;
    int numberOfTabs = (int)_arrPageModel.count;
    int btnTagOffset = 300;
    
    _arrTabButtons = [[NSMutableArray alloc] init];
    
    for(int index = 0; index < numberOfTabs; index++ )
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        ADPageModel *pageModel = [_arrPageModel objectAtIndex:index];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:pageModel.strPageTitle forState:UIControlStateNormal];
        [button setTitleColor:buttonTextColor forState:UIControlStateNormal];
        [button.titleLabel setFont:FONT];
        [button setTag:btnTagOffset + index];
        [button addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_arrTabButtons addObject:button];
        [_scrollViewTitle addSubview:button];
        
        //WIDTH
        NSString *strWidth = [NSString stringWithFormat:@"H:[button(==%f)]",[[_arrTabWidth objectAtIndex:index] floatValue]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strWidth
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(button)]];
        
        //HEIGHT
        NSString *strHeight = [NSString stringWithFormat:@"V:[button(==%d)]",parentHeight];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strHeight
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(button)]];
        
        //TOP SPACE
        NSLayoutConstraint *constraintTopSpace = [NSLayoutConstraint constraintWithItem:button
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_scrollViewTitle
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f
                                                                               constant:0.0f];
        [_scrollViewTitle addConstraint:constraintTopSpace];
        
        if(index == 0)//first tab
        {
            //LEADING SPACE
            NSLayoutConstraint *constraintLeadingSpace = [NSLayoutConstraint constraintWithItem:button
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_scrollViewTitle
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1.0f
                                                                                       constant:0.0f];
            [_scrollViewTitle addConstraint:constraintLeadingSpace];
        }
        else//middle tabs
        {
            //HORIZONTAL SPACING
            UIButton *previousButton = (UIButton*)[_scrollViewTitle viewWithTag:btnTagOffset + (index -1)];
            
            NSLayoutConstraint *constraintHorizontalSpace = [NSLayoutConstraint constraintWithItem:previousButton
                                                                                         attribute:NSLayoutAttributeTrailing
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:button
                                                                                         attribute:NSLayoutAttributeLeading
                                                                                        multiplier:1.0f
                                                                                          constant:0.0f];
            [_scrollViewTitle addConstraint:constraintHorizontalSpace];
            
            if(index == (numberOfTabs-1))//last tab
            {
                //TRAILING SPACE
                NSLayoutConstraint *constraintTrailingSpace = [NSLayoutConstraint constraintWithItem:button
                                                                                           attribute:NSLayoutAttributeTrailing
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:_scrollViewTitle
                                                                                           attribute:NSLayoutAttributeTrailing
                                                                                          multiplier:1.0f
                                                                                            constant:0.0f];
                [_scrollViewTitle addConstraint:constraintTrailingSpace];
            }
        }
    }
}

-(void)setWidthArray
{
    _arrTabWidth = [[NSMutableArray alloc] init];
    
    //Label width calculation
    float expectedLabelWidth = 0;
    float requiredHeight = _scrollViewTitle.frame.size.height -20;
    
    for (int index = 0; index < _arrPageModel.count ; index++)
    {
        ADPageModel *pageModel = [_arrPageModel objectAtIndex:index];
        NSString *textString = pageModel.strPageTitle;
        
        if([textString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])//iOS 7
        {
            expectedLabelWidth= [textString boundingRectWithSize:CGSizeMake(HUGE_WIDTH_VALUE,requiredHeight)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:FONT}
                                                         context:nil].size.width;
        }
        else//iOS 6 and below
        {
            //Dont worry about warnings, this code will execute only for iOS 6 & below
            CGSize constraintSize = CGSizeMake(HUGE_WIDTH_VALUE, requiredHeight);
            expectedLabelWidth = [textString sizeWithFont:FONT
                                        constrainedToSize:constraintSize
                                            lineBreakMode:UILineBreakModeWordWrap].width;
        }
        
        [_arrTabWidth addObject:[NSNumber numberWithFloat:expectedLabelWidth+30]];
        
        NSLog(@"TAB %d width : %f",index, expectedLabelWidth);
    }
}


-(void)setPageIndicatorToPageNumber:(int) pageNumber andShouldHighlightCurrentPage:(BOOL) bShouldHighlight
{
    float fLeading = 0;
    float fWidth = [[_arrTabWidth objectAtIndex:pageNumber] floatValue];
    
    for(int index = 0 ; index < pageNumber ; index ++)
    {
        fLeading = fLeading + [[_arrTabWidth objectAtIndex:index] floatValue];
    }
    
    [_scrollViewTitle scrollRectToVisible:CGRectMake(fLeading, 0, fWidth, 10) animated:YES];
    
    [UIView animateWithDuration:0.2 animations:
     ^{
         _constraintPageIndicatorLeading.constant = fLeading;
         _constraintPageIndicotorWidth.constant = fWidth;
         [_viewPageIndicator layoutIfNeeded];
     }];
    
    
    if(bShouldHighlight)//Set page as current visible page
    {
        _iCurrentVisiblePage = pageNumber;
        
        for (UIButton *tabButton in _arrTabButtons)
        {
            tabButton.alpha = 0.7;
        }
        
        UIButton *currentTabButton = [_arrTabButtons objectAtIndex:_iCurrentVisiblePage];
        currentTabButton.alpha = 1.0;
    }
}

#pragma mark - IBActions

-(IBAction)tabPressed:(id)sender
{
    UIButton *btn = (UIButton*) sender;
    int iPageNumber = (int)btn.tag - 300;
    
    NSLog(@"Tab : %d pressed",iPageNumber );
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       
                       ADPageModel *pageModel = [_arrPageModel objectAtIndex:iPageNumber];
                       //animate to next page
                       [_pageViewController setViewControllers:@[[self getViewControllerForPageModel:pageModel]]
                                                     direction: (_iCurrentVisiblePage < iPageNumber) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                                      animated:YES
                                                    completion:^(BOOL finished){}];
                       
                       [self setPageIndicatorToPageNumber:iPageNumber andShouldHighlightCurrentPage:YES];
                       
                   });
}



#pragma mark - PageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int pageNumber = [self getPageNumberForViewController:viewController];
    int previousPageNumber = pageNumber - 1;
    
    if (pageNumber == 0)//no pages before page 0
        return nil;
    
    ADPageModel *pageModel = [_arrPageModel objectAtIndex:previousPageNumber];
    
    return [self getViewControllerForPageModel:pageModel];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int pageNumber = [self getPageNumberForViewController:viewController];
    int nextPageNumber = pageNumber + 1;
    
    if (nextPageNumber == [_arrPageModel count])//no pages after last page
        return nil;
    
    ADPageModel *pageModel = [_arrPageModel objectAtIndex:nextPageNumber];
    
    return [self getViewControllerForPageModel:pageModel];
}


#pragma mark - PageViewControllerDelegates

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    int pageNumber = [self getPageNumberForViewController:[pendingViewControllers lastObject]];
    NSLog(@"About to make transition to page number : %d",pageNumber);
    
    [self setPageIndicatorToPageNumber:pageNumber andShouldHighlightCurrentPage:NO];
    
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        int pageNumber = [self getPageNumberForViewController:[_pageViewController.viewControllers lastObject]];
        
        NSLog(@"Current visible page number : %d",pageNumber);
        [self setPageIndicatorToPageNumber:pageNumber andShouldHighlightCurrentPage:YES];
    }
    else
    {
        [self setPageIndicatorToPageNumber:_iCurrentVisiblePage andShouldHighlightCurrentPage:NO];
    }
}


#pragma mark - Utility methods

-(int)getPageNumberForViewController:(UIViewController*) vc
{
    int pageNumber = 0;
    
    for(ADPageModel *pageModel in _arrPageModel)
    {
        if(pageModel.viewController == vc)
        {
            pageNumber = pageModel.iPageNumber;
            break;
        }
    }
    
    return  pageNumber;
}


-(UIViewController *)getViewControllerForPageModel:(ADPageModel *) pageModel
{
    if(pageModel.bShouldLazyLoad && pageModel.viewController == nil)
    {
        if(_delegateADPageControl && [_delegateADPageControl respondsToSelector:@selector(getViewControllerForPageModel:)])
        {
            pageModel.viewController = [_delegateADPageControl getViewControllerForPageModel:pageModel];
            pageModel.bShouldLazyLoad = NO;
        }
    }
    
    [_arrPageModel replaceObjectAtIndex:pageModel.iPageNumber withObject:pageModel];
    
    return pageModel.viewController;
}


@end
