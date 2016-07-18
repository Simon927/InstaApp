//
//  ShareButton.m
//  startMe
//
//  Created by Matteo Gobbi on 11/11/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton

-(void)awakeFromNib {
    [self setTitle:[@" " stringByAppendingString:NSLocalizedString(@"btSharePost", nil)] forState:UIControlStateNormal];
}


@end
