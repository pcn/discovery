# -*- python -*- 
package(default_visibility = ["//visibility:public"])


load(
  "@io_bazel_rules_python//python:python.bzl",
  "py_binary", "py_library", "py_test"
)

# Download packges from debian (the version is based on what's in the WORKSPACE)
load("@package_bundle//file:packages.bzl", "packages")


# Load the pip_install symbol for my_deps, and create the dependencies'
# repositories.

load("@discovery_deps//:requirements.bzl", "requirement")

PIP_DEPS = [
  requirement("Werkzeug"),
  requirement("python-dateutil"),
  requirement("six"),
  requirement("requests"),
  requirement("Flask"),
  requirement("Flask-Script"),
  requirement("Flask-RESTful"),
  requirement("Flask-Cache"),
  requirement("blinker"),
  requirement("gunicorn"),
  requirement("gevent"),
  requirement("greenlet"),
  requirement("boto"),
  requirement("pynamodb"),
  requirement("statsd"),
]

TEST_DEPS = [
  requirement("pytest"),
  requirement("pytest-mock"),
  requirement("freezegun"),
  requirement("flake8"),
  requirement("nose"),
  requirement("mock"),
]


# Create build info
genrule(
  name = "genpybuildinfo",
  outs = [
    "buildinfo.py",
  ],
  stamp = 1,
  cmd = "./$(location tools/mkpybuildinfo.sh) > \"$@\"",
  tools = [
    "tools/mkpybuildinfo.sh",
  ],
)

py_library(
  name = "buildinfo",
  srcs = [
    ":genpybuildinfo",
  ],
)

BUILD_DEPS = [
        ":buildinfo"
     ]


SOURCES = glob(["app/*.py", "**/version"], exclude=["test*", "setup.py", "build/**", "**/.eggs/**"])
DATA = glob(["**/*.yml"])

py_binary(
    name = "discovery_dev",
    srcs = SOURCES + ["bin/run_dev.py"],
    data = DATA, 
    main = "run_dev.py",
    deps = PIP_DEPS + BUILD_DEPS,
)

py_binary(
    name = "discovery",
    srcs = SOURCES + ["bin/run_gunicorn.py"],
    data = DATA,
    main = "run_gunicorn.py",
    deps = PIP_DEPS + BUILD_DEPS,
    )


# The minimal python image doesn't have libexpat, which we need
# We may need other things too.
#
load("@io_bazel_rules_docker//python:image.bzl", "py_image")

load("@io_bazel_rules_docker//container:image.bzl", "container_image")
load("@io_bazel_rules_docker//container:push.bzl", "container_push")

container_image(
    name = "dependencies_in_image",
    base = "@py_image_base//image",
    debs = [
        packages["libexpat1"],
        packages["dash"],  # Needed because of https://github.com/GoogleCloudPlatform/distroless/issues/150
    ],
    # env = {},  # Docuemnted at https://github.com/lyft/discovery/blob/master/app/settings.py
    ports = ["8080"],  # configurable via the environment, see above
    stamp = True,
)

py_image(
    name = "discovery_dev_image",
    srcs = SOURCES + ["bin/run_dev.py"],
    deps = PIP_DEPS + BUILD_DEPS,
    data = DATA,
    main = "run_dev.py",
    base = ":dependencies_in_image",
)

py_image(
    name = "discovery_image",
    srcs = SOURCES + ["bin/run_gunicorn.py"],
    deps = PIP_DEPS + BUILD_DEPS,
    data = DATA,
    main = "run_gunicorn.py",
    base = ":dependencies_in_image",
)


# Build a .deb of the discovery service

load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar", "pkg_deb")

pkg_tar(
    name = "discovery-gunicorn-libs",
    strip_prefix = "/",
    package_dir = "/opt/lyft-discovery/lib", 
    srcs = SOURCES + PIP_DEPS + BUILD_DEPS,
    mode = "0644",
)

pkg_tar(
    name = "discovery-gunicorn-bin",
    strip_prefix = "/",
    package_dir = "/opt/lyft-discovery/bin", 
    srcs = ["bin/run_gunicorn.py"],
    mode = "0755",
)

pkg_tar(
    name = "discovery-debian-data",
    extension = ".tar.gz",
    deps = [":discovery-gunicorn-libs", ":discovery-gunicorn-bin"],
)


pkg_deb(
    name = "discovery_debian",
    architecture = "amd64",
    built_using = "bazel",
    data = "//:discovery-debian-data",
    depends = [
        "python",
    ],
    # description_file = "debian/description",
    description = "Lyft discovery service for use with envoy",
    homepage = "https://github.com/lyft/discovery",
    maintainer = "Lyft (packaged by https://github.com/pcn)",
    package = "lyft-discovery",
    version = "0.0.1",
)

