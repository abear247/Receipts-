//
//  Receipt+CoreDataProperties.m
//  Receipts++
//
//  Created by Alex Bearinger on 2017-02-02.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Receipt+CoreDataProperties.h"

@implementation Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Receipt"];
}

@dynamic amount;
@dynamic note;
@dynamic timestamp;
@dynamic relationship;

@end
