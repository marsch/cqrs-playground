source = require 'vinyl-source-stream'
gulp = require 'gulp'
gutil = require 'gulp-util'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
watchify = require 'watchify'
notify = require 'gulp-notify'
browserSync = require("browser-sync").create()
reload      = browserSync.reload

paths =
    srcFiles: ['./src/index.coffee']
    build: './build/'
    buildFile: 'index.js'


buildScript = (files, watch) ->
    rebundle = ->
        stream = bundler.bundle()
        stream.on("error", notify.onError(
            title: "Compile Error"
            message: "<%= error.message %>"
        ))
        .pipe(source(paths.buildFile))
        .pipe(gulp.dest(paths.build))
        .pipe(reload({stream: true}))

    props = watchify.args
    props.entries = files
    props.debug = true
    props.extensions = ['.js', '.coffee']

    bundler = (if watch then watchify(browserify(props)) else browserify(props))
    bundler.transform coffeeify
    bundler.on "update", ->
        rebundle()
        gutil.log "Rebundled..."
        gutil.log paths.srcFiles
        return

    rebundle()

gulp.task "html", ->
  gulp.src('./src/index.html')
  .pipe(gulp.dest('./build'))
  .pipe(reload({stream: true}))


gulp.task "default", ->
    buildScript paths.srcFiles, false

gulp.task "watch", ["html", "default"], ->
    browserSync.init(['./build/**.html', './build/**.js'], {
      server: {
        baseDir: "./build"
      }
    })
    buildScript paths.srcFiles, true
    gulp.watch('./build/index.html').on('change', reload)
    gulp.watch('./src/index.html', ['html'])
