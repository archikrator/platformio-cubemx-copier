#!/bin/bash


PROJECT_PATH=CubeMX/$(ls CubeMX/)

DIFF_LIST=

scan_files () {
for file in $(ls ${PROJECT_PATH}/$1); do
    if [ -e "src/${file}" ]; then
        diff ${PROJECT_PATH}/${1}/${file} src/$file 2>&1 >/dev/null || DIFF_LIST=$(echo $DIFF_LIST $1/$file)
    else
        echo "New file ${file} will be created"
    fi
done
}

for i in $(echo Inc Src); do
    scan_files $i
done

test -z ${DIFF_LIST} && echo "No changes" && exit 0


for i in $(echo $DIFF_LIST); do
    code --diff ${PROJECT_PATH}/${i} src/$(echo $i | cut -f2 -d'/')
done


echo "Accept changes?[y/N]"
while read -r odp
do
    if [[ "${odp}" == "y" ]]; then
        echo "Copying new files to project."
        cp ${PROJECT_PATH}/{Src,Inc}/* src/
    fi
    break
done
