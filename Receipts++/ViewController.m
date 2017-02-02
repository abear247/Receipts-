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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray <Receipt*> *receipts;
@property NSArray *tags;
@property NSMutableDictionary *tagsWithReceipts;
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
    self.tagsWithReceipts = [NSMutableDictionary new];
    for(Tag *tag in self.tags){
        NSFetchRequest *request = [Receipt fetchRequest];
        NSArray *receipts = [[self getContext] executeFetchRequest:request error:&error];
        [self.tagsWithReceipts setValue:receipts forKey:tag.tagName];
    }
//    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Tag *tag = self.tags[indexPath.section];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
    NSSet *receipts = tag.relationship;
    
    cell.textLabel.text = self.receipts[indexPath.row].note;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receipts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tags.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.tags[section];
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
