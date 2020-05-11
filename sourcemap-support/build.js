/**
 * This script removes all empty lines
 */

var sourceMap = require('source-map');
var fsExtra = require('fs-extra');
var glob = require('glob-all');
var path = require('path');

//create and empty out the `dist` folder
fsExtra.ensureDirSync('dist');
fsExtra.emptyDirSync('dist');
fsExtra.ensureDirSync('dist/source');

//copy the manifest file to dist
fsExtra.copyFileSync('src/manifest', 'dist/manifest');

var srcDir = path.resolve('src');
var distDir = path.resolve('dist');

//Recursively find every BrightScript file in the src folder
var filePaths = glob.sync([
    'src/**/*.brs'
], {
    //get absolute file paths
    absolute: true
});


//for each file, remove empty lines and write the new file and its sourcemap to `dist`
filePaths.forEach((srcFilePath) => {
    srcFilePath = path.normalize(srcFilePath);
    let distFilePath = srcFilePath.replace(srcDir, distDir);
    let fileContents = fsExtra.readFileSync(srcFilePath).toString();
    let chunks = [];

    //split the file by newline (support `\n` and `\r\n`)
    let lines = fileContents.split(/\r?\n/g);
    for (let originalLineIndex = 0; originalLineIndex < lines.length; originalLineIndex++) {
        if (lines[originalLineIndex].length > 0) {
            //separate chunks by newline
            if (chunks.length > 0) {
                chunks.push('\n');
            }
            chunks.push(
                //Make a SourceNode with the ORIGINAL location and the new text (in this case the line content is unchanged)
                new sourceMap.SourceNode(
                    //source map lines are 1-indexed
                    originalLineIndex + 1,
                    //source map columns are 0-indexed
                    0,
                    //where this line originally came from
                    srcFilePath,
                    //add the line text
                    lines[originalLineIndex]
                )
            );
        }
    }

    //generate the new source code and map
    var codeAndMap = new sourceMap.SourceNode(null, null, srcFilePath, chunks).toStringWithSourceMap();
    //write the files `dist`
    fsExtra.writeFileSync(distFilePath, codeAndMap.code);
    fsExtra.writeFileSync(distFilePath + '.map', codeAndMap.map.toString());
});
