#!/bin/bash
dat=$(date +"%Y-%m-%d")
tim=$(date +"%Y-%m-%d %H:%M")
post=_post/${dat}-${1}.md
touch $post
echo "---" >> $post 
echo "layout: post" >> $post 
echo "title: $1" >> $post 
echo "date: $tim" >> $post 
echo "tags: []" >> $post 
echo "toc: true" >> $post 
echo "---" >> $post 
