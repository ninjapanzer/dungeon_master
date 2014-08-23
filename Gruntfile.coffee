"use strict"

module.exports = (grunt) ->

  # Show elapsed time after tasks run
  require("time-grunt") grunt
  # Load all Grunt tasks
  require("load-grunt-tasks") grunt

  grunt.initConfig

    # Configurable paths
    yeoman:
      app: "app"
      dist: "dist"

    # Watch runs tasks when specified files change
    watch:
      haml:
        files: ["<%= yeoman.app %>/*.haml", "<%= yeoman.app %>/templates_static/*.haml",]
        tasks: ["haml:dist", "cdn:html"]

      hamlbars:
        files: ["<%= yeoman.app %>/scripts/**/*.hamlbars", "<%= yeoman.app %>/templates_static/*.haml"]
        tasks: ["newer:haml:hamlbars"]

      handlebars:
        files: [".tmp/scripts/**/*.hbs"]
        tasks: ["handlebars:dist"]

      coffee:
        files: ["<%= yeoman.app %>/scripts/**/*.coffee"]
        tasks: ["newer:copy:coffee", "newer:coffee:dist", "copy:config:local"]

      compass:
        files: ["<%= yeoman.app %>/styles/**/*.{scss,sass}"]
        tasks: ["compass:server", "cdn:css", "autoprefixer"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          ".tmp/*.html"
          ".tmp/styles/**/*.css"
          ".tmp/scripts/**/*.js"
          "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    # Connect starts a simple webserver with rewrite rules and LiveReload
    connect:
      options:
        port: 9000
        livereload: 35729
        hostname: "0.0.0.0"
        base: [
          ".tmp"
          "<%= yeoman.app %>"
        ]

      # Server rewrite rules from grunt-connect-rewrite
      rules:
        "^/dungeon_master(.*)$": "/$1"

      livereload:
        options: {}

      noreload:
        options:
          livereload: false

      dist:
        options:
          livereload: false
          base: ["<%= yeoman.dist %>"]

    # Clean erases files before we run other tasks
    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: ".tmp"

    # Haml compiles static HAML and hamlbars templates to HTML
    haml:
      options:
        language: "ruby"
        rubyHamlCommand: "bundle exec haml -r ./haml_config.rb"

      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.haml"
          dest: ".tmp"
          ext: ".html"
        ]

      hamlbars:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["scripts/**/*.hamlbars", "!scripts/**/_*.hamlbars"]
          dest: ".tmp"
          ext: ".hbs"
        ]

    # Handlebars concatenates handlebars templates into a single JavaScript file
    handlebars:
      dist:
        options:
          amd: true
          processName: (filePath) ->
            filePath.replace(".tmp/scripts/", "").replace ".hbs", ""

        files: [".tmp/scripts/templates.js": ".tmp/scripts/**/*.hbs"]


    # Coffee compiles CoffeeScript to JavaScript
    coffee:
      options:
        bare: false
        sourceMap: true

      dist:
        files: [
          expand: true
          cwd: ".tmp/scripts"
          src: ["**/*.coffee"]
          dest: ".tmp/scripts"
          ext: ".js"
        ]

    # Compass compiles SCSS into CSS
    compass:
      options:
        # If you're using global Sass gems, require them here.
        require: ["sass-globbing", "bourbon", "neat", "jacket"]
        bundleExec: true
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        httpImagesPath: "/images"
        httpGeneratedImagesPath: "/images/generated"
        relativeAssets: false
        outputStyle: "expanded"
        importPath: "<%= yeoman.app %>/bower_components"
        raw: "extensions_dir = \"<%= yeoman.app %>/bower_components\"\n"

      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      server:
        options:
          generatedImagesDir: ".tmp/images/generated"

    # Autoprefixer adds vendor prefixes to compiled CSS
    autoprefixer:
      options:
        browsers: ["last 2 versions", "ie >= 9"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "**/*.css"
          dest: ".tmp/styles/"
        ]

    # UseminPrepare reads build blocks and creates configuration for build
    # tasks on the fly
    useminPrepare:
      options:
        dest: "<%= yeoman.dist %>"

      html: ".tmp/index.html"

    # Usemin replaces references to assets with their revved counterparts
    usemin:
      options:
        dirs: ["<%= yeoman.dist %>"]

      html: ["<%= yeoman.dist %>/**/*.html"]
      css: ["<%= yeoman.dist %>/styles/**/*.css"]

    # Requirejs concatenates AMD modules into a single JavaScript file
    # Usemin adds files to requirejs
    requirejs:
      dist:

      # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
        options:

        # `name` and `out` are set by grunt-usemin
          baseUrl: ".tmp/scripts"
          optimize: "none"
          preserveLicenseComments: false
          useStrict: true
          findNestedDependencies: true
          wrap: false
          paths:
            mathjax: 'empty:'
          # https://github.com/mishoo/UglifyJS2
          # uglify2: {}

    # Concat concatenates files
    # Usemin adds files to concat
    concat: {}

    # Uglify mini-and-uglifies JavaScript
    # Usemin adds files to uglify
    uglify:
      options:
        sourceMap: true

    # CSSmin minifies CSS
    # Usemin adds files to cssmin
    cssmin:
      dist:
        options:
          check: "gzip"

    # Imagemin losslessly optimizes images
    imagemin:
      dist:
        options:
          progressive: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/images"
          src: "**/*.{gif,jpg,jpeg,png}"
          dest: "<%= yeoman.dist %>/images"
        ]

    # SVGmin minifies SVG files
    # SVGmin will not minify svg fonts
    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/images"
          src: ["**/*.svg", "!fonts/**/*.svg"]
          dest: "<%= yeoman.dist %>/images"
        ]

    # HTMLmin minifies HTML
    # TODO: Test for IE8
    htmlmin:
      dist:
        options:
          collapseWhitespace: true
          removeComments: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]

    # CDN post-processes HTML and CSS, prefixing asset references with a path
    # or url
    # TODO: Add compiled js to task
    # TODO: Add target for build

    # Rev prefixes files with a hash for cachebusting
    rev:
      options:
        length: 4

      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/**/*.js"
            "<%= yeoman.dist %>/bower_components/**/*.js"
            "<%= yeoman.dist %>/bower_components/**/*.{gif,jpg,jpeg,png,svg,webp}"
            "<%= yeoman.dist %>/bower_components/**/*.{eot*,otf,svg,ttf,woff}"
            "<%= yeoman.dist %>/styles/**/*.css"
            "<%= yeoman.dist %>/images/**/*.{gif,jpg,jpeg,png,svg,webp}"
            "<%= yeoman.dist %>/fonts/**/*.{eot*,otf,svg,ttf,woff}"
          ]

    # Copy transports files not handled in other tasks
    copy:
      config:
        files: [
          src: ".tmp/scripts/config/config_<%= grunt.task.current.args[0] %>.js"
          dest: ".tmp/scripts/config/config.js"
        ]

      modernizrDist:
        files: [
          src: "app/scripts/vendor/modernizr-production.js"
          dest: ".tmp/scripts/vendor/modernizr.js"
        ]

      coffee:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>/scripts'
          dest: '.tmp/scripts'
          src: '**/*.coffee'
        ]

      dist:
        files: [{
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          src: [
            "*.{ico,png}"
            "*.txt"
            "*.html"
            "images/**/*.{gif,jpg,jpeg,png,svg,webp}"
            "fonts/**/*.{eot*,otf,svg,ttf,woff}"
            "bower_components/ttm-icons/*.{eot*,ttf,woff}"
            "bower_components/ttm-logos/*.{png,svg}"
            "bower_components/ttm-vendor-fonts/**/*.{eot*,otf,svg,ttf,woff}"
            "bower_components/javascript-calculator/dist/fonts/*"
            "bower_components/mediaelement/build/**/*.{png,svg}"
          ]
          dest: "<%= yeoman.dist %>"
        },
        {
          src: "<%= yeoman.app %>/gitignore"
          dest: "<%= yeoman.dist %>/.gitignore"
        }]

      # Copy compiled haml files to dist
      htmlDist:
        expand: true
        dot: true
        cwd: ".tmp"
        src: "*.html"
        dest: "<%= yeoman.dist %>"

      # Stage JS components into .tmp for Require.js concatenation
      # TODO: Usemin 2.0 should make this step obsolete.
      components:
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>/bower_components/"
        src: "**/*.{css,js}"
        dest: ".tmp/bower_components/"

    # JSHint lints Javascript files
    jshint:
      options:
        jshintrc: ".jshintrc"

      all: [
        "Gruntfile.js"
        "<%= yeoman.app %>/scripts/**/*.js"
        "test/spec/**/*.js"
      ]

    # Karma runs Karma unit tests
    karma:
      unit:
        configFile: "karma.conf.coffee"

    # Exec runs any shell command — we use it to run RSpec, among other things
    exec:
      options:
        stdout: true
        stderr: true

      rspecJenkins:
        cmd: "CI_REPORTS=test/reports bundle exec rspec -f 'CI::Reporter::RSpecFormatter' -f documentation"

      scalrDeploy:
        cmd: "bundle exec ttmscalr deploy lesson-player -f <%= grunt.task.current.args[0] %>"

      bundle:
        cmd: "bundle"

      npm:
        cmd: "npm install"

      bower:
        cmd: "bower update"

    # Commit built code and push to server
    buildcontrol:
      dist:
        options:
          dir: "dist"
          remote: "git@github.com:thinkthroughmath/aws-lesson-player.git"
          commit: true
          push: true
          message: "Built %sourceName% from commit %sourceCommit%"
          branch: "<%= grunt.task.current.args[0] %>"

    # Concurrent runs tasks in parallel for better performance
    concurrent:
      server: [
        "coffee:dist"
        "compass:server"
        "haml:dist"
        "haml:hamlbars"
        "copy:components" # Required for Karma testing
      ]

      dist: [
        "coffee:dist"
        "compass:dist"
        "haml:hamlbars"
        "copy:components" # Required for grunt-requirejs
        "copy:dist"
        "copy:htmlDist"
      ]

      install: [
        "exec:bundle",
        "exec:npm",
        "exec:bower"
      ]

  # Custom Grunt tasks
  grunt.registerTask 'data', 'Copy a specific student-info JSON file to .tmp.', (target) ->
    grunt.task.run ["copy:fakeData:#{target}"]

  grunt.registerTask "serve", "Run a local development server, or preview the built app", (target) ->
    target ||= "mc-guidedlearning"

    if target == "dist"
      tasks = [
        "build:local"
        "configureRewriteRules"
        "connect:dist:keepalive"
      ]
    else if target == "ci"
      tasks = [
        "build:local"
        "configureRewriteRules"
        "connect:dist"
      ]
    else
      tasks = [
        "clean:server"
        "copy:coffee"
        "concurrent:server"
        "autoprefixer:dist"
        "handlebars:dist"
        "configureRewriteRules"
        "cdn:html"
        "cdn:css"
        "copy:config:local"
      ]

      if target == "no-watch"
        tasks = tasks.concat [
          "data:mc-guidedlearning"
          "connect:noreload:keepalive"
        ]
      else
        tasks = tasks.concat [
          "data:#{target}"
          "connect:livereload"
          "watch"
        ]

    grunt.task.run tasks

  grunt.registerTask "build", "Builds a production-worthy version", (target) ->
    target ||= "local"
    tasks = [
      "clean:dist"
      "haml:dist"
      "useminPrepare"
      "copy:coffee"
      "copy:modernizrDist"
      "concurrent:dist"
      "autoprefixer:dist"
      "handlebars:dist"
      "copy:config:#{target}"
      "requirejs"
      "concat"
      "cssmin"
      "uglify"
      "imagemin"
      "svgmin"
      "rev"
      "usemin"
      "cdn:dist"
      "htmlmin"
    ]

    if target is "local"
      tasks.push "copy:fakeDataDist"
    grunt.task.run tasks

  grunt.registerTask "test", "Unit and CI integration tests", (target) ->
    if target is "unit"
      tasks = [ "karma:unit" ]
    else if target is "ci"
      tasks = [
        "karma:unit"
        "serve:ci"
        "exec:rspecJenkins"
      ]
    else
      grunt.warn "Specify either a :unit or :ci target."

    grunt.task.run tasks

  # TODO: Note or enforce this running only from ci env? Better way to run from
  # Jenkins?
  grunt.registerTask "deploy", "Builds and deploys to scalr.", (target) ->
    tasks = [
      "install"
      "test:ci"
      "build:#{target}"
      "buildcontrol:dist:#{target}"
      "exec:scalrDeploy:#{target}"
    ]
    grunt.task.run tasks

  grunt.registerTask "install", "Convenience command for running all of (bundle|npm|bower) install.", [
    "concurrent:install"
  ]

  grunt.registerTask "default", "Installs all dependencies and starts the dev server", [
    "install"
    "serve"
  ]
