# ==============================================================================
# Makefile — Laravel 12 development automation
# ==============================================================================
#
# Requires GNU Make >= 4.0 (relies on .ONESHELL prefix stripping).
#
# Quick start:
#   make help        List every documented target
#   make setup       Install deps, create .env, generate key, link storage
#   make ci          Run the full local CI pipeline
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Make / shell configuration
# ------------------------------------------------------------------------------
SHELL       := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS   += --no-print-directory

# ------------------------------------------------------------------------------
# Project
# ------------------------------------------------------------------------------
PROJECT_NAME    := Laravel Application
PROJECT_VERSION := 1.0.0

# ------------------------------------------------------------------------------
# Colors (only the ones actually used are defined)
# ------------------------------------------------------------------------------
RESET  := \033[0m
BOLD   := \033[1m
RED    := \033[31m
GREEN  := \033[32m
YELLOW := \033[33m
CYAN   := \033[36m

# ------------------------------------------------------------------------------
# Executables
# ------------------------------------------------------------------------------
PHP      := php
COMPOSER := composer
NPM      := npm
NODE     := node
ARTISAN  := $(PHP) artisan
PINT     := ./vendor/bin/pint

# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------
APP_DIR          := app
CONFIG_DIR       := config
DATABASE_DIR     := database
PUBLIC_DIR       := public
RESOURCES_DIR    := resources
ROUTES_DIR       := routes
STORAGE_DIR      := storage
TESTS_DIR        := tests
VENDOR_DIR       := vendor
NODE_MODULES_DIR := node_modules

ENV_FILE      := .env
ENV_EXAMPLE   := .env.example
COMPOSER_FILE := composer.json
PACKAGE_FILE  := package.json
LARAVEL_LOG   := $(STORAGE_DIR)/logs/laravel.log

# ------------------------------------------------------------------------------
# Print helpers (printf interprets the color escapes; echo would not)
# ------------------------------------------------------------------------------
define title
	printf "\n$(BOLD)$(CYAN)==> %s$(RESET)\n" "$(1)"
endef
define success
	printf "$(GREEN)✔ %s$(RESET)\n" "$(1)"
endef
define warn
	printf "$(YELLOW)➜ %s$(RESET)\n" "$(1)"
endef
define err
	printf "$(RED)✖ %s$(RESET)\n" "$(1)"
endef

# ==============================================================================
# Help & information
# ==============================================================================
help: ## Display all available commands
	@printf "\n$(BOLD)$(CYAN)%s$(RESET)\n\n" "$(PROJECT_NAME)"
	@printf "$(GREEN)Available commands$(RESET)\n\n"
	@awk 'BEGIN {FS = ":.*##"} \
		/^[a-zA-Z0-9_.-]+:.*##/ \
		{ printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n"

version: ## Show project and toolchain versions
	@printf "Project : %s\n" "$(PROJECT_NAME)"
	@printf "Version : %s\n" "$(PROJECT_VERSION)"
	@printf "PHP     : %s\n" "$$($(PHP) -v | head -1)"
	@printf "Composer: %s\n" "$$($(COMPOSER) --version | head -1)"
	@printf "Node    : %s\n" "$$($(NODE) -v)"
	@printf "NPM     : %s\n" "$$($(NPM) -v)"

info: ## Display project paths
	@printf "Application : %s\n" "$(APP_DIR)"
	@printf "Config      : %s\n" "$(CONFIG_DIR)"
	@printf "Database    : %s\n" "$(DATABASE_DIR)"
	@printf "Resources   : %s\n" "$(RESOURCES_DIR)"
	@printf "Routes      : %s\n" "$(ROUTES_DIR)"
	@printf "Storage     : %s\n" "$(STORAGE_DIR)"
	@printf "Tests       : %s\n" "$(TESTS_DIR)"
	@printf "Vendor      : %s\n" "$(VENDOR_DIR)"

doctor: ## Verify required tools are installed
	@$(call title,Checking development environment)
	@for bin in $(PHP) $(COMPOSER) $(NPM) $(NODE) git; do
		if command -v "$$bin" >/dev/null 2>&1; then
			$(call success,$$bin found)
		else
			$(call err,$$bin missing)
			exit 1
		fi
	done
	@$(call success,Environment looks good)

# ==============================================================================
# Project lifecycle
# ==============================================================================
setup: install env key storage-link ## Complete first-time project setup
	@$(call success,Project setup completed)

install: composer-install npm-install ## Install all dependencies

update: composer-update npm-update ## Update all dependencies

validate: composer-validate composer-audit ## Validate composer.json and audit deps

env: ## Create .env from .env.example if missing
	@if [ -f "$(ENV_FILE)" ]; then
		$(call warn,$(ENV_FILE) already exists)
	else
		cp "$(ENV_EXAMPLE)" "$(ENV_FILE)"
		$(call success,$(ENV_FILE) created)
	fi

key: ## Generate the application key
	@$(ARTISAN) key:generate

storage-link: ## Create the public storage symlink
	@$(ARTISAN) storage:link

serve: ## Start the Laravel development server
	@$(ARTISAN) serve

dev: ## Start the Composer "dev" environment
	@$(COMPOSER) run dev

# ==============================================================================
# Composer
# ==============================================================================
composer-install: ## Install Composer dependencies
	@$(call title,Installing Composer packages)
	@$(COMPOSER) install
	@$(call success,Composer install completed)

composer-update: ## Update Composer dependencies
	@$(call title,Updating Composer packages)
	@$(COMPOSER) update
	@$(call success,Composer update completed)

composer-dump: ## Dump an optimized autoloader
	@$(COMPOSER) dump-autoload -o

composer-validate: ## Validate composer.json (strict)
	@$(COMPOSER) validate --strict

composer-audit: ## Check Composer security advisories
	@$(COMPOSER) audit

# ==============================================================================
# NPM
# ==============================================================================
npm-install: ## Install Node dependencies
	@$(call title,Installing Node packages)
	@$(NPM) install
	@$(call success,Node packages installed)

npm-update: ## Update Node dependencies
	@$(call title,Updating Node packages)
	@$(NPM) update
	@$(call success,Node packages updated)

npm-build: ## Build production assets
	@$(call title,Building production assets)
	@$(NPM) run build
	@$(call success,Production assets built)

npm-dev: ## Start the Vite development server
	@$(NPM) run dev

# ==============================================================================
# Laravel cache / optimization
# ==============================================================================
optimize: ## Optimize the framework
	@$(call title,Optimizing Laravel)
	@$(ARTISAN) optimize
	@$(call success,Laravel optimized)

clear: ## Clear all framework caches
	@$(call title,Clearing Laravel cache)
	@$(ARTISAN) optimize:clear
	@$(call success,Cache cleared)

cache: config-cache route-cache view-cache ## Build config, route and view caches

config-cache: ## Cache configuration
	@$(ARTISAN) config:cache

route-cache: ## Cache routes
	@$(ARTISAN) route:cache

view-cache: ## Cache Blade views
	@$(ARTISAN) view:cache

event-cache: ## Cache events
	@$(ARTISAN) event:cache

config-clear: ## Clear cached configuration
	@$(ARTISAN) config:clear

route-clear: ## Clear cached routes
	@$(ARTISAN) route:clear

view-clear: ## Clear compiled views
	@$(ARTISAN) view:clear

event-clear: ## Clear cached events
	@$(ARTISAN) event:clear

# ==============================================================================
# Database
# ==============================================================================
migrate: ## Run database migrations
	@$(call title,Running migrations)
	@$(ARTISAN) migrate
	@$(call success,Migrations completed)

rollback: ## Roll back the last migration batch
	@$(ARTISAN) migrate:rollback

rollback-step: ## Roll back one migration step
	@$(ARTISAN) migrate:rollback --step=1

seed: ## Seed the database
	@$(ARTISAN) db:seed

fresh: ## Drop all tables and re-run migrations
	@$(ARTISAN) migrate:fresh

fresh-seed: ## Fresh migration with seeding
	@$(ARTISAN) migrate:fresh --seed

refresh: ## Reset and re-run migrations
	@$(ARTISAN) migrate:refresh

refresh-seed: ## Refresh migrations with seeding
	@$(ARTISAN) migrate:refresh --seed

status: ## Show migration status
	@$(ARTISAN) migrate:status

# ==============================================================================
# Application control
# ==============================================================================
up: ## Bring the application out of maintenance mode
	@$(ARTISAN) up

down: ## Put the application into maintenance mode
	@$(ARTISAN) down

queue: ## Start a queue worker
	@$(ARTISAN) queue:work

queue-listen: ## Listen for queue jobs
	@$(ARTISAN) queue:listen

schedule: ## Run the scheduler once
	@$(ARTISAN) schedule:run

tinker: ## Open Tinker
	@$(ARTISAN) tinker

logs: ## Tail the Laravel log
	@tail -f "$(LARAVEL_LOG)"

# ==============================================================================
# Testing
# ==============================================================================
test: ## Run the test suite
	@$(call title,Running tests)
	@$(ARTISAN) test
	@$(call success,Tests completed)

test-parallel: ## Run tests in parallel
	@$(ARTISAN) test --parallel

test-coverage: ## Run tests with a coverage report
	@$(ARTISAN) test --coverage

test-stop: ## Run tests, stopping on first failure
	@$(ARTISAN) test --stop-on-failure

# ==============================================================================
# Code style
# ==============================================================================
lint: ## Check code style with Pint (no changes)
	@$(call title,Checking code style)
	@$(PINT) --test
	@$(call success,Code style passed)

format: ## Auto-format code with Pint
	@$(call title,Formatting source)
	@$(PINT)
	@$(call success,Formatting completed)

# ==============================================================================
# Maintenance
# ==============================================================================
discover: ## Re-discover packages
	@$(ARTISAN) package:discover

clear-compiled: ## Remove compiled class files
	@$(ARTISAN) clear-compiled

about: ## Show framework information
	@$(ARTISAN) about

inspire: ## Print an inspiring quote
	@$(ARTISAN) inspire

# ==============================================================================
# Cleanup
# ==============================================================================
clean: ## Remove generated cache, view and log files
	@$(call title,Cleaning generated files)
	@rm -rf bootstrap/cache/*.php
	@rm -rf $(STORAGE_DIR)/framework/cache/*
	@rm -rf $(STORAGE_DIR)/framework/views/*
	@rm -rf $(STORAGE_DIR)/framework/sessions/*
	@rm -rf $(STORAGE_DIR)/framework/testing/*
	@rm -rf $(STORAGE_DIR)/logs/*.log
	@$(call success,Cleanup completed)

clean-vendor: ## Remove the vendor directory
	@rm -rf $(VENDOR_DIR)
	@$(call success,vendor removed)

clean-node: ## Remove node_modules
	@rm -rf $(NODE_MODULES_DIR)
	@$(call success,node_modules removed)

clean-lock: ## Remove dependency lock files
	@rm -f composer.lock package-lock.json
	@$(call success,Lock files removed)

clean-all: clean clean-vendor clean-node clean-lock ## Remove everything except source

reinstall: clean-all setup ## Wipe and reinstall the project

# ==============================================================================
# Git
# ==============================================================================
git-status: ## Show working-tree status
	@git status

git-branch: ## Show the current branch
	@git branch --show-current

git-log: ## Show the last 15 commits as a graph
	@git log --oneline --decorate --graph -15

git-fetch: ## Fetch and prune all remotes
	@git fetch --all --prune

git-pull: ## Pull the current branch
	@git pull

git-diff: ## Show the working-tree diff
	@git diff

# ==============================================================================
# Validation & pipelines
# ==============================================================================
check: ## Validate project structure and dependencies
	@$(call title,Validating project)
	@fail=0
	for f in "$(COMPOSER_FILE)" "$(PACKAGE_FILE)" "$(ENV_FILE)"; do
		if [ -f "$$f" ]; then
			printf "$(GREEN)✔ %s$(RESET)\n" "$$f found"
		else
			printf "$(RED)✖ %s$(RESET)\n" "$$f missing"; fail=1
		fi
	done
	for d in "$(VENDOR_DIR)" "$(NODE_MODULES_DIR)"; do
		if [ -d "$$d" ]; then
			printf "$(GREEN)✔ %s$(RESET)\n" "$$d/ found"
		else
			printf "$(RED)✖ %s$(RESET)\n" "$$d/ missing"; fail=1
		fi
	done
	[ "$$fail" -eq 0 ] || { printf "$(RED)✖ %s$(RESET)\n" "project validation failed"; exit 1; }

quality: composer-validate composer-audit lint test ## Run the full quality pipeline
	@$(call success,Quality pipeline completed)

ci: check validate npm-build test ## Run the local CI pipeline
	@$(call success,Local CI completed)

reset-cache: clear cache ## Rebuild all framework caches

reset-db: fresh-seed ## Recreate the database from scratch and seed it

# ==============================================================================
# Aliases
# ==============================================================================
build: npm-build   ## Alias for npm-build
start: serve       ## Alias for serve
fmt:   format      ## Alias for format
qa:    quality     ## Alias for quality

# ==============================================================================
# Phony targets
# ==============================================================================
.PHONY: help version info doctor \
        setup install update validate env key storage-link serve dev \
        composer-install composer-update composer-dump composer-validate composer-audit \
        npm-install npm-update npm-build npm-dev \
        optimize clear cache config-cache route-cache view-cache event-cache \
        config-clear route-clear view-clear event-clear \
        migrate rollback rollback-step seed fresh fresh-seed refresh refresh-seed status \
        up down queue queue-listen schedule tinker logs \
        test test-parallel test-coverage test-stop \
        lint format discover clear-compiled about inspire \
        clean clean-vendor clean-node clean-lock clean-all reinstall \
        git-status git-branch git-log git-fetch git-pull git-diff \
        check quality ci reset-cache reset-db \
        build start fmt qa