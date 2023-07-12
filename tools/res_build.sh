#!/usr/bin/env bash

# 定义资源目录和输出目录
resourcesDir="assets/images"
outputDir="lib"

# 切换到资源目录，获取资源数量和数据
cd "$resourcesDir" || exit
resCount=$(find ./* | wc -l | sed -e 's/^[[:space:]]*//')
resources=$(ls)

# 切换到输出目录
cd ../..
cd "$outputDir" || exit

# 遍历资源文件并汇总资源名集合
declare -a resNames
for resource in $resources; do
  resNames+=("$resource")
done

# 创建资源r文件
progress=1
# 删除r文件
rm -f r.dart
# 类名写入r文件
echo 'class R {' >>r.dart
# 循环申明常量写入r文件
for resName in "${resNames[@]}"; do
  nameSlices=($(echo "$resName" | tr '_' ' ' | tr '.' ' '))
  str=""
  for slice in "${nameSlices[@]}"; do
    str+="${slice}_"
  done
  resConstant="${str%?}"
  echo -ne "${progress}/${resCount}:${resName} \r"
  printf "  static const String %s = '%s/%s';\n" "$resConstant" "$resourcesDir" "$resName" >>r.dart
  progress=$((progress + 1))
done
echo '}' >>r.dart

# 自动格式化 Dart 代码文件
dart format --fix r.dart
