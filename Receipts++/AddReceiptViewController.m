//
//  AddReceiptViewController.m
//  Receipts++
//
//  Created by Alex Bearinger on 2017-02-02.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//

#import "AddReceiptViewController.h"
#import "AppDelegate.h"
#import "Receipt+CoreDataClass.h"
#import "Tag+CoreDataClass.h"

@interface AddReceiptViewController ()
@property NSSet <Tag*>*tags;
@property NSArray *tagArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSMutableSet *selectedTags;


@end

@implementation AddReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tagArray = @[@"Personal",@"Family",@"Business"];
    [self.tags setByAddingObjectsFromArray:self.tagArray];
    self.selectedTags = [NSMutableSet new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAdd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveReceipt:(id)sender {
    NSString *amount = self.amount.text;
    NSString *note = self.note.text;
    NSDate *date = self.datePicker.date;
    NSManagedObjectContext *context = [self getContext];
    Receipt *receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:context];
    receipt.amount = [amount floatValue];
    receipt.note = note;
    receipt.timestamp = date;
    for (Tag *tag in self.selectedTags){
        NSMutableSet *receipts = [tag.relationship mutableCopy];
        [receipts addObject:receipt];
        tag.relationship = [receipts copy];
        NSError *error;
        if(![tag.managedObjectContext save:&error])
            NSLog(@"nope");
    }
    receipt.relationship = self.selectedTags;
    [[self appDelegate] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tagArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.tagArray[indexPath.row];
    return cell;;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Categories";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    NSFetchRequest *request = [Tag fetchRequest];
    NSError *error;
    bool added = NO;
    NSArray *tags = [[self getContext] executeFetchRequest:request error:&error];
    for (Tag *tag in tags){
        if([tag.tagName isEqualToString:cell.textLabel.text]){
            [self.selectedTags addObject:tag];
            added = YES;
        }
    }
    if(!added){
        Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:[self getContext]];
        newTag.tagName = cell.textLabel.text;
        [self.selectedTags addObject:newTag];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSFetchRequest *request = [Tag fetchRequest];
    NSError *error;
    bool removed = NO;
    NSArray *tags = [[self getContext] executeFetchRequest:request error:&error];
    for (Tag *tag in tags){
        if([tag.tagName isEqualToString:cell.textLabel.text]){
            [self.selectedTags removeObject:tag];
            removed = YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
