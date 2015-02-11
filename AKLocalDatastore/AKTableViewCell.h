//
//  AKTableViewCell.h
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+LocalDatastore.h"

@interface AKTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *object;

@end
