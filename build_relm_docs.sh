#!/bin/sh

# Return on error
set -e

mkdir docs
mkdir docs/stable
mkdir docs/next

mkdir tmp
cd tmp

git clone https://github.com/AaronErhardt/relm4 ./

# Stable docs
find -name "lib.rs" -exec ../append_doc_feature.sh {} +

cargo update

cd relm4-components
cargo +nightly doc --all-features -Z rustdoc-scrape-examples=examples

cd ../relm4-macros
cargo +nightly doc --all-features
# -Z rustdoc-scrape-examples=examples

cd ..
cargo +nightly doc --all-features -Z rustdoc-scrape-examples=examples

cd ..

mv tmp/target/doc/* docs/stable

# Unstable docs
cd tmp

git stash
git checkout next

find -name "lib.rs" -exec ../append_doc_feature.sh {} +

cargo clean --doc
cargo update

cd relm4-components
# cargo +nightly doc --all-features
# -Z rustdoc-scrape-examples=examples

cd ../relm4-macros
cargo +nightly doc --all-features -- --cfg dox
# -Z rustdoc-scrape-examples=examples

cd ../relm4
cargo +nightly doc --all-features -Z rustdoc-scrape-examples=examples -- --cfg dox

cd ../..

mv tmp/target/doc/* docs/next

rm -rf tmp
