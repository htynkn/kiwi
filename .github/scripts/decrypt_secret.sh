#!/bin/sh

# Decrypt the file
gpg --quiet --batch --yes --decrypt --passphrase="$LARGE_SECRET_PASSPHRASE" \
--output $HOME/android/key.properties $HOME/.github/secrets/key.properties.gpg


gpg --quiet --batch --yes --decrypt --passphrase="$LARGE_SECRET_PASSPHRASE" \
--output $HOME/.github/secrets/key.jks $HOME/.github/secrets/key.jks.gpg
