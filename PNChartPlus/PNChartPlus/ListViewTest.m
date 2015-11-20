//
//  ListViewTest.m
//  PNChartPlus
//
//  Created by mythware on 11/20/15.
//  Copyright © 2015 wossoneri. All rights reserved.
//

#import "ListViewTest.h"
#import "ResultListViewController.h"
#import "Masonry.h"

@interface ListViewTest () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultListViewController *resultsTableController;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation ListViewTest

- (id)init {
    if (self = [super init]) {
        
        self.dataList=[NSMutableArray arrayWithCapacity:100];
        
        for (NSInteger i=0; i<100; i++) {
            [self.dataList addObject:[NSString stringWithFormat:@"%ld-item",(long)i]];
        }
        
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _resultsTableController = [[ResultListViewController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
        
        self.searchController.searchResultsUpdater = self;
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        self.resultsTableController.tableView.delegate = self;
        
        self.searchController.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.searchBar.delegate = self;
        
//        self.definesPresentationContext = YES;
        
        if (self.searchControllerWasActive) {
            self.searchController.active = self.searchControllerWasActive;
            _searchControllerWasActive = NO;
            
            if (self.searchControllerSearchFieldWasFirstResponder) {
                [self.searchController.searchBar becomeFirstResponder];
                _searchControllerSearchFieldWasFirstResponder = NO;
            }
            
        }
        
        
        [self addSubview:_searchController.searchBar];
        [_searchController.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
            //            make.bottom.equalTo(_tableView.mas_top);
            
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.width.mas_equalTo(320);
        }];
        
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//            make.left.right.bottom.equalTo(self);
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(320);
            make.top.equalTo(_searchController.searchBar.mas_bottom);
            
        }];
        
//        _tableView.contentOffset = CGPointMake(0, _searchController.searchBar.bounds.size.height);
        _tableView.contentInset = UIEdgeInsetsMake(-_searchController.searchBar.bounds.size.height, 0, 0, 0);
        
        [self bringSubviewToFront:_searchController.searchBar];
    }
    return self;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    
    [cell.textLabel setText:self.dataList[indexPath.row]];
    
    return cell;
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", strippedString];
    
    ResultListViewController *results = (ResultListViewController *)self.searchController.searchResultsController;
    
    
    
    if (results.searchList != nil) {
        [results.searchList removeAllObjects];
    }
    
    results.searchList = [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:predicate]];
    
    [results.tableView reloadData];
    
    
    
}


@end
