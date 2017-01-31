build:
	./node_modules/gulp/bin/gulp.js build

generate-mod:
	./node_modules/gulp/bin/gulp.js generate-mod

package:
	rm -rf dist_package
	./node_modules/gulp/bin/gulp.js clean
	./node_modules/gulp/bin/gulp.js package
	cp -r dist dist_package
	find dist_package | grep "\.git\|DS_Store\|.swp" | xargs rm -rf
	cd dist_package && zip -r ../releases/webogram_v$(version).zip .

ghdist:
	rm -rf dist
	mkdir dist
	cp -r .git dist/
	cd dist && git checkout gh-pages

publish:
	./node_modules/gulp/bin/gulp.js publish
	@printf "Please open http://localhost:8000/dist/index.html and check if everything works fine."
	@read -e
	./node_modules/gulp/bin/gulp.js deploy

bump:
	./node_modules/gulp/bin/gulp.js bump

txinstall:
	curl -O https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py
	sudo python get-pip.py
	sudo pip install transifex-client

txupdate:
	tx pull -f

txupload:
	tx pull -f
	tx push -s

update-angular:
	@test $(version)
	@printf "Trying to upgrade angularjs to: $(version)\n" 
	mkdir tmp
	curl http://code.angularjs.org/$(version)/angular-$(version).zip -o tmp/angular.zip
	rm -fr app/vendor/angular
	unzip tmp/angular.zip -d app/vendor
	mv app/vendor/angular-$(version) app/vendor/angular
	rm -fr app/vendor/angular/docs tmp
