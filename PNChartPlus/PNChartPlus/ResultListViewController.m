//
//  ResultListViewController.m
//  PNChartPlus
//
//  Created by mythware on 11/20/15.
//  Copyright © 2015 wossoneri. All rights reserved.
//

#import "ResultListViewController.h"

@implementation ResultListViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyResultCell"];
    }
    
    [cell.textLabel setText:self.searchList[indexPath.row]];
    
    return cell;
}

@end
