module.exports = (grunt) ->
    
    grunt.loadNpmTasks task for task in [
        "grunt-contrib-copy"
        "grunt-contrib-clean"
        "grunt-contrib-coffee"
        "grunt-contrib-jade"
        "grunt-contrib-sass"
        "grunt-contrib-watch"
        "grunt-contrib-uglify"
        "grunt-concurrent"
        "grunt-webpack"
        "grunt-contrib-cssmin"
        "grunt-jasmine-nodejs"
    ]
    
    grunt.initConfig
        copy:
            json:
                files: [
                    expand: true
                    cwd: "src"
                    src: ["**/*.json"]
                    dest: "build"
                ]
            static:
                files: [
                    expand: true
                    cwd: "src"
                    src: ["**/*.png"]
                    dest: "deploy"
                ]
        coffee:
            options:
                bare: true
            build:
                files: [
                            expand: true
                            cwd: "src"
                            src: ["**/**.unit.coffee"]
                            dest: "build"
                            ext: ".unit.js"
                        ,
                            expand: true
                            cwd: "src"
                            src: ["**/**.coffee", "!**/**.unit.coffee"]
                            dest: "build"
                            ext: ".js"                        
                    ]
        jade:
            build:
                expand: true
                cwd: "src"
                src: ["**/**.jade"]
                dest: "deploy"
                ext: ".html"
        sass:
            build:
                expand: true
                cwd: "src"
                src: ["**/**.scss"]
                dest: "build"
                ext: ".css"
        webpack:
            editor:
                entry: "./build/editor/eventBindings.js"
                output:
                    path: "build/editor"
                    filename: "packed.js"      
                module:
                    loaders: [
                            test: /\.json$/
                            loader: "json-loader"
                        ]
        uglify:
            build:
                files:
                    "deploy/editor/min.js": "build/editor/packed.js"     
        cssmin:
            editor:
                files:
                    "deploy/editor/min.css": ["build/*.css", "build/editor/**/*.css"]
        clean:
            js: "build/**/*.js"
            json: "build/**/*.json"
            css: ["build/**/*.css", "build/**/*.css.map"]
            html: ["build/**/*.html"]
            static: ["deploy/**/*.png"]
        jasmine_nodejs:
            unit:
                options:
                    specNameSuffix: ".unit.js"
                    reporters:
                        console:
                            verbosity: 2
                specs: ["build/**"]
        watch:
            js:
                options:
                    atBegin: true
                files: ["src/**/*.coffee"],
                tasks: ["clean:json", "copy:json", "clean:js", "coffee", "jasmine_nodejs", "webpack", "uglify"]
            css:
                options:
                    atBegin: true
                files: ["src/**/*.scss"]
                tasks: ["clean:css", "sass", "cssmin"]
            html:
                options:
                    atBegin: true
                files: ["src/**/*.jade"]
                tasks: ["clean:html", "jade"]
            json:
                files: ["src/**/*.json"]
                tasks: ["clean:json", "copy:json", "webpack", "uglify"]
            static:
                options:
                    atBegin: true
                files: ["src/**/*.png"]
                tasks: ["clean:static", "copy:static"]
        concurrent:
            buildAndDeploy:
                options:
                    logConcurrentOutput: true
                tasks: [
                    "watch:js"
                    "watch:css"
                    "watch:html"
                    "watch:json"
                    "watch:static"
                ]
