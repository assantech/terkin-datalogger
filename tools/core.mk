# -----------
# Environment
# -----------

$(eval venv2path    := .venv2)
$(eval pip2         := $(venv2path)/bin/pip)
$(eval python2      := $(venv2path)/bin/python)
$(eval platformio   := $(venv2path)/bin/platformio)

$(eval venv3path    := .venv3)
$(eval pip3         := $(venv3path)/bin/pip)
$(eval python3      := $(venv3path)/bin/python)
$(eval ampy         := $(venv3path)/bin/ampy)
$(eval rshell       := $(venv3path)/bin/rshell)
$(eval miniterm     := $(venv3path)/bin/miniterm.py)

$(eval bumpversion  := $(venv3path)/bin/bumpversion)


# ------------------
# Python virtualenvs
# -------------------
setup-virtualenv2:
	@test -e $(python2) || `command -v virtualenv` --python=python2 --no-site-packages $(venv2path)

setup-virtualenv3:
	@test -e $(python3) || `command -v virtualenv` --python=python3 --no-site-packages $(venv3path)
	$(pip3) --quiet install --requirement requirements-dev.txt

setup-environment: setup-virtualenv3


# -----------
# Workstation
# -----------
# Minimal operating system detection for Windows
# https://renenyffenegger.ch/notes/development/make/detect-os
# https://gist.github.com/sighingnow/deee806603ec9274fd47
# TODO: Expand this.
# https://stackoverflow.com/questions/714100/os-detecting-makefile/14777895#14777895
ifeq ($(OS),Windows_NT)
    $(eval RUNNING_IN_HELL := true)
endif



# ----------
# PlatformIO
# ----------

install-platformio: setup-virtualenv2
	@$(pip2) install platformio --quiet

build-all: install-platformio
	@$(platformio) run

build-env: install-platformio
	@$(platformio) run --environment $(environment)


# -------
# Release
# -------

# Release this piece of software
# Synopsis:
#   make release bump=minor  (major,minor,patch)
#release: bumpversion push

bumpversion: install-releasetools
	@$(bumpversion) $(bump)

push:
	git push && git push --tags

install-releasetools: setup-virtualenv3
	@$(pip3) install --quiet --requirement requirements-release.txt --upgrade



# -------------
# Miscellaneous
# -------------
sleep:
	@sleep 1

notify:
	@echo "$(status): $(message)"
	@if test "${RUNNING_IN_HELL}" != "true"; then \
		$(python3) tools/terkin.py notify "$(message)" "$(status)"; \
	fi

confirm:
	@# Prompt the user to confirm action.
	$(eval retval := $(shell bash -c 'read -s -p "PROMPT: $(text) [y/n] " outcome; echo $$outcome'))
	@echo

	@if test "$(retval)" != "y"; then \
		exit 1; \
	fi
