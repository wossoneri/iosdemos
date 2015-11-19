//
//  ViewController.m
//  CircleTimerControl
//
<<<<<<< Updated upstream
//  Created by 杜博文 on 15/10/24.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

=======
//  Created by mythware on 10/26/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "ViewController.h"
#import "Masonry/Masonry.h"


@interface ViewController () <CircleTimerDelegate>
{
    CircleTimerView *circleTimer;

}
>>>>>>> Stashed changes
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
<<<<<<< Updated upstream
=======
    
    circleTimer = [[CircleTimerView alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 150, 300, 300)];
    
//    circleTimer = [[CircleTimerView alloc] init];
    circleTimer.delegate = self;
    circleTimer.interval = 30;//一次加30秒
    circleTimer.intervalCount = 8;//1/8圈加一次
    circleTimer.edit = NO;
    [circleTimer setTotalSecondTime:30];//设置初始时间
    [self.view addSubview:circleTimer];
    
//    [circleTimer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).offset(-10);
//        make.top.equalTo(self.view).offset(100);
//        make.bottom.equalTo(self.view).offset(-10);
//        make.left.equalTo(self.view).offset(200);
//    }];
    
//    [circleTimer startTimer];
    
>>>>>>> Stashed changes
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< Updated upstream
=======
- (void)CircleTimerEnd {
    [circleTimer stopTimer];
}

>>>>>>> Stashed changes
@end
