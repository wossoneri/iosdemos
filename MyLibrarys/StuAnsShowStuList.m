//
//  StuAnsShowStuList.m
//  Quiz
//
//  Created by mythware on 11/19/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "StuAnsShowStuList.h"

#import "StuAnsShowStuListCell.h"
#import "StuAnsShowStuResultController.h"

#import "HelpHeader.h"
#import "QuizProgressResultsCell.h"
#import "ModelEssayAnswer.h"
#import "HelpFunctions.h"

#define CELL_ID     @"MyCell"


@interface StuAnsShowStuList () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>//UISearchControllerDelegate, UISearchResultsUpdating, 
{
    enum QUESTION_TYPE quesType;
//    NSArray *students;
//    NSArray *events;
}

@property (nonatomic, strong) NSArray *students;
@property (nonatomic, strong) NSArray *filteredStudents;
@property (nonatomic, strong) NSArray *events;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) StuAnsShowStuResultController *resultsTableController;

//@property BOOL searchControllerWasActive;
//@property BOOL searchControllerSearchFieldWasFirstResponder;
@property BOOL showFilteredData;

@end




@implementation StuAnsShowStuList

- (id)initWithStudentList:(NSArray *)stuList StudentEvent:(NSArray *)stuEvent QuestionType:(QUESTION_TYPE)type {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        quesType = type;
        _students = [NSArray arrayWithArray:stuList];
        _events = [NSArray arrayWithArray:stuEvent];
        
        self.showFilteredData = NO;
        
//        self.dataList = [NSMutableArray arrayWithCapacity:100];
//        
//        for (NSInteger i = 0; i < 100; i++) {
//            [self.dataList addObject:[NSString stringWithFormat:@"%ld-item",(long)i]];
//        }
        
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _searchBar = [[UISearchBar alloc] init];
        [self.searchBar sizeToFit];
        self.searchBar.delegate = self;
        self.searchBar.placeholder = NSLocalizedString(@"searchStudent", nil);
        self.tableView.tableHeaderView = self.searchBar;
        
//        _resultsTableController = [[StuAnsShowStuResultController alloc] init];
//        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//        [self.searchController.searchBar sizeToFit];
//        self.searchController.dimsBackgroundDuringPresentation = NO;
//        
//        self.searchController.searchResultsUpdater = self;
//        self.searchController.delegate = self;
//        self.searchController.searchBar.delegate = self;
//        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        
        //        self.resultsTableController.tableView.delegate = self;
        
//        HelpFunctions *func = [HelpFunctions new];
//        [func checkTheView:self runAtFirstShow:^{
//            if (self.searchControllerWasActive) {
//                self.searchController.active = self.searchControllerWasActive;
//                _searchControllerWasActive = NO;
//                
//                if (self.searchControllerSearchFieldWasFirstResponder) {
//                    [self.searchController.searchBar becomeFirstResponder];
//                    _searchControllerSearchFieldWasFirstResponder = NO;
//                }
//            }
//        }];
        

        
//        
//        [self addSubview:_searchController.searchBar];
        [self addSubview:_tableView];
//
//        
//        [_searchController.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self);
//            make.width.mas_equalTo(320);
//        }];
//        
//
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SEARCH_LIST_WIDTH);
            make.top.equalTo(self);
        }];
        
        
//        [self addSubview:_resultsTableController.tableView];
//        [_resultsTableController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self);
//            make.centerX.equalTo(self);
//            make.width.mas_equalTo(320);
//            make.top.equalTo(_searchController.searchBar.mas_bottom);
//        }];
        
        
        //        _tableView.contentOffset = CGPointMake(0, _searchController.searchBar.bounds.size.height);
//        _tableView.contentInset = UIEdgeInsetsMake(-_searchController.searchBar.bounds.size.height, 0, 0, 0);
//        _resultsTableController.tableView.contentInset = UIEdgeInsetsMake(-_searchController.searchBar.bounds.size.height, 0, 0, 0);

//        [self bringSubviewToFront:_tableView];
//        [self bringSubviewToFront:_searchController.searchBar];


    }
    return self;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {   // called when text changes (including clear)

//    NSLog(@"text now:%@, text length:%ld", searchText, (unsigned long)searchText.length);

    self.showFilteredData = searchText.length > 0;
    [self filterDataWithText:searchText];
}


#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (QUES_TYPE_ESSAY == quesType) {
        NSString *essayAns;
        if (self.showFilteredData) {
            essayAns = [[self getStudentEventByStuID:((Account *)_filteredStudents[indexPath.row]).accountID].event.answer toEssayAnswer].answer;
            
            
        } else {
            
        }
        
        CGSize sizeToFit = [HelpFunctions findHeightForText:essayAns havingWidth:QUES_RESULT_CELL_WIDTH_SMALL andFont:ESSAY_SHOW_FONT];
        if (sizeToFit.height > 60)
            return sizeToFit.height + 40;
        else
            return 60 + 40;
        
    } else {
        return QUES_RESULT_CELL_WIDTH_SMALL;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.showFilteredData)
        return self.filteredStudents.count;
    else
        return self.students.count;
}

- (StuAnsShowStuListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StuAnsShowStuListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        cell = [[StuAnsShowStuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    
    if (self.showFilteredData) {
        [cell setName:((Account *)_filteredStudents[indexPath.row]).name andPortrait:nil];
        [cell setEvent:[self getStudentEventByStuID:((Account *)_filteredStudents[indexPath.row]).accountID]];
    } else {
        [cell setName:((Account *)_students[indexPath.row]).name andPortrait:nil];
        [cell setEvent:[self getStudentEventByStuID:((Account *)_students[indexPath.row]).accountID]];
    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
//    }
    
//    if (self.showFilteredData)
//        [cell.textLabel setText:self.filteredStudents[indexPath.row]];
//    else
//        [cell.textLabel setText:self.students[indexPath.row]];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *strID;
    if (self.showFilteredData) {
        strID = ((Account *)_filteredStudents[indexPath.row]).accountID;
    } else {
        strID = ((Account *)_students[indexPath.row]).accountID;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedStudentAccountID:)]) {
        [_delegate getSelectedStudentAccountID:strID];
    }
    
}


//#pragma mark - UISearchResultsUpdating
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    
//    [self.filteredDataList removeAllObjects];
//    
//    NSString *searchText = searchController.searchBar.text;
//    // strip out all the leading and trailing spaces
//    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", strippedString];
//    
//    self.filteredDataList = [[self.dataList filteredArrayUsingPredicate:predicate] mutableCopy];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//}

- (void)filterDataWithText:(NSString *)inputString {

    // strip out all the leading and trailing spaces
    NSString *strippedString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", strippedString];
    
    self.filteredStudents = [self.students filteredArrayUsingPredicate:predicate] ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (ModelEvents *)getStudentEventByStuID:(NSString *)stuID {
    for (ModelEvents *events in _events) {
        if ([events.accountID isEqualToString:stuID]) {
            return events;
        }
    }
    return nil;
}

@end
