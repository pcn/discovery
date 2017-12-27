# Using bazel to build/run/test discovery

This branch uses bazel to build discovery.

To run the code live from the repository using the development server:

`bazel run //:discovery_dev`: runs wsgi.py development server.

To run the code using the non-reloading gunicorn server:
`bazel run //:discovery`: runs discovery under gunicorn 

To package up the dev server as a docker image:
`bazel build //:discovery_dev_image`

To package up the gunicorn server as a docker image:
`bazel build //:discovery_image`

To package up a `.deb` package:
`bazel build //:discovery_debian`

Note that the debian packages and docker image haven't been tested at all yet.
