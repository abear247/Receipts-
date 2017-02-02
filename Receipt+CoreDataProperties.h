//
//  Receipt+CoreDataProperties.h
//  Receipts++
//
//  Created by Alex Bearinger on 2017-02-02.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Receipt+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest;

@property (nonatomic) float amount;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSSet<Tag *> *relationship;

@end

@interface Receipt (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Tag *)value;
- (void)removeRelationshipObject:(Tag *)value;
- (void)addRelationship:(NSSet<Tag *> *)values;
- (void)removeRelationship:(NSSet<Tag *> *)values;

@end

NS_ASSUME_NONNULL_END
