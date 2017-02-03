//
//  TagObject.h
//  Receipts++
//
//  Created by Alex Bearinger on 2017-02-02.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Receipt+CoreDataClass.h"

@interface TagObject : NSObject
@property NSString *name;
@property NSArray <Receipt*> *receipts;
@end
