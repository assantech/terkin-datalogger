# Monkeypatch the whole machinery to be executable on CPython.

from test.util.micropython import monkeypatch
monkeypatch()

from test.util.terkin import monkeypatch_terkin
monkeypatch_terkin()

from test.util.mqtt import capmqtt

from test.util.mosquitto import mosquitto
