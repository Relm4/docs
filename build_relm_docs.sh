#!/usr/bin/env -S bash -euo pipefail

mkdir --parents docs/{stable,next} tmp
pushd tmp

git clone --depth 1 --no-single-branch -- https://github.com/Relm4/Relm4 ./
git switch --detach $(git tag --list --sort "v:refname" | grep -v - | tail -n 1)

# Stable docs
export STABLE=1
find -name "lib.rs" -exec ../append_info.sh {} +
find -name "lib.rs" -exec ../append_doc_feature.sh {} +

cargo update

pushd relm4-components
cargo +nightly doc --all-features -Z rustdoc-scrape-examples
popd

pushd relm4-macros
cargo +nightly doc --all-features
# -Z rustdoc-scrape-examples
popd

cargo +nightly doc --all-features -Z rustdoc-scrape-examples

popd

mv tmp/target/doc/* docs/stable

# Unstable docs
export STABLE=0
pushd tmp

git stash
git switch main

cargo clean --doc
cargo update

find -name "lib.rs" -exec ../append_info.sh {} +

export RUSTDOCFLAGS="--cfg dox"

cargo +nightly doc --all-features -Z rustdoc-scrape-examples

popd

mv tmp/target/doc/* docs/next

rm -rf tmp
