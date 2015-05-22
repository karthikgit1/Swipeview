//
//  ViewController.m
//  SwipViewController
//
//  Created by Vy Systems - iOS1 on 12/10/14.
//  Copyright (c) 2014 Vy Systems - iOS1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<SwipeViewDataSource, SwipeViewDelegate>
- (IBAction)swipeLeft:(id)sender;
- (IBAction)swipeRight:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    //set up data
    //your swipeView should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [_items addObject:@(i)];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure swipeView
    _swipeView.pagingEnabled = YES;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //index = index + 1;
    //indexCount = index;
    NSLog(@"index is %ld",(long)index);
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    view.backgroundColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    int _val = [_items[index] integerValue];
    _val = _val + 100;
//    label.text = [_items[index  ] stringValue];
    label.text = [NSString stringWithFormat:@"%d",_val];

    
    self.lblCount.text = [_items[index] stringValue];
    
    /*
     
     NSLog(@"index is %ld",(long)indexCount);
     UILabel *label = nil;
     
     //create new view if no view is available for recycling
     if (view == nil)
     {
     //don't do anything specific to the index within
     //this `if (view == nil) {...}` statement because the view will be
     //recycled and used with other index values later
     view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
     view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     
     label = [[UILabel alloc] initWithFrame:view.bounds];
     label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     label.backgroundColor = [UIColor clearColor];
     label.textAlignment = NSTextAlignmentCenter;
     label.font = [label.font fontWithSize:50];
     label.tag = 1;
     [view addSubview:label];
     }
     else
     {
     //get a reference to the label in the recycled view
     label = (UILabel *)[view viewWithTag:1];
     }
     
     //set background color
     CGFloat red = arc4random() / (CGFloat)INT_MAX;
     CGFloat green = arc4random() / (CGFloat)INT_MAX;
     CGFloat blue = arc4random() / (CGFloat)INT_MAX;
     view.backgroundColor = [UIColor colorWithRed:red
     green:green
     blue:blue
     alpha:1.0];
     
     //set item label
     //remember to always set any properties of your carousel item
     //views outside of the `if (view == nil) {...}` check otherwise
     //you'll get weird issues with carousel item content appearing
     //in the wrong place in the carousel
     label.text = [_items[indexCount] stringValue];
     
     */
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
    
    
}

- (IBAction)swipeLeft:(id)sender
{
    //indexCount = indexCount + 1;
    _swipeView.currentItemIndex = _swipeView.currentItemIndex - 1;
    [self swipeView:_swipeView viewForItemAtIndex:_swipeView.currentItemIndex reusingView:self.swipeView];
    NSLog(@"Left button is clicked");

}

- (IBAction)swipeRight:(id)sender
{
    //indexCount = indexCount + 1;
    _swipeView.currentItemIndex = _swipeView.currentItemIndex + 1;
    [self swipeView:_swipeView viewForItemAtIndex:_swipeView.currentItemIndex reusingView:self.swipeView];
    NSLog(@"Right button is clicked");
}
@end
