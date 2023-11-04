# bolee
Bolée (pronounced BO-ley) is a tool for Software Architecture Recovery on Moose. Previously called "Sargemt", source code renaming is in progress.

## Installation
On a Moose 10 image, execute the following code snippet in a Playground:

```Smalltalk
Metacello new
    baseline: 'Sargemt';
    repository: 'github://gamedev-studies/bolee:main';
    onConflict: [ :ex | ex useIncoming ];
    onUpgrade: [ :ex | ex useIncoming ];
    onDowngrade: [ :ex | ex useLoaded ];
    load.
```

## How to use
To run Bolée, open a Playground and execute:

```Smalltalk
SargemtForm open.
```

Inform the name and path of the project you want to analyse. You will also need your subsystems identified in CSV format and an include graph in XML format. To create these files, you can use our [Game Engine Analyser](https://github.com/gamedev-studies/game-engine-analyser). After you input all the necessary information, the "generate" button will unlock and you can click it to generate the Moose model. After generation is done, Sarge-mt provides you with shortcuts for inspecting or visualising your model entities.

## Using the tag dependency solver 
You can save a .dot file equivalent to the associations between tags you see in the Architectural Map.

```Smalltalk
    |model solver|
    model := MooseModel root at: 1.
    solver := SargemtTagDepSolver new.
    solver run: model engineName: 'ExampleEngine'.
```
