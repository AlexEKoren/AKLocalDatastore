//
//  AKTableViewCell.m
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "AKTableViewCell.h"

@interface AKTableViewCell ()

@property (nonatomic, strong) UIImageView *fileDataImageView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *retrievalTypeLabel;

@end

@implementation AKTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    self.fileDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    self.fileDataImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.fileDataImageView];
    
    self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height / 2)];
    self.infoLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.infoLabel];
    
    self.retrievalTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height, self.frame.size.height /2, self.frame.size.width - self.frame.size.height, self.frame.size.height / 2)];
    self.retrievalTypeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.retrievalTypeLabel];
    
    return self;
}

- (void)setObject:(PFObject *)object {
    _object = object;
    self.infoLabel.text = object[@"Name"];
    //retrieve the file data
    [self.object getFileDataWithBlock:^(NSData *fileData, AKFileDataRetrievalType retrievalType) {
        //once its got it, do whatever you need with it
        //in this case, convert it to an image to present
        self.fileDataImageView.image = [UIImage imageWithData:fileData];
        
        //just in case, here is how it was retrieved
        if (retrievalType == AKFileDataRetrievalTypeCache) {
            self.retrievalTypeLabel.text = @"Retrieved from local cache!";
        } else if (retrievalType == AKFileDataRetrievalTypeLocal) {
            self.retrievalTypeLabel.text = @"Retrieved from local storage!";
        } else {
            self.retrievalTypeLabel.text = @"Retrieved from the Parse remote database!";
        }
    }];
}

@end
