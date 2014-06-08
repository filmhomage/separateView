//
//  ViewController.m
//  separateView
//
//  Created by earth on 6/8/14.
//  Copyright (c) 2014 filmhomage.net. All rights reserved.
//

#import "ViewController.h"

#define kMiddleLineHeight   16

@interface ViewController ()
{
    CGFloat _fPointStart;
}
@property(nonatomic,retain)UIView* viewBase;
@property(nonatomic,retain)UIView* viewtop;
@property(nonatomic,retain)UIView* viewMiddle;
@property(nonatomic,retain)UIView* viewBottom;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.]
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    CGFloat width = screenBounds.size.width;
    
    self.viewBase   = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, screenBounds.size.height)];
    self.viewtop    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, self.viewBase.frame.size.height/2 - kMiddleLineHeight)];
    self.viewMiddle = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewBase.frame.size.height/2 - kMiddleLineHeight, width, kMiddleLineHeight)];
    self.viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewBase.frame.size.height/2, width, self.viewBase.frame.size.height - self.viewtop.frame.size.height - self.viewMiddle.frame.size.height)];
    
    self.viewtop.backgroundColor = [UIColor redColor];
    self.viewMiddle.backgroundColor = [UIColor greenColor];
    self.viewBottom.backgroundColor = [UIColor blueColor];
    
    [self.viewBase addSubview:self.viewtop];
    [self.viewBase addSubview:self.viewMiddle];
    [self.viewBase addSubview:self.viewBottom];
    
    [self.view addSubview:self.viewBase];
    
    // ADD GESTURE
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.viewMiddle addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pan:(UIGestureRecognizer*)sender
{
    CGPoint touchPoint = [sender locationInView:self.view];
    
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        _fPointStart = touchPoint.y;
    }
    else if([sender state] == UIGestureRecognizerStateChanged)
    {
        // FOR DEBUG
        self.viewtop.frame = CGRectMake(self.viewtop.frame.origin.x,
                                        self.viewtop.frame.origin.y,
                                        self.viewtop.frame.size.width,
                                        self.viewtop.frame.size.height - (_fPointStart - touchPoint.y));
        
        self.viewMiddle.frame = CGRectMake(self.viewMiddle.frame.origin.x,
                                           self.viewtop.frame.origin.y + self.viewtop.frame.size.height,
                                           self.viewMiddle.frame.size.width,
                                           kMiddleLineHeight);
        
        self.viewBottom.frame = CGRectMake(self.viewBottom.frame.origin.x,
                                           self.viewMiddle.frame.origin.y + self.viewMiddle.frame.size.height,
                                           self.viewBottom.frame.size.width,
                                           self.viewBase.frame.size.height - self.viewtop.frame.size.height - self.viewMiddle.frame.size.height);
        _fPointStart = touchPoint.y;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat fDeviceWidth = landscape ? screenBounds.size.height : screenBounds.size.width;
    CGFloat fDeviceHeight = landscape ? screenBounds.size.width : screenBounds.size.height;
    
    // calculate view ratio
    CGFloat fRatio = self.viewMiddle.center.y / fDeviceWidth;
    
    // Relayout
    self.viewBase.frame   = CGRectMake(0,
                                       0,
                                       fDeviceWidth,
                                       fDeviceHeight);
    
    self.viewtop.frame    = CGRectMake(0,
                                       0,
                                       fDeviceWidth,
                                       self.viewBase.frame.size.height*fRatio - kMiddleLineHeight/2);
    
    self.viewMiddle.frame = CGRectMake(0,
                                       self.viewBase.frame.size.height*fRatio - kMiddleLineHeight/2,
                                       fDeviceWidth,
                                       kMiddleLineHeight);
    
    self.viewBottom.frame = CGRectMake(0,
                                       self.viewBase.frame.size.height*fRatio + kMiddleLineHeight/2,
                                       fDeviceWidth,
                                       self.viewBase.frame.size.height - self.viewBase.frame.size.height*fRatio + kMiddleLineHeight);
    
}

@end
