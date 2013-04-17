//
//  GraphViewController.m
//  Calculator
//
//  Created by alykhan.kanji on 16/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize programLabel = _programLabel;
@synthesize graphView = _graphView;

- (void)setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:graphView action:@selector(pinch:)]];
    self.graphView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *equation = [[CalculatorBrain class] descriptionOfProgram:self.program];
    self.programLabel.text = [NSString stringWithFormat:@"y = %@", [equation length] ? equation : @"0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)yValueForGraphView:(GraphView *)sender withXValue:(float)x
{
    return [[CalculatorBrain class] runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
}

@end
