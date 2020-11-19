const gulp = require('gulp');
const svgo = require('gulp-svgo');

function build() {
    return gulp.src('node_modules/openmoji/color/svg/*.svg')
        .pipe(svgo())
        .pipe(gulp.dest('../assets/openmoji'));
}

exports.default = build;
