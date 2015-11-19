//
//  SearchView.m
//  PNChartPlus
//
//  Created by mythware on 11/19/15.
//  Copyright © 2015 wossoneri. All rights reserved.
//

#import "SearchView.h"
#import "Masonry.h"
#define CELL_ID @"MyCell"

@interface SearchView () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>
{
//    UISearchBar *searchBar;
    
    
    
    
}


@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *tableViewController;

@end


@implementation SearchView

- (id)init {
    if (self = [super init]) {
        self.dataList=[NSMutableArray arrayWithCapacity:100];
        
        for (NSInteger i=0; i<100; i++) {
            [self.dataList addObject:[NSString stringWithFormat:@"%ld-item",(long)i]];
        }
        
        self.tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];

        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.tableViewController.tableView.delegate = self;
        self.tableViewController.tableView.dataSource = self;
        self.tableViewController.tableView.tableHeaderView = self.searchController.searchBar;
        
        
//        [self addSubview:self.searchController.searchBar];
        [self addSubview:self.tableViewController.tableView];
        
//        [_searchController.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.bottom.equalTo(_tableViewController.tableView.mas_top);
//        }];
        
        [_tableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_searchController.searchBar.mas_bottom);
//            make.left.right.bottom.equalTo(self);
            make.edges.equalTo(self);
        }];
        
    }
    
    return self;
}



#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        return [self.searchList count];
    } else {
        return [self.dataList count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    if (_searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    } else {
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    
    return cell;
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [searchController.searchBar text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    
    self.searchList = [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:predicate]];
    
    [_tableViewController.tableView reloadData];
    
}













@end
