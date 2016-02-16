# iOSCustomPageControl
Android style page control

![      ](\pageControl.gif "")       

---
---

### Features

* Swipable tab bar
* Clickable tab to move to specific page
* Current page indicator with fade effect on non current title
* Easy to modify code
* Lazy loading for smoother performance ( Provide view controller instances only when moved to that page )
* Easy to setup color theme
* Many customisation parameters

---
---

### Customisation parameters

```obj-c

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


//Go to specific page by page index
-(void)goToPageWithPageNumber:(int) iPageNumber;

```

<em>This UI control can be used on all iPhones, iPods & iPads running iOS 6.0 and above.</em>

---
---

### Adding to your project


* Add Following 3 control files to your project from ADPageControl directory located under "ControlFiles/" or from demo project

```
'ADPageControl.h'
'ADPageControl.m'
'ADPageControl.xib'
```

---
---

### How to use ?


```obj-c

//1. IMPORT
  "#import "ADPageControl.h"
```

```obj-c
//2. DECLARE
  ADPageControl *_pageControl; //Declare
```  

```obj-c  
//3. SETUP PAGE MODEL USING CLASS "ADPageModel"

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
```

```obj-c
//4. INITIALIZE PAGE CONTROL

    _pageControl = [[ADPageControl alloc] init];
    _pageControl.delegateADPageControl = self;
    _pageControl.arrPageModel = [[NSMutableArray alloc] initWithObjects:
                                 pageModel0,
                                 pageModel1,
                                 pageModel2,
                                 pageModel3, nil];
```

```obj-c
//5. OPTIONAL CUSTOMISATION PARAMETERS SETUP

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
	
```

```obj-c
//6. ADD AS SUBVIEW
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
```

```obj-c
//7. CONFORM TO DELEGATE 

//7.A : Conform <ADPageControlDelegate>

//7.B : HANDLE LAZY LOADING BY PROVIDING VIEW CONTROLLERS (Optional : Applicable only if you want to lazy load view controllers)


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

//7.C : Get index of currenty visible page (Optional)

-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage
{
    NSLog(@"ADPageControl :: Current visible page index : %d",iCurrentVisiblePage);
}


```


---
---

### Requirements

* ADPageControl works on iOS 6.0 & above versions and is compatible with ARC projects. 
* There is no need of other frameworks/libraries.

---
---

### Other details

* Compatible devices : iPhone, iPad, iPod
* Testing : iOS 6, 7, 8 & 9

---
---

### TODO

* Component polishing
* More generalizations

---
---
## License

iOSCustomPageControl is available under the MIT license. See the LICENSE file for more info.
