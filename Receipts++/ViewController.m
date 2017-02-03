//
//  ViewController.m
//  Receipts++
//
//  Created by Alex Bearinger on 2017-02-02.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Receipt+CoreDataClass.h"
#import "Tag+CoreDataClass.h"
#import "TagObject.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray <TagObject*> *tagObjectArray;
@property NSArray <Tag*> *tags;
//@property NSMutableDictionary *tagsWithReceipts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
   
}

-(void)viewWillAppear:(BOOL)animated{
    NSError *error;
    
    
    NSFetchRequest *request = [Tag fetchRequest];
    self.tags = [[self getContext] executeFetchRequest:request error:&error];
    self.tagObjectArray = [NSMutableArray new];
    for(Tag *tag in self.tags){
        NSFetchRequest *request = [Receipt fetchRequest];
        [request setPredicate:[NSPredicate predicateWithFormat:@"relationship.tagName CONTAINS[cd] %@", tag.tagName]];
        NSArray *receipts = [[self getContext] executeFetchRequest:request error:&error];
        TagObject *tagObject = [TagObject new];
        tagObject.receipts = receipts;
        tagObject.name = tag.tagName;
        [self.tagObjectArray addObject:tagObject];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    TagObject *tagObject = self.tagObjectArray[indexPath.section];
    Receipt *receipt = tagObject.receipts[indexPath.item];
    cell.textLabel.text = receipt.note;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tagObjectArray[section].receipts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tagObjectArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.tagObjectArray[section].name;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![[self getContext] save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

#pragma mark - Core Data methods

- (NSManagedObjectContext *)getContext {
    return [self getContainer].viewContext;
}

- (NSPersistentContainer *)getContainer{
    return [self appDelegate].persistentContainer;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}




 

@end
