//
//  BNRViewController.m
//  LearnStoryBoard
//
//  Created by mythware on 6/23/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "BNRViewController.h"
#import "ImageViewController.h"

@interface BNRViewController ()

@end

@implementation BNRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // old using imageView
    
    
//    if([segue.destinationViewController isKindOfClass:[ImageViewController class]])
//    {
//            
//        //获取目标视图控制器
//        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
//    
//        //根据Segue Identifier 判断将哪个图像名称传递给Scene B
//        ivc.imageName = [NSString stringWithFormat:@"%@.jpg", segue.identifier];
//            
//        //将Scene B的标题栏设为Segue的Identifier
//        ivc.title = segue.identifier;
//    }
    
    //new with url
    if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
        ImageViewController * ivc = (ImageViewController *)segue.destinationViewController;
        if([segue.identifier isEqualToString:@"image_1"])
            ivc.imageURL = [NSURL URLWithString:@"http://ts1.mm.bing.net/th?id=JN.1vddu7Y5ma6yFGkAJ5KJ2g&pid=15.1"];
        else if ([segue.identifier isEqualToString:@"image_2"])
            ivc.imageURL = [NSURL URLWithString:@"http://img1.gamedog.cn/2012/04/07/20-12040G54440.jpg"];
        else if ([segue.identifier isEqualToString:@"image_3"])
            ivc.imageURL = [NSURL URLWithString:@"http://img1.gamedog.cn/2012/03/05/20-120305093913.jpg"];
        ivc.title = segue.identifier;
    }
}

@end
