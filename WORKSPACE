# -*- python -*-

# Based on the google/gcr distroless repo, get package lists from
# debian snapshot package repos, and pull packages from there This
# gives us a way to fetch packages from debian stable, from a point in
# time snapshot to it should give us control of the final build in
# terms of having a reproducable container build.

git_repository(
    name = "distroless",
    remote = "https://github.com/GoogleCloudPlatform/distroless.git",
    commit = "d061f8989a5fc1c59f2e84bfedb299a5fbb20cb6",
)

load(
    "@distroless//package_manager:package_manager.bzl",
    "package_manager_repositories",
    "dpkg_src",
    "dpkg_list",
)

package_manager_repositories()

dpkg_src(
    name = "debian_stretch",
    arch = "amd64",
    distro = "stretch",
    sha256 = "9aea0e4c9ce210991c6edcb5370cb9b11e9e554a0f563e7754a4028a8fd0cb73",
    snapshot = "20171101T160520Z",
    url = "http://snapshot.debian.org/archive",
)

dpkg_src(
    name = "debian_stretch_backports",
    arch = "amd64",
    distro = "stretch-backports",
    sha256 = "ffd68ec4a687a6c8630f647ec32e2fd6dc29d9aa65a40a740b7882ffb6d35ae4",
    snapshot = "20171101T160520Z",
    url = "http://snapshot.debian.org/archive",
)

dpkg_list(
    name = "package_bundle",
    packages = [
        "libc6",
        "ca-certificates",
        "openssl",
        "libssl1.0.2",
        "libexpat1",
        "netbase",
        "tzdata",

        # ctypes
        "dash",
        
        #apm
        "libstdc++6",

        #python
        "libpython2.7-minimal",
        "python2.7-minimal",
        "libpython2.7-stdlib",

        #gunicorn
        "libffi6",
    ],
    sources = [
        "@debian_stretch//file:Packages.json",
        "@debian_stretch_backports//file:Packages.json",
    ],
)


# Docker build rules from https://github.com/bazelbuild/rules_docker
git_repository(
    name = "io_bazel_rules_docker",
    remote = "https://github.com/bazelbuild/rules_docker.git",
    # tag = "v0.3.0",
    commit = "0f186411c31763b05f0aeea8dd3f870080078480"
)

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    container_repositories = "repositories",
)

load(
    "@io_bazel_rules_docker//python:image.bzl",
    _py_image_repos = "repositories",
)

_py_image_repos()

# This is NOT needed when going through the language lang_image
# "repositories" function(s).  But since we modify the base, /shrug
container_repositories()

git_repository(
    name = "io_bazel_rules_python",
    remote = "https://github.com/bazelbuild/rules_python.git",
    commit = "44711d8ef543f6232aec8445fb5adce9a04767f9"
)


# Needed for PIP support:
load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

load("@io_bazel_rules_python//python:pip.bzl", "pip_import")

# Read requirements.txt in and turn each pypi package there into
# requirements that bazel can consume in BUILD files.

# ops_aws
pip_import(
    name = "discovery_deps",
    requirements = "//:requirements.txt",
)

load(
    "@discovery_deps//:requirements.bzl",
    _discovery_deps_install="pip_install"
    )
_discovery_deps_install()

