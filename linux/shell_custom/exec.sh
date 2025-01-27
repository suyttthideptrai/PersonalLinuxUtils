# Procedure
# [Unfinished]
# Step 0: move/ replace alias.bashrc to ~/bashrc
# Step 1: Scan for comment pattern
# Step 2: If have, remove pattern and content
# Step 3: If not, next step
# Step 4: Append content to the end of the file
# Step 5: Do source ~/.bashrc
#!/bin/bash


sourceFolder="linux/shell_custom/files"
sourceFiles=("alias.bashrc")
targetFile="bashrc"
targetFolder="bashrc-custom"
script=""

rm -rf $targetFolder
mkdir $targetFolder

for file in ${files[@]}; do
echo "Moving ${file} to ${targetFolder}"
    if [ -f $sourceFolder/$file ]; then
        echo "Moving ${file} to ${targetFolder}"
        mv $sourceFolder/$file $targetFolder
        script+="\nsource ${targetFolder}/${file}"
    else
        echo "File $file does not exist, escaping..."
        exit 1
    fi
done

# Step 1: Scan for comment pattern
ptStart="#[Start]9eaaa9a2-dcce"
ptStop="#[Stop]9cd2-0242ac120002"

count_lines_between_patterns() {
    local start_pattern=$1
    local stop_pattern=$2
    local file=$3
    awk "/$start_pattern/{flag=1;next}/$stop_pattern/{flag=0}flag" $file | wc -l
}

echo "step2"
# Step 2: If have, remove pattern and content
if grep -q "$ptStart" $targetFile; then
    echo "WTF"
    length=$(count_lines_between_patterns "$ptStart" "$ptStop" $targetFile)
    sed -i "/$ptStart/,+${length}d" $targetFile
fi

# Step 3: If not, next step
fullScript="
${ptStart}
# Execute custom bashrc files
${script}
${ptStop}
"

# Step 4: Append content to the end of the file
echo -e "\n$fullScript" >> $targetFile

# Step 5: Do source ~/.bashrc
# source ~/.bashrc