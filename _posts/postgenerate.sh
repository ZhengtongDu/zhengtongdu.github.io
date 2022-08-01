#!/bin/bash
dat=$(date +"%Y-%m-%d")
tim=$(date +"%Y-%m-%d %H:%M")
touch ${dat}-${1}.md
echo "---" >> ${dat}-${1}.md
echo "layout: post" >> ${dat}-${1}.md
echo "title: $1" >> ${dat}-${1}.md
echo "date: $tim" >> ${dat}-${1}.md
echo "tags: []" >> ${dat}-${1}.md
echo "toc: true" >> ${dat}-${1}.md
echo "---" >> ${dat}-${1}.md
