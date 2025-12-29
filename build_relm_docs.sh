#!/usr/bin/env -S bash -euo pipefail

mkdir docs
mkdir docs/stable
mkdir docs/next

mkdir tmp
cd tmp

git clone https://github.com/AaronErhardt/relm4 ./
git checkout stable

# Stable docs
export STABLE=1
find -name "lib.rs" -exec ../append_info.sh {} +
find -name "lib.rs" -exec ../append_doc_feature.sh {} +

cargo update

cd relm4-components
cargo +nightly doc --all-features -Z rustdoc-scrape-examples

cd ../relm4-macros
cargo +nightly doc --all-features
# -Z rustdoc-scrape-examples

cd ..
cargo +nightly doc --all-features -Z rustdoc-scrape-examples

cd ..

mv tmp/target/doc/* docs/stable

# Unstable docs
export STABLE=0
cd tmp

git stash
git checkout main

cargo clean --doc
cargo update

find -name "lib.rs" -exec ../append_info.sh {} +

export RUSTDOCFLAGS="--cfg dox"

cargo +nightly doc --all-features -Z rustdoc-scrape-examples

cd ..

mv tmp/target/doc/* docs/next

rm -rf tmp
