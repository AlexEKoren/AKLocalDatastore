//
//  AKTableViewController.m
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "AKTableViewController.h"
#import "AKTableViewCell.h"
#import "PFObject+AKLocalDatastore.h"

@interface AKTableViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation AKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
    [self.tableView registerClass:[AKTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)reloadData {
    //loads data from local datastore
    PFQuery *localQuery = [PFQuery queryWithClassName:@"YOUR CLASS NAME HERE"];
    [localQuery fromLocalDatastore];
    [localQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.objects = objects;
        //reload the data in the tableview
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"";
    
    if (indexPath.row < self.objects.count) {
        //get the object from the objects we queried
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        //set the name of the column that holds the file we want to retrieve
        object.fileColumnName = @"Image";
        cell.object = object;
    } else {
        cell.textLabel.text = @"Reload the objects image file data";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        [self reloadData];
    }
}

@end
