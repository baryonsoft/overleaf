fs = require "fs"
spawn = require("child_process").spawn
rimraf = require "rimraf"

SERVICES = [{
	name: "web"
	repo: "git@github.com:sharelatex/web-sharelatex.git"
}, {
	name: "document-updater"
	repo: "git@github.com:sharelatex/document-updater-sharelatex.git"
}]


module.exports = (grunt) ->
	grunt.loadNpmTasks 'grunt-bunyan'
	grunt.loadNpmTasks 'grunt-execute'
	grunt.loadNpmTasks 'grunt-available-tasks'
	grunt.loadNpmTasks 'grunt-concurrent'

	grunt.initConfig
		execute:
			web:
				src: "web/app.js"
			'document-updater':
				src: "document-updater/app.js"

		concurrent:
			all:
				tasks: ['run:web', 'run:document-updater']
				options:
					logConcurrentOutput: true

		availabletasks:
			tasks:
				options:
					filter: 'exclude',
					tasks: [
						'concurrent'
						'execute'
						'bunyan'
						'availabletasks'
						]
					groups:
						"Run tasks": [
							"run"
							"run:all"
							"run:web"
							"run:document-updater"
							"default"
						]
						"Misc": [
							"help"
						]
						"Install tasks": ("install:#{service.name}" for service in SERVICES).concat(["install:all", "install"])
						"Update tasks": ("update:#{service.name}" for service in SERVICES).concat(["update:all", "update"])
						"Config tasks": ["install:config"]

	for service in SERVICES
		do (service) ->
			grunt.registerTask "install:#{service.name}", "Download and set up the #{service.name} service", () ->
				done = @async()
				Helpers.installService(service.repo, service.name, done)
			grunt.registerTask "update:#{service.name}", "Checkout and update the #{service.name} service", () ->
				done = @async()
				Helpers.updateService(service.name, done)
			grunt.registerTask "run:#{service.name}", "Run the ShareLaTeX #{service.name} service", ["bunyan", "execute:web"]

	grunt.registerTask 'install:all', "Download and set up all ShareLaTeX services", ("install:#{service.name}" for service in SERVICES)
	grunt.registerTask 'install', 'install:all'
	grunt.registerTask 'update:all', "Checkout and update all ShareLaTeX services", ("update:#{service.name}" for service in SERVICES)
	grunt.registerTask 'update', 'update:all'
	grunt.registerTask 'run', "Run all of the sharelatex processes", ['concurrent:all']
	grunt.registerTask 'run:all', 'run'

	grunt.registerTask 'install:config', "Install a custom config from a git repository (set SHARELATEX_CONFIG_REPO to the repository location)", () ->
		Helpers.installCustomConfig @async()

	grunt.registerTask 'help', 'Display this help list', 'availabletasks'
	grunt.registerTask 'default', 'run'

Helpers =
	installService: (repo_src, dir, callback = (error) ->) ->
		Helpers.cloneGitRepo repo_src, dir, (error) ->
			return callback(error) if error?
			Helpers.installNpmModules dir, (error) ->
				return callback(error) if error?
				Helpers.runGruntInstall dir, (error) ->
					return callback(error) if error?
					callback()

	updateService: (dir, callback = (error) ->) ->
		Helpers.updateGitRepo dir, (error) ->
			return callback(error) if error?
			Helpers.installNpmModules dir, (error) ->
				return callback(error) if error?
				Helpers.runGruntInstall dir, (error) ->
					return callback(error) if error?
					callback()

	cloneGitRepo: (repo_src, dir, callback = (error) ->) ->
		if !fs.existsSync(dir)
			proc = spawn "git", ["clone", repo_src, dir], stdio: "inherit"
			proc.on "close", () ->
				callback()
		else
			console.log "#{dir} already installed, skipping."
			callback()

	updateGitRepo: (dir, callback = (error) ->) ->
		proc = spawn "git", ["checkout", "master"], cwd: dir, stdio: "inherit"
		proc.on "close", () ->
			proc = spawn "git", ["pull"], cwd: dir, stdio: "inherit"
			proc.on "close", () ->
				callback()

	installNpmModules: (dir, callback = (error) ->) ->
		proc = spawn "npm", ["install"], stdio: "inherit", cwd: dir
		proc.on "close", () ->
			callback()

	runGruntInstall: (dir, callback = (error) ->) ->
		proc = spawn "grunt", ["install"], stdio: "inherit", cwd: dir
		proc.on "close", () ->
			callback()

	installCustomConfig: (callback = (error) ->) ->
		if !process.env.SHARELATEX_CONFIG_REPO?
			return callback(new Error("Please set the SHARELATEX_CONFIG_REPO enviroment variable to point to a git repository."))

		rimraf "config-local", (error) ->
			Helpers.cloneGitRepo process.env.SHARELATEX_CONFIG_REPO, "config-local", (error) ->
				return callback(error) if error?
				for file in fs.readdirSync("config-local")
					unless file == ".git"
						fs.symlinkSync("config-local/#{file}", "config/#{file}")
				callback()
