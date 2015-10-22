//
//  ViewController.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/19/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "ViewController.h"
#import "PieChartView.h"
#import "HistogramDistribution.h"
#import "HistogramStatistics.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *array;
    
    PieChartView *pieChart;
    HistogramStatistics *histogramS;
    HistogramDistribution *histogramD;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIButton *Histogram1;
@property (nonatomic, strong) UIButton *Histogram2;
@property (nonatomic, strong) UIButton *PieChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    
    self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showButton.titleLabel setFont:font];
    [self.showButton setTitle:@"showPicker" forState:UIControlStateNormal];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.showButton setTag:1];
    [self.showButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideButton.titleLabel setFont:font];
    [self.hideButton setTitle:@"hidePicker" forState:UIControlStateNormal];
    [self.hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hideButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.hideButton setTag:2];
    [self.hideButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.showButton];
    [self.view addSubview:self.hideButton];
    
    [self.showButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.hideButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *view1 = NSDictionaryOfVariableBindings(_showButton, _hideButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_showButton(==_hideButton)]-20-[_hideButton]-50-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:view1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_showButton(==40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:view1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_hideButton(==40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:view1]];
    
    
    self.Histogram1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.Histogram1.titleLabel setFont:font];
    [self.Histogram1 setTitle:@"Histogram1" forState:UIControlStateNormal];
    [self.Histogram1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Histogram1 setBackgroundColor:[UIColor darkGrayColor]];
    [self.Histogram1 setTag:3];
    [self.Histogram1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.Histogram2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.Histogram2.titleLabel setFont:font];
    [self.Histogram2 setTitle:@"Histogram2" forState:UIControlStateNormal];
    [self.Histogram2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Histogram2 setBackgroundColor:[UIColor darkGrayColor]];
    [self.Histogram2 setTag:4];
    [self.Histogram2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.PieChart = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.PieChart.titleLabel setFont:font];
    [self.PieChart setTitle:@"PieChart" forState:UIControlStateNormal];
    [self.PieChart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.PieChart setBackgroundColor:[UIColor darkGrayColor]];
    [self.PieChart setTag:5];
    [self.PieChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.Histogram1];
    [self.view addSubview:self.Histogram2];
    [self.view addSubview:self.PieChart];
    
    [self.Histogram1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.Histogram2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.PieChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *view2 = NSDictionaryOfVariableBindings(_Histogram1, _Histogram2, _PieChart);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_Histogram1(==_Histogram2)]-20-[_Histogram2(==_PieChart)]-20-[_PieChart]-50-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:view2]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_showButton]-20-[_Histogram1(==40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_showButton, _Histogram1)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_showButton]-20-[_Histogram2(==40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_showButton, _Histogram2)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_showButton]-20-[_PieChart(==40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_showButton, _PieChart)]];
    
    
    
    
    
    
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    self.picker.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.picker];
    
    
    array = @[@"AAAAAAAAA",
              @"BBBBBBBBB",
              @"CCCCCCCCC",
              @"DDDDDDDDD",
              @"EEEEEEEEE",
              @"FFFFFFFFF"];
    
    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonClicked:(id)sender {
    switch ( ((UIButton *)sender).tag ) {
        case 1:
        {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.picker.bounds.size.height);
//            self.picker.transform = transform;
//            [UIView commitAnimations];
            
     
////alertView style
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert Title"
//                                                                           message:@"This is a message"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction *action){}];
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
            
            
            
//actionsheet style
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Student Filtration"
                                                                           message:@"show the students whose answer is:"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *correct = [UIAlertAction actionWithTitle:@"correct"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                          [alert dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                                                       }];
            UIAlertAction *wrong = [UIAlertAction actionWithTitle:@"wrong"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            UIAlertAction *unfinished = [UIAlertAction actionWithTitle:@"unfinished"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            
            [alert addAction:correct];
            [alert addAction:wrong];
            [alert addAction:unfinished];
            [alert addAction:cancel];
            
            alert.popoverPresentationController.sourceView = self.showButton;
            alert.popoverPresentationController.sourceRect = self.showButton.bounds;
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
////ActionSheet
//            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"title show when not nil"
//                                                                     delegate:self
//                                                            cancelButtonTitle:@"cancel"
//                                                       destructiveButtonTitle:@"ok"
//                                                            otherButtonTitles:@"item1", @"item2", nil];
//            actionsheet.actionSheetStyle = UIActionSheetStyleDefault;
//            [actionsheet showInView:self.view];
            
            
            
        }
            break;
        case 2:
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.25];
//            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0, self.picker.bounds.size.height);
//            self.picker.transform = transform1;
//            [UIView commitAnimations];
            break;
            
        case 3:
        {
            if (pieChart)
                [pieChart removeFromSuperview];
            if (histogramD)
                [histogramD removeFromSuperview];

            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:[NSNumber numberWithInt:2]];
            [arr addObject:[NSNumber numberWithInt:20]];
            [arr addObject:[NSNumber numberWithInt:14]];
            [arr addObject:[NSNumber numberWithInt:6]];
            [arr addObject:[NSNumber numberWithInt:3]];
            
            histogramS = [[HistogramStatistics alloc] init];
            [histogramS setHorizentalMin:0 Max:25 interval:5 andUnit:@"时间/分"];
            [histogramS setVerticalMin:0 Max:25 interval:5 andUnit:@"人数"];
            [histogramS setTotalValues:arr];
            
            [self.view addSubview:histogramS];
            [histogramS setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[histogramS]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(histogramS)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_Histogram1]-50-[histogramS]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_Histogram1, histogramS)]];
            
            
        }
            break;
        case 4:
        {
            if (pieChart)
                [pieChart removeFromSuperview];
            if (histogramS)
                [histogramS removeFromSuperview];
            
            NSMutableArray *options = [NSMutableArray array];
            [options addObject:@"A"];
            [options addObject:@"B"];
            [options addObject:@"C"];
            [options addObject:@"D"];
            
            NSMutableArray *results = [NSMutableArray array];
            [results addObject:[NSNumber numberWithInt:5]];
            [results addObject:[NSNumber numberWithInt:3]];
            [results addObject:[NSNumber numberWithInt:35]];
            [results addObject:[NSNumber numberWithInt:2]];

            
            histogramD = [[HistogramDistribution alloc] init];
            [histogramD setHorizentalMin:0 Max:45 interval:5 andUnit:@"人数"];
            [histogramD setVerticalUnit:@"选项"];
            [histogramD setTotalValues:results andOptions:options];
            
            [self.view addSubview:histogramD];
            [histogramD setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[histogramD]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(histogramD)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_Histogram1]-50-[histogramD]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_Histogram1, histogramD)]];
            
        }
            break;
        case 5:
        {
            if (histogramS)
                [histogramS removeFromSuperview];
            if (histogramD)
                [histogramD removeFromSuperview];
            
            NSMutableArray *nums = [NSMutableArray array];
            [nums addObject:[NSNumber numberWithInt:1]];
            [nums addObject:[NSNumber numberWithInt:7]];
            [nums addObject:[NSNumber numberWithInt:2]];
            //    for (int index = 0; index < 8; index++) {
            //        [nums addObject:[NSNumber numberWithInteger:index + 1]];
            //    }
            
            NSMutableArray *color = [NSMutableArray array];
            [color addObject:[UIColor colorWithRed:0x93 / 255.0 green:0x93 / 255.0 blue:0x93 / 255.0 alpha:1.0]];
            [color addObject:[UIColor colorWithRed:0x22 / 255.0 green:0xa1 / 255.0 blue:0x2c / 255.0 alpha:1.0]];
            [color addObject:[UIColor colorWithRed:0xee / 255.0 green:0x88 / 255.0 blue:0x63 / 255.0 alpha:1.0]];
            
            pieChart = [[PieChartView alloc] init];
            [pieChart setResults:nums];
            [pieChart setColors:color];
            
            [self.view addSubview:pieChart];
            [pieChart setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[pieChart]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(pieChart)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_Histogram1]-50-[pieChart]-50-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_Histogram1, pieChart)]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Picker Delegate
- (NSAttributedString *)pickerView:(nonnull UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (CGFloat)pickerView:(nonnull UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(nonnull UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.bounds.size.width;
}

- (NSString *)pickerView:(nonnull UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [array objectAtIndex:row];
}

#pragma mark - Picker DataSource
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return array.count;
}

@end
