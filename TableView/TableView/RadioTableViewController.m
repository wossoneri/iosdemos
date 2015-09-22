//
//  RadioTableViewController.m
//  TableView
//
//  Created by mythware on 6/25/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "RadioTableViewController.h"

@interface RadioTableViewController ()

@property (nonatomic, strong) NSMutableArray *radioListArray;
@property (nonatomic, strong) NSMutableArray *radioListArray2;
@property (nonatomic, strong) NSMutableArray *radioImages;

- (IBAction)refresh:(id)sender;

@end

@implementation RadioTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    //old
//    self.radioListArray = @[@"怀旧金曲", @"轻松调频",@"新闻广播", @"劲歌 FM 88.7"];
//    self.radioListArray2 = @[@"Oldies Online", @"Easy FM", @"News Radio", @"HIT FM 88.7"];
//    self.radioImages = @[@"JUGG1.jpg", @"JUGG2.jpg", @"JUGG3.jpg", @"JUGG4.jpg"];

    NSString *path = [[NSBundle mainBundle]pathForResource:@"radioData" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.radioListArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"mainTitle"]];
    self.radioListArray2 = [NSMutableArray arrayWithArray:[dict objectForKey:@"subTitle"]];
    self.radioImages = [NSMutableArray arrayWithArray:[dict objectForKey:@"logoImage"]];
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSLog(@"~~~~~~~~~~~~~~~~");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"------------------");
    return [self.radioListArray count];
}

- (RadioTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"===================");
    static NSString *CellIdentifier = @"Cell";
    RadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[RadioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...

    
//  test with normal text and image
//    cell.textLabel.text = [self.radioListArray objectAtIndex:indexPath.row];
//    
//    cell.imageView.image = [UIImage imageNamed:[self.radioImages objectAtIndex:indexPath.row]];
//    
//    NSLog(@"%@",cell.textLabel.text);

    
//  test with designed view with tag
//    UIImageView *logoImageView = (UIImageView *)[cell viewWithTag:200];
//    logoImageView.image = [UIImage imageNamed:[self.radioImages objectAtIndex:indexPath.row]];
//    
//    UILabel *mainLabel = (UILabel *)[cell viewWithTag:201];
//    mainLabel.text = [self.radioListArray objectAtIndex:indexPath.row];
//    
//    UILabel *secondLabel = (UILabel *)[cell viewWithTag:202];
//    secondLabel.text = [self.radioListArray2 objectAtIndex:indexPath.row];

    
//  test with self designed class cell view ,change UITableViewCell to RadioTableViewCell
    cell.logoImageView.image = [UIImage imageNamed:[self.radioImages objectAtIndex:indexPath.row]];
    cell.mainLabel.text = [self.radioListArray objectAtIndex:indexPath.row];
    cell.subLabel.text = [self.radioListArray2 objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.radioListArray removeObjectAtIndex:indexPath.row];
        [self.radioListArray2 removeObjectAtIndex:indexPath.row];
        [self.radioImages removeObjectAtIndex:indexPath.row];
        
        //test
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.radioListArray forKey:@"mainTitle"];
        [dict setObject:self.radioListArray2 forKey:@"subTitle"];
        [dict setObject:self.radioImages forKey:@"logoImage"];
        
        
        //ios中可改写的文件通常是放在App所在沙盒中的NSDocumentDirectory路径下
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, @"radioData.plist"];
        //NSString *path = [[NSBundle mainBundle]pathForResource:@"radioData" ofType:@"plist"];
        [dict writeToFile:path atomically:YES];
        
        
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //这个版本不要貌似也可以
        [tableView reloadData];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *radioName = [self.radioListArray objectAtIndex:indexPath.row];
    NSString *alertMsg = [NSString stringWithFormat:@"你选择了:%@", radioName];
    
    UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"提示框"
                                                          message:alertMsg
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil,
                                 nil];
    [messageAlert show];
    
    
    //check
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 对号
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // >号
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 编不过
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
}


- (IBAction)refresh:(id)sender {
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t otherQ = dispatch_queue_create("Q", NULL);
    dispatch_async(otherQ, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    });
}
@end
