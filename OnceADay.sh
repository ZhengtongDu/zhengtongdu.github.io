#!/bin/bash
rm ./_posts/*.html
git add .
git commit -m "The day is over."
git push -u origin main
