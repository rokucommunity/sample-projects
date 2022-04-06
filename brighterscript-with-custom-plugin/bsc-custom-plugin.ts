import { CompilerPlugin, BscFile, isBrsFile } from 'brighterscript';

// plugin factory
export default function () {
    return {
        name: 'no-underscores',
        // post-parsing validation
        afterFileValidate: (file: BscFile) => {
            if (isBrsFile(file)) {
                // visit function statements and validate their name
                file.parser.references.functionStatements.forEach((fun) => {
                    if (fun.name.text.includes('_')) {
                        file.addDiagnostics([{
                            code: 'custom:9000',
                            message: 'Do not use underscores in function names',
                            range: fun.name.range,
                            file
                        }]);
                    }
                });
            }
        }
    } as CompilerPlugin;
};