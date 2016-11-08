#!/bin/bash

# Refresh the public html symlink.
rm -rf /var/www/public
ln -s /var/www/snapshot/public /var/www/public
