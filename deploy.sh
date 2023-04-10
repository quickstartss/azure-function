#!/bin/bash
azure_dir=$(realpath `dirname $0`)
outDir=$(realpath -m $azure_dir/../dist/.azure)

echo $outDir | xargs mkdir -p
cd $outDir;

cp $azure_dir/*.json ./
jq '.main = "dist/azure/src/functions/*.js"' $azure_dir/../package.json > ./package.json

ref=$(realpath --relative-to="." "$azure_dir/tsconfig.json")
cat >tsconfig.json<<EOF
{
  "extends": "$ref",
  "compilerOptions": {
    "outDir": "dist"
  },
}
EOF
tsc

npm i --omit=dev
az functionapp list --output table
read -p "Enter appname: " appname
func azure functionapp publish $appname

echo "func azure functionapp logstream $appname"