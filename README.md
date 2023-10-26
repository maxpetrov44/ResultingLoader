# ResultingLoader
## Brief description
Simple loader alike android one, but with one extented capability - animating proceeding to result.
Recently had some task from UX/UI mates to create such a thing, hope you find it useful in your projects! 
## Version
1.0
## Getting started
1. get copy of this package;
2. add it to your project;
3. and you're all done :)
## Usage
1. import `ResultingLoader` to file of interest;
2. create instance of `ResultingLoader.Self`, like `let loader = ResultingLoader()`, or with any desired configuration;
3. start loader animation with `loader.start()`
4. finish animation either with setting `loader.result` to `.some(provide *ResultingLoaderResult*)` or `.finish()`
## Useful moments
1. Please dont limit `frame` of instances of `RersultingLoader` ude to its being configured via `size: ResultingLoaderSize` parameter;
2. Changing `.size` stops all ongoing animations;
3. Changing `animationSpeed` does not affect any ongoing animations. New value will be used for next call of the `.start()`;
