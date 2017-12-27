#!/usr/bin/env python

from __future__ import unicode_literals

import gunicorn.app.base
from gunicorn.six import iteritems
import app


class StandaloneApplication(gunicorn.app.base.BaseApplication):

    def __init__(self, app, options=None):
        self.options = options or {}
        self.application = app
        super(StandaloneApplication, self).__init__()

    def load_config(self):
        config = dict([(key, value) for key, value in iteritems(self.options)
                       if key in self.cfg.settings and value is not None])
        for key, value in iteritems(config):
            self.cfg.set(key.lower(), value)

    def load(self):
        return self.application



if __name__ == '__main__':
    options = {
        'bind': '%s:%s' % ('0.0.0.0', '9090'),
        'workers': 10,
        'worker_class': 'eventlet',
        'worker_connections': 200,
        'max_requests': 100,
        'max_requests_jitter': 10,
        'timeout': 90,
        'preload_app': True,
    }
    # import code
    # code.interact()
    StandaloneApplication(app, options).run()
