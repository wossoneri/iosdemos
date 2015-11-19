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
    
    UISearchController *searchController;
    UITableViewController *tableViewController;
    
}
@end


@implementation SearchView

- (id)init {
    if (self = [super init]) {
        self.dataList=[NSMutableArray arrayWithCapacity:100];
        
        for (NSInteger i=0; i<100; i++) {
            [self.dataList addObject:[NSString stringWithFormat:@"%ld-item",(long)i]];
        }
        
        
        searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.searchBar.delegate = self;
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.hidesNavigationBarDuringPresentation = NO;
        
        tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableViewController.tableView.delegate = self;
        tableViewController.tableView.dataSource = self;
        tableViewController.tableView.tableHeaderView = searchController.searchBar;
        
        
        [self addSubview:tableViewController.tableView];
        [tableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    
    return self;
}



#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchController.active) {
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
    
    if (searchController.active) {
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
    
    [tableViewController.tableView reloadData];
    
}













@end
