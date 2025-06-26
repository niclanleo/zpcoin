#!/bin/bash

echo " 自動提交並推送 GDBToken 專案至 GitHub..."

git add .
now=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "自動更新 $now"
git push origin main

echo "已成功推送至 GitHub。"
