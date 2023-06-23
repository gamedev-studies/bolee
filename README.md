# sarge-mt
Software Architecture Recovery for Game Engines on Moose. Work in progress.

## Installation
On a Moose 10 image, execute the following code snippet in a Playground:

```Smalltalk
Metacello new
    baseline: 'Sargemt';
    repository: 'github://gamedev-studies/sarge-mt:main';
    onConflict: [ :ex | ex useIncoming ];
    onUpgrade: [ :ex | ex useIncoming ];
    onDowngrade: [ :ex | ex useLoaded ];
    load.
```

Then run:

```Smalltalk
SargemtForm open.
```

## Next features:
- Block button while generating
- Create form "what do you want to do now?": see stats about the model, open tag browser, open arch map
