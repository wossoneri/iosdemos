//
//  QuizResultsListView.m
//  Quiz
//
//  Created by mythware on 11/16/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "QuizResultsListView.h"
#import "QuizResultsCell.h"
#import "QuizResultHelper.h"

#import "HelpHeader.h"

#import "ModelImageContent.h"
#import "ModelEvents.h"

@interface QuizResultsListView () <UITableViewDataSource, UITableViewDelegate, CommonScrollHeaderChartDelegate>
{
    UITableViewController *tableViewController;
    
    QuizResultsHeader *header;
    
    NSArray *_stuList;
    NSArray *_receivedEvents;
    ModelPaperItem *_paper;
    ModelQuestionItem *_question;
    
    //
    NSMutableArray *_cellArrayOfStudents;
    NSMutableArray *_cellArrayOfEvents;
    NSMutableArray *_cellTypeArray;
    NSMutableArray *_notEmptyCellIndexs;
    
//    SHOW_ANSWER_TYPE _type;
    NSString *_key;
    
//    CGFloat lastScrollOffset;
    
    NSArray *_timesArray;
}

@end

@implementation QuizResultsListView

- (id)initWithPaper:(ModelPaperItem *)paper students:(NSArray *)stuList events:(NSArray *)stuEvents {
    if (self = [super init]) {
        
//        lastScrollOffset = -RESULT_HEADER_BOTTOM;
        
        _stuList = [NSArray arrayWithArray:stuList];
        _receivedEvents = [NSArray arrayWithArray:stuEvents];
        _paper = paper;
        _question = [paper.questions objectAtIndex:0];
        _cellArrayOfStudents = [NSMutableArray array];
        _cellArrayOfEvents = [NSMutableArray array];
        _cellTypeArray = [NSMutableArray array];
        _notEmptyCellIndexs = [NSMutableArray array];
        
        tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableViewController.tableView.dataSource = self;
        tableViewController.tableView.delegate = self;
//        tableViewController.tableView.separatorInset = UIEdgeInsetsMake(0, PROGRESS_LEFT_OFFSET, 0, PROGRESS_RIGHT_OFFSET);
        tableViewController.tableView.separatorColor = [UIColor colorWithHexString:@"dbdbdb"];
        tableViewController.tableView.allowsSelection = NO;
//        [tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL_ID"];
//        tableViewController.tableView.bounces = NO;
        
        ModelImageContent *content = [ModelImageContent mj_objectWithKeyValues:_question.content];
        UIImage *image = [HelpFunctions stringToUIImage:content.quesDescription];
        
        switch (_question.type) {
            case QUES_TYPE_CHOICE:
            case QUES_TYPE_TRUEFALSE:
            case QUES_TYPE_COMPLETION:
            {
//                _type = SHOW_AS_CORRECT_RATE;
//                _key = KEY_CORRECT_RATE;
                
                NSArray *array = [QuizResultHelper getDataArrayOfPercentageFromStudentList:_stuList studentEvents:_receivedEvents question:_question];

                header = [[QuizResultsHeader alloc] initHeaderWithPercentage:[array objectAtIndex:RESULT_ARRAY_PERCENT] quesImage:image];
                _cellTypeArray = [array objectAtIndex:RESULT_ARRAY_PERCENT_TYPE];
                _cellArrayOfStudents = [array objectAtIndex:RESULT_ARRAY_STUDENTS];
                _cellArrayOfEvents = [array objectAtIndex:RESULT_ARRAY_EVENTS];
                
                if (_notEmptyCellIndexs.count > 0)
                    [_notEmptyCellIndexs removeAllObjects];
                
                for (int index = 0; index < _cellArrayOfStudents.count; ++index) {
                    NSArray *array = _cellArrayOfStudents[index];
                    if (array.count > 0)
                        [_notEmptyCellIndexs addObject:[NSNumber numberWithInt:index]];
                }
            }
                break;
                
            case QUES_TYPE_ESSAY:
            case QUES_TYPE_HANDWRITING:
            case QUES_TYPE_PHOTOGRAPH:
            {
//                _type = SHOW_AS_TIME_DISTRIBUTION;
//                _key = KEY_TIME_DISTRIBUTION;
                
                NSArray *array = [QuizResultHelper getDataArrayOfTimeDistributionFromStudentList:_stuList studentEvents:_receivedEvents paper:_paper];
                
                _timesArray = [array objectAtIndex:0];
                header = [[QuizResultsHeader alloc] initHeaderWithTime:[array objectAtIndex:RESULT_ARRAY_TIME_DESTRIBUTIONS] andCount:[array objectAtIndex:RESULT_ARRAY_TIME_COUNT] quesImage:image];
                _cellArrayOfStudents = [array objectAtIndex:RESULT_ARRAY_STUDENTS];
                _cellArrayOfEvents = [array objectAtIndex:RESULT_ARRAY_EVENTS];

                if (_notEmptyCellIndexs.count > 0)
                    [_notEmptyCellIndexs removeAllObjects];
                
                for (int index = 0; index < _cellArrayOfStudents.count; ++index) {
                    NSArray *array = _cellArrayOfStudents[index];
                    if (array.count > 0)
                        [_notEmptyCellIndexs addObject:[NSNumber numberWithInt:index]];
                }
                
            }break;
                
            case QUES_TYPE_INVESTIGATION:
            {
//                _type = SHOW_AS_ANSWER_DISTRIBUTION;
//                _key = KEY_ANSWER_DISTRIBUTION;
                
                NSArray *array = [QuizResultHelper getDataArrayOfOptionDistributionFromStudentList:_stuList studentEvents:_receivedEvents question:_question];
                
                header = [[QuizResultsHeader alloc] initHeaderWithOptions:array[RESULT_ARRAY_OPTIONS] andCount:array[RESULT_ARRAY_OPTIONS_COUNT] correctIndex:[[array lastObject] intValue] quesImage:image];
                
                _cellArrayOfStudents = [array objectAtIndex:RESULT_ARRAY_STUDENTS];
                _cellArrayOfEvents = [array objectAtIndex:RESULT_ARRAY_EVENTS];
                
                if (_notEmptyCellIndexs.count > 0)
                    [_notEmptyCellIndexs removeAllObjects];
                
                for (int index = 0; index < _cellArrayOfStudents.count; ++index) {
                    NSArray *array = _cellArrayOfStudents[index];
                    if (array.count > 0)
                        [_notEmptyCellIndexs addObject:[NSNumber numberWithInt:index]];
                }
            }
                break;
                
            default:
                break;
        }
        
        header.chartDelegate = self;
        header.headerScrollView = tableViewController.tableView;
        header.headerScrollView.delegate = self;
        header.userInteractionEnabled = YES;
        
        [self addSubview:tableViewController.tableView];
        [self addSubview:header];


        
        [tableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(RESULT_HEADER_BOTTOM);
        }];

        [header recalculateScrollViewSize];
    }
    return self;
    
}


- (void)dealloc {
    @try {
        [header.headerScrollView removeObserver:self forKeyPath:@"contentOffset"];
        NSLog(@"result view dealloc remove observer successful");
    }
    @catch (NSException *exception) {
        NSLog(@"result view dealloc remove observer failed");

    }
}

///增加数据分类算法为list写数据


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notEmptyCellIndexs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float cellHeight;
    
    int cellIndex = [_notEmptyCellIndexs[indexPath.row] intValue];
    
    NSUInteger cellCount = ((NSArray *)_cellArrayOfStudents[cellIndex]).count;
    if (0 == cellCount) {
        cellCount = 1;
    }
    // quesResultCell.m 里的布局间距25
    // 同 analysisList

    switch (_question.type) {
        case QUES_TYPE_CHOICE:
        case QUES_TYPE_TRUEFALSE:
        case QUES_TYPE_INVESTIGATION:
        {
            NSInteger countInRow = floor(([[UIScreen mainScreen] bounds].size.width - 2 * RESULT_COLLECTION_OFFSET_LARGE - QUES_RESULT_CELL_WIDTH_SMALL) / (QUES_RESULT_CELL_WIDTH_SMALL + MARGIN_RESULT_ANSWER_CELL)) + 1;
            NSInteger rows = ceil(cellCount * 1.0 / countInRow);
            
            CGFloat ansHeight = PORTRAIT_HEIGHT + COMMON_LABEL_HEIGHT;
            
            cellHeight = rows * ansHeight + 25 + COMMON_LABEL_HEIGHT + 80;
        }
            break;
            
        case QUES_TYPE_COMPLETION:
        {
            NSInteger countInRow = floor(([[UIScreen mainScreen] bounds].size.width - 2 * RESULT_COLLECTION_OFFSET_LARGE - QUES_RESULT_CELL_WIDTH_LARGE) / (QUES_RESULT_CELL_WIDTH_LARGE + MARGIN_RESULT_ANSWER_CELL)) + 1;
            NSInteger rows = ceil(cellCount * 1.0 / countInRow);
            
            NSInteger blankCount = [_question toCompletionQuestion].options;
            //内容答案高度
            CGFloat ansHeight = blankCount * (COMPLETION_BLANK_HEIGHT + COMPLETION_MARGIN_V) - COMPLETION_MARGIN_V;
            
            cellHeight = rows * (ansHeight + 20) + 25 + COMMON_LABEL_HEIGHT + 80;
        }
            break;
            
        case QUES_TYPE_ESSAY:
        {
            cellCount = ceil(cellCount / 4.0);
            cellHeight = cellCount * 200;
        }
            break;
            
        default:
            break;
    }

    
    return cellHeight; //这个要算
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int cellIndex = [_notEmptyCellIndexs[indexPath.row] intValue];
    
    QuizResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (cell == nil) {
        cell = [[QuizResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID" studentList:[_cellArrayOfStudents objectAtIndex:cellIndex] stuEvents:[_cellArrayOfEvents objectAtIndex:cellIndex] paper:_paper keyForMapSegment:KEY_ANSWER_DISTRIBUTION];
    }
    
    switch (_question.type) {

        case QUES_TYPE_HANDWRITING:
        case QUES_TYPE_PHOTOGRAPH:
        case QUES_TYPE_ESSAY:
        {
            cell.label.text = [NSString stringWithFormat:NSLocalizedString(@"finishedInSecond", nil), [[_timesArray objectAtIndex:cellIndex] intValue]];
            cell.label.textColor = [UIColor colorWithHexString:GRAY_TEXT_IN_RESULT];
        }
            break;
            
        case QUES_TYPE_CHOICE:
        case QUES_TYPE_TRUEFALSE:
        case QUES_TYPE_COMPLETION:
        {
            switch ([[_cellTypeArray objectAtIndex:cellIndex] intValue]) {
                case ANSWER_CORRECT:
                    cell.label.text = NSLocalizedString(@"studentAnsUnfinished", nil);
                    cell.label.textColor = [UIColor colorWithHexString:GRAY_TEXT_IN_RESULT];
                    break;
                case ANSWER_WRONG:
                    cell.label.text = NSLocalizedString(@"studentAnsWrong", nil);
                    cell.label.textColor = [UIColor colorWithHexString:RED_TEXT_IN_RESULT];
                    break;
                case ANSWER_UNFINISHED:
                    cell.label.text = NSLocalizedString(@"studentAnsRight", nil);
                    cell.label.textColor = [UIColor colorWithHexString:GREEN_TEXT_IN_RESULT];
                    break;
                default:
                    break;
            }
        }
            break;
            
        case QUES_TYPE_INVESTIGATION:
        {
            NSArray *texts = [[HelpFunctions getChoiceStyleArrays] objectAtIndex:0];
            
            cell.label.text = [NSString stringWithFormat:NSLocalizedString(@"finishedWithAns", nil), [texts objectAtIndex:cellIndex]];
            cell.label.textColor = [UIColor colorWithHexString:GRAY_TEXT_IN_RESULT];

        }
            break;
    }
    

    

    return cell;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
////    NSLog(@"scroll start offset: %f", scrollView.contentOffset.y);
//    lastScrollOffset = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    lastScrollOffset = scrollView.contentOffset.y;
//}

//结束手指拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollFix:scrollView];
}

//结束减速滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollFix:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollFix:scrollView];
}

- (void)scrollFix:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    
    //以中间值判断自动校正
    CGFloat center = - (RESULT_HEADER_TOP + RESULT_HEADER_BOTTOM) / 3 * 2;
    if (y > -RESULT_HEADER_BOTTOM && y < center) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_BOTTOM) animated:YES];
    }
    if (y > center && y < -RESULT_HEADER_TOP) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_TOP) animated:YES];
    }
    
//    int off = 0; //滑动阈值  超过这个值代表有这个趋势
//    //以滑动方向自动校正
//    if (fabs(y) - fabs(lastScrollOffset) > off) { //向下滑
//        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_BOTTOM) animated:YES];
//    } else if (fabs(y) - fabs(lastScrollOffset) < -off) { //向上滑
//        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_TOP) animated:YES];
//    }
//    
//    lastScrollOffset = y;
}

#pragma mark - scrollHeader
- (void)onChartItemClickedAtIndex:(NSInteger)index {
//    NSLog(@"index is %ld", (long)index);
    
    NSInteger indexShow = [_notEmptyCellIndexs indexOfObject:[NSNumber numberWithInteger:index]];
    if (indexShow != NSNotFound) {
        //    NSLog(@"fix index is %ld", indexShow);
//        [tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexShow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        CGRect cellRect = [tableViewController.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:indexShow inSection:0]];
        
        [tableViewController.tableView scrollRectToVisible:cellRect animated:YES];
    }
}

@end
