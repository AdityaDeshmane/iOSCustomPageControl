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
#define DEFAULT_TAB_TEXT_FONT [UIFont fontWithName:@"Helvetica" size:15]
#define DEFAULT_PAGE_INDICATOR_HEIGHT 3
#define DEFAULT_TITLE_VIEW_HEIGHT 35

//Default colors
#define DEFAULT_COLOR_TITLE_BAR_BACKGROUND [UIColor colorWithRed:51.0/255 green:0 blue:102.0/255 alpha:1.0]
#define DEFAULT_COLOR_TAB_TEXT [UIColor redColor]
#define DEFAULT_COLOR_PAGE_INDICATOR [UIColor redColor]
#define DEFAULT_COLOR_PAGE_OVERSCROLL_BACKGROUND [UIColor colorWithRed:45.0/255 green:2.0/255 blue:89.0/255 alpha:1.0]

//Tab button tag offset ( starting with tag zero will not work to check subview with tag, as default tag values are 0)
#define TAB_BTN_TAG_OFFSET 300
#define HUGE_WIDTH_VALUE 1500


@interface ADPageControl ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
{
    UIPageViewController    *_pageViewController;
    NSMutableArray          *_arrTabWidth;
    int                     _iCurrentVisiblePage;
    NSMutableArray          *_arrTabButtons;
    UIScrollView            *_scrollViewPageController;
}

//Outlets
@property (strong, nonatomic) IBOutlet UIView               *viewContainer;
@property (strong, nonatomic) IBOutlet UIScrollView         *scrollViewTitle;
@property (strong, nonatomic) IBOutlet UIView               *viewPageIndicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint   *constraintPageIndicatorLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint   *constraintPageIndicotorWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint   *constraintTitleViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint   *constraintPageIndicatorTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint   *constraintPageIndicatorHeight;
@property (weak, nonatomic) IBOutlet UIView                 *viewIndicatorMoreTitlesToLeft;
@property (weak, nonatomic) IBOutlet UIView                 *viewIndicatorMoreTitlesToRight;



//Many apps nowadays use drawer control,
//this 4 pixel width dummy views at both edges disables touches on edges in order to open drawer on edge swipe
//Hide them, if you want this control to respond to touches at end as well..
//To hide, add lines _viewLeftDummy.hidden = YES; _viewRightDummy.hidden = YES; in viewDidLoad
@property (strong, nonatomic) IBOutlet UIView               *viewLeftDummy;
@property (strong, nonatomic) IBOutlet UIView               *viewRightDummy;

//Private methods
-(void)validateFirstVisiblePageNumber;
-(void)setupIndicatorViewMoreTitleToLeftRight;
-(void)initializeTitleViewParameters;
-(void)setTabWidthArray;
-(void)setupTitleView;
-(void)setupPages;
-(void)setPageIndicatorToPageNumber:(int) pageNumber
      andShouldHighlightCurrentPage:(BOOL) shouldHighlight;
-(void)setBounceParameters;
-(IBAction)tabPressed:(id)sender;

@end

@implementation ADPageControl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self validateFirstVisiblePageNumber];
    [self initializeTitleViewParameters];
    [self setTabWidthArray];
    [self setupTitleView];
    [self setupIndicatorViewMoreTitleToLeftRight];
    [self setupPages];
    [self setPageIndicatorToPageNumber:_iFirstVisiblePageNumber andShouldHighlightCurrentPage:YES];
    [self setBounceParameters];
}

#pragma mark - Initialization methods

-(void)validateFirstVisiblePageNumber
{
    if(_iFirstVisiblePageNumber >= _arrPageModel.count)
        _iFirstVisiblePageNumber = 0 ;
    
    _iCurrentVisiblePage = _iFirstVisiblePageNumber;
}

-(void)initializeTitleViewParameters
{
    if(!_fontTitleTabText)
    {
        _fontTitleTabText = DEFAULT_TAB_TEXT_FONT;
    }
    
    if(_iPageIndicatorHeight <= 0)
    {
        _iPageIndicatorHeight = DEFAULT_PAGE_INDICATOR_HEIGHT;
    }
    
    if(_iTitleViewHeight <= 0)
    {
        _iTitleViewHeight = DEFAULT_TITLE_VIEW_HEIGHT;
    }
    
    _constraintPageIndicatorHeight.constant = _iPageIndicatorHeight;
    _constraintTitleViewHeight.constant = _iTitleViewHeight;
    _constraintPageIndicatorTop.constant = _iTitleViewHeight - _iPageIndicatorHeight;
    
    [_scrollViewTitle setBackgroundColor:_colorTitleBarBackground ? _colorTitleBarBackground : DEFAULT_COLOR_TITLE_BAR_BACKGROUND];
    [_viewPageIndicator setBackgroundColor:_colorPageIndicator ? _colorPageIndicator : DEFAULT_COLOR_PAGE_INDICATOR];
    _arrTabButtons = [[NSMutableArray alloc] init];
}

-(void)setupTitleView
{
    //Adding buttons to scrollview
    for(int index = 0; index < _arrPageModel.count; index++ )
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        ADPageModel *pageModel = [_arrPageModel objectAtIndex:index];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:pageModel.strPageTitle forState:UIControlStateNormal];
        [button setTitleColor:_colorTabText ? _colorTabText : DEFAULT_COLOR_TAB_TEXT forState:UIControlStateNormal];
        [button.titleLabel setFont:_fontTitleTabText];
        [button setTag:TAB_BTN_TAG_OFFSET + index];
        [button addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_arrTabButtons addObject:button];
        [_scrollViewTitle addSubview:button];
        [self addConstraintsToTabButtonAtIndex:index];
    }
}

-(void)addConstraintsToTabButtonAtIndex:(int)index
{
    UIButton *button  = [_arrTabButtons objectAtIndex:index];
    int parentScrollViewHeight = _constraintTitleViewHeight.constant;
    int numberOfTabs = (int)_arrPageModel.count;

    //WIDTH
    NSString *strWidth = [NSString stringWithFormat:@"H:[button(==%f)]",[[_arrTabWidth objectAtIndex:index] floatValue]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strWidth
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    
    //HEIGHT
    NSString *strHeight = [NSString stringWithFormat:@"V:[button(==%d)]",parentScrollViewHeight];
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
        UIButton *previousButton = (UIButton*)[_scrollViewTitle viewWithTag:TAB_BTN_TAG_OFFSET + (index -1)];
        
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

-(void)setTabWidthArray
{
    _arrTabWidth = [[NSMutableArray alloc] init];
    
    //button width calculation
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
                                                      attributes:@{NSFontAttributeName:_fontTitleTabText}
                                                         context:nil].size.width;
        }
        else//iOS 6 and below
        {
            //Dont worry about warnings, this code will execute only for iOS 6 & below
            CGSize constraintSize = CGSizeMake(HUGE_WIDTH_VALUE, requiredHeight);
            expectedLabelWidth = [textString sizeWithFont:_fontTitleTabText
                                        constrainedToSize:constraintSize
                                            lineBreakMode:UILineBreakModeWordWrap].width;
        }
        
        [_arrTabWidth addObject:[NSNumber numberWithFloat:expectedLabelWidth+30]];
        
        NSLog(@"ADPageControl :: TAB %d width : %f",index, expectedLabelWidth);
    }
}

-(void)setupIndicatorViewMoreTitleToLeftRight
{
    if(_bShowMoreTabAvailableIndicator)
    {
        _scrollViewTitle.delegate = self;
        [self.view bringSubviewToFront:_viewIndicatorMoreTitlesToLeft];
        [self.view bringSubviewToFront:_viewIndicatorMoreTitlesToRight];
        
        //Gradient colors, 1st 3 ouside view, last 3 visible with corner radius
        NSArray *arrGradientColor = [NSArray arrayWithObjects:
                                     (id)[UIColor blackColor].CGColor,
                                     (id)[UIColor blackColor].CGColor,
                                     (id)[UIColor blackColor].CGColor,
                                     (id)[UIColor blackColor].CGColor,
                                     (id)[UIColor darkGrayColor].CGColor,
                                     (id)[UIColor lightGrayColor].CGColor, nil];
        CGPoint darkPoint = CGPointMake(0.0, 0.5);
        CGPoint lightPoint = CGPointMake(1.0, 0.5);
        
        //Left view
        [_viewIndicatorMoreTitlesToLeft layoutIfNeeded];
        CAGradientLayer *gradientLeft = [CAGradientLayer layer];
        gradientLeft.frame = _viewIndicatorMoreTitlesToLeft.bounds;
        gradientLeft.colors = arrGradientColor;
        [gradientLeft setStartPoint:darkPoint];
        [gradientLeft setEndPoint:lightPoint];
        gradientLeft.cornerRadius = 12;
        [_viewIndicatorMoreTitlesToLeft.layer insertSublayer:gradientLeft atIndex:0];
        [_viewIndicatorMoreTitlesToLeft layoutIfNeeded];
        
        //Right view
        [_viewIndicatorMoreTitlesToRight layoutIfNeeded];
        CAGradientLayer *gradientRight = [CAGradientLayer layer];
        gradientRight.frame = _viewIndicatorMoreTitlesToRight.bounds;
        gradientRight.colors = arrGradientColor;
        [gradientRight setStartPoint:lightPoint];
        [gradientRight setEndPoint:darkPoint];
        gradientRight.cornerRadius = 12;
        [_viewIndicatorMoreTitlesToRight.layer insertSublayer:gradientRight atIndex:0];
        [_viewIndicatorMoreTitlesToRight layoutIfNeeded];
    }
}


-(void)setupPages
{
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


-(void)setPageIndicatorToPageNumber:(int) pageNumber andShouldHighlightCurrentPage:(BOOL) bShouldHighlight
{
    float fLeading = 0;
    float fWidth = [[_arrTabWidth objectAtIndex:pageNumber] floatValue];
    
    for(int index = 0 ; index < pageNumber ; index ++)
    {
        fLeading = fLeading + [[_arrTabWidth objectAtIndex:index] floatValue];
    }

    //Works similar to scrollRectToVisible:
    [UIView animateWithDuration:0.3
     animations:
     ^{
        if(fLeading < _scrollViewTitle.contentOffset.x )
        {
            _scrollViewTitle.contentOffset = CGPointMake(fLeading, 0);
        }
        else if((fLeading + fWidth )> (_scrollViewTitle.contentOffset.x + _scrollViewTitle.frame.size.width))
        {
            _scrollViewTitle.contentOffset = CGPointMake(fLeading + fWidth - (_scrollViewTitle.frame.size.width), 0);
        }
     }
     completion:^(BOOL finished)
     {
         [self updateMoreTabAvailableIndicator];
     }
    ];
    
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
        
        if(_delegateADPageControl && [_delegateADPageControl respondsToSelector:@selector(adPageControlCurrentVisiblePageIndex:)])
        {
            [_delegateADPageControl adPageControlCurrentVisiblePageIndex:_iCurrentVisiblePage];
        }
    }
}

-(void)setBounceParameters
{
    [_viewContainer bringSubviewToFront:_viewLeftDummy];
    [_viewContainer bringSubviewToFront:_viewRightDummy];
    [self enablePagesEndBounceEffect:_bEnablePagesEndBounceEffect];
    _scrollViewTitle.bounces = _bEnableTitlesEndBounceEffect;
}

#pragma mark - Bounce Customization

-(void)enablePagesEndBounceEffect:(BOOL) bShouldEnable
{
    _bEnablePagesEndBounceEffect = bShouldEnable;
    
    if(_bEnablePagesEndBounceEffect == NO)
    {
        for (UIView *view in _pageViewController.view.subviews )
        {
            if ([view isKindOfClass:[UIScrollView class]])
            {
                _scrollViewPageController = (UIScrollView *)view;
                _scrollViewPageController.delegate = self;
                break;
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_scrollViewTitle == scrollView)
    {
        [self updateMoreTabAvailableIndicator];
    }
    else if(_scrollViewPageController == scrollView)
    {
        if (_bEnablePagesEndBounceEffect == NO)
        {
            if (_iCurrentVisiblePage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width)
            {
                scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
            }
            
            if (_iCurrentVisiblePage == [_arrPageModel count]-1 && scrollView.contentOffset.x > scrollView.bounds.size.width)
            {
                scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
            }
        }
    }
}

-(void)updateMoreTabAvailableIndicator
{
    if(_bShowMoreTabAvailableIndicator == NO)
        return;
    
    _viewIndicatorMoreTitlesToLeft.hidden = YES;
    _viewIndicatorMoreTitlesToRight.hidden = YES;
    
    if(_scrollViewTitle.contentOffset.x > 0 && _iCurrentVisiblePage != 0)
    {
        _viewIndicatorMoreTitlesToLeft.hidden = NO;
    }
    
    
    
    if( (_scrollViewTitle.contentOffset.x  + _scrollViewTitle.bounds.size.width ) < _scrollViewTitle.contentSize.width &&
       _iCurrentVisiblePage != _arrPageModel.count - 1)
    {
        _viewIndicatorMoreTitlesToRight.hidden = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
   if(_scrollViewPageController == scrollView)
    {
        if (_bEnablePagesEndBounceEffect == NO)
        {
            if (_iCurrentVisiblePage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width)
            {
                velocity = CGPointZero;
                *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
            }
            
            if (_iCurrentVisiblePage == [_arrPageModel count]-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width)
            {
                velocity = CGPointZero;
                *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
            }
        }
    }
}


#pragma mark - IBActions

-(IBAction)tabPressed:(id)sender
{
    UIButton *btn = (UIButton*) sender;
    int iPageNumber = (int)btn.tag - TAB_BTN_TAG_OFFSET;
    
    NSLog(@"ADPageControl :: Tab : %d pressed",iPageNumber );

    dispatch_async(dispatch_get_main_queue(),
   ^{
       ADPageModel *pageModel = [_arrPageModel objectAtIndex:iPageNumber];
       //animate to next page
       [_pageViewController setViewControllers:@[[self getViewControllerForPageModel:pageModel]]
                                     direction: (_iCurrentVisiblePage < iPageNumber) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                      animated:NO
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
    NSLog(@"ADPageControl :: About to make transition to page number : %d",pageNumber);

    [self setPageIndicatorToPageNumber:pageNumber andShouldHighlightCurrentPage:NO];
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        int pageNumber = [self getPageNumberForViewController:[_pageViewController.viewControllers lastObject]];
        
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
        if(_delegateADPageControl && [_delegateADPageControl respondsToSelector:@selector(adPageControlGetViewControllerForPageModel:)])
        {
            UIViewController *viewController = [_delegateADPageControl adPageControlGetViewControllerForPageModel:pageModel];
            pageModel.viewController = viewController  ? viewController : [UIViewController new] ;
            pageModel.bShouldLazyLoad = NO;
            [_arrPageModel replaceObjectAtIndex:pageModel.iPageNumber withObject:pageModel];
        }
    }
    
    return pageModel.viewController ? pageModel.viewController : [UIViewController new];
}


@end
