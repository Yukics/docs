#!/bin/sh

set -e

if [[ -z "$TEST" ]]; then
    export DOCS_REPO_URL="https://github.com/Yukics/docs"
    export DOCS_REPO_BRANCH="main"
    export DOCS_REPO_PATH="/workspaces/docs2"

    export QUARTZ_REPO_URL="https://github.com/jackyzha0/quartz"
    export QUARTZ_REPO_BRANCH="v4"
    export QUARTZ_REPO_PATH="/workspaces/quartz"
    export QUARTZ_REPO_BUILD="/public"
fi

rm -rf $DOCS_REPO_PATH
rm -rf $QUARTZ_REPO_PATH

git clone --branch "$DOCS_REPO_BRANCH" "$DOCS_REPO_URL" $DOCS_REPO_PATH
git clone --branch "$QUARTZ_REPO_BRANCH" "$QUARTZ_REPO_URL" $QUARTZ_REPO_PATH

cd $QUARTZ_REPO_PATH
npm install
npx quartz build -d $DOCS_REPO_PATH/obsidian -o $QUARTZ_REPO_BUILD